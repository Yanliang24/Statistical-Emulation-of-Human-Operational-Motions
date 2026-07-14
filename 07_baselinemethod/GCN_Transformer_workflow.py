import torch
import torch.nn as nn
import torch.optim as optim
import numpy as np
from torch.nn.utils.rnn import pad_sequence
from torch.utils.data import DataLoader, TensorDataset


class GraphConv(nn.Module):
    def __init__(self, in_channels, out_channels, A):
        super().__init__()
        self.A = A  # [K, J, J]
        self.K = A.size(0)
        self.conv = nn.Conv2d(in_channels, out_channels * self.K, kernel_size=1)

    def forward(self, x):  # x: [B, C, T, J]
        B, C, T, J = x.shape
        x = self.conv(x).view(B, self.K, -1, T, J)  # [B, K, D, T, J]
        x = x.permute(0, 1, 2, 4, 3)  # [B, K, D, J, T]
        out = torch.einsum("kij,bkdjt->bkdti", self.A, x)
        out = out.sum(dim=1)  # sum over K -> [B, D, T, J]
        return out  # [B, D, T, J]


# ---------- Motion Generator from Seed ----------
class MotionGeneratorFromSeed(nn.Module):
    def __init__(self, in_channels, num_joints, hidden_dim, A, T_out, cond_dim=None):
        super().__init__()
        self.gcn = GraphConv(in_channels, hidden_dim, A)
        self.T_out = T_out
        self.num_joints = num_joints
        self.in_channels = in_channels

        input_dim = hidden_dim * num_joints
        if cond_dim:
            self.condition_embed = nn.Linear(cond_dim, input_dim)
        else:
            self.condition_embed = None

        self.temporal_pos_enc = nn.Parameter(torch.randn(T_out, input_dim))

        self.decoder = nn.TransformerDecoder(
            nn.TransformerDecoderLayer(d_model=input_dim, nhead=1, dim_feedforward=input_dim),
            num_layers=1
        )

        self.output_layer = nn.Linear(input_dim, num_joints * in_channels)

    def forward(self, seed, condition=None):
        B, T_seed, J, C = seed.shape
        x = seed.permute(0, 3, 1, 2)  # [B, C, T, J]
        x = self.gcn(x)  # [B, D, T, J]
        #x = x[:, :, -1]  # last frame: [B, D, J]
        #x = x.permute(0, 2, 1).reshape(B, -1).unsqueeze(0)  # [1, B, J*D]
        
        x = x.permute(0, 3, 2, 1).reshape(B, -1, self.num_joints * x.shape[1])  # [B, T_seed, J*D]
        x = x.permute(1, 0, 2)  # [T_seed, B, J*D]
        
        tgt = self.temporal_pos_enc.unsqueeze(1).repeat(1, B, 1)  # [T_out, B, J*D]

        if condition is not None:
            cond_embed = self.condition_embed(condition).unsqueeze(0)  # [1, B, J*D]
            x = x + cond_embed

        out = self.decoder(tgt=tgt, memory=x)  # [T_out, B, J*C]
        out = self.output_layer(out).permute(1, 0, 2).reshape(B, self.T_out, J, C)
        return out  # [B, T_out, J, C]


def prepare_data_from_matlab(motion_cells):
    """
    Converts MATLAB cell array (passed as py.map or py.list) 
    into a Torch tensor [B, T, J, C].
    """
    motion_sequences = []
    for item in motion_cells:
        seq = np.array(item, dtype=np.float32).transpose(1, 0, 2)
        motion_sequences.append(torch.from_numpy(seq))
    
    return torch.stack(motion_sequences)

def train_gcn_model(motion_cells, cond_data, A_matlab, seed_length, hidden_dim, epochs, random_seed):
    seed_val = int(random_seed)
    torch.manual_seed(seed_val)
    np.random.seed(seed_val)

    # Convert data inside Python
    motion_batch = prepare_data_from_matlab(motion_cells)
    condition = torch.tensor(np.array(cond_data)).float()
    
    B, T, J, C = motion_batch.shape
    s_len = int(seed_length)
    
    seed = motion_batch[:, :s_len]
    target = motion_batch[:, s_len:]
    
    A_np = np.array(A_matlab, dtype=np.float32)
    A = torch.from_numpy(A_np).unsqueeze(0) 

    model = MotionGeneratorFromSeed(
        in_channels=C, num_joints=J, hidden_dim=int(hidden_dim), 
        A=A, T_out=target.shape[1], cond_dim=condition.shape[1]
    )
    
    optimizer = optim.Adam(model.parameters(), lr=1e-3,weight_decay=1e-4)
    loss_fn = nn.MSELoss()
    
    model.train()
    for epoch in range(int(epochs)):
        optimizer.zero_grad()
        output = model(seed, condition)
        loss = loss_fn(output, target)
        loss.backward()
        optimizer.step()
        if epoch == 0 or (epoch + 1) % 20 == 0:
            print(f"Epoch {epoch+1}/{epochs}, Loss: {loss.item():.4f}")
            
    return model

def generate_gcn_motion(model, seed_cells, cond_data, seed_length, random_seed):
    # Set fixed seed for reproducibility
    seed_val = int(random_seed)
    torch.manual_seed(seed_val)
    np.random.seed(seed_val)
    
    model.eval()
    # 1. Process the full original data to extract the seed
    # shape: [B, T_total, J, C]
    full_data_tensor = prepare_data_from_matlab(seed_cells) 
    
    B, T_total, J, C = full_data_tensor.shape
    n = int(seed_length)
    
    # 2. Extract the first 'n' frames as seed
    seed_seq = full_data_tensor[:, :n, :, :] # [B, n, J, C]
    condition = torch.from_numpy(np.array(cond_data)).float()
    
    with torch.no_grad():
        # model generates (T_total - n) frames
        generated = model(seed_seq, condition) 
        
        # 3. Concatenate seed + generated to maintain original total length
        full_generated_sequence = torch.cat([seed_seq, generated], dim=1)
    
    # Convert back to MATLAB format [J, T, C]
    output_list = []
    for seq in full_generated_sequence.cpu().numpy():
        out_seq = np.transpose(seq, (1, 0, 2))
        output_list.append(np.ascontiguousarray(out_seq))
        
    return output_list