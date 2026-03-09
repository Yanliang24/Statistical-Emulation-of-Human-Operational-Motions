#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import torch
import torch.nn as nn
import numpy as np
import torch.nn.functional as F

class MotionLSTM(nn.Module):
    def __init__(self, input_size=60, hidden_size=128, num_layers=2):
        super(MotionLSTM, self).__init__()
        self.lstm = nn.LSTM(input_size, hidden_size, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_size, input_size)

    def forward(self, x):
        out, _ = self.lstm(x)
        return self.fc(out)

def _prepare_sequences(motion_cells):
    motion_sequences = []
    # MATLAB passes a (1, 60) cell as a py.list or numpy object array
    # We ensure we are iterating over the 60 items
    data_list = [np.array(item, copy=True, dtype=np.float32) for item in motion_cells]

    for seq in data_list:
        # Input shape from MATLAB: (20, T, 3)
        # 1. Transpose to (Time, Joints, XYZ) -> (T, 20, 3)
        seq_t = seq.transpose(1, 0, 2)
        
        # 2. Reshape to (Time, Features) -> (T, 60)
        flattened = seq_t.reshape(-1, 60)
        motion_sequences.append(flattened)
        
    return motion_sequences

def train_motion_model(data_from_matlab, hidden_size=128, num_layers=2, num_epoch = 500):
    flattened = _prepare_sequences(data_from_matlab)
    
    # Batch tensors: [Batch, Time, 60]
    X_tensor = torch.stack([torch.tensor(s[:-1], dtype=torch.float32) for s in flattened])
    Y_tensor = torch.stack([torch.tensor(s[1:], dtype=torch.float32) for s in flattened])

    model = MotionLSTM(input_size=60, hidden_size=int(hidden_size), num_layers=int(num_layers))
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

    model.train()
    for epoch in range(num_epoch):
        optimizer.zero_grad()
        output = model(X_tensor)
        # Using simple MSE for debugging; you can swap back to combined_loss
        loss = F.mse_loss(output, Y_tensor)
        loss.backward()
        torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
        optimizer.step()
        if (epoch + 1) % 100 == 0:
            print(f"Epoch {epoch+1}, Loss: {loss.item():.4f}")
    
    return model

def simulate_motion(model, data_from_matlab, seed_val, seed_length=30, sim_length=271):
    torch.manual_seed(int(seed_val))
    np.random.seed(int(seed_val))

    flattened = _prepare_sequences(data_from_matlab)
    X_tensor = torch.stack([torch.tensor(s[:-1], dtype=torch.float32) for s in flattened])

    model.eval()
    generated_results = []

    seed_length = int(seed_length)
    sim_length = int(sim_length)
    total_length = seed_length + sim_length

    with torch.no_grad():
        for i in range(X_tensor.size(0)):
            # Seed with 30 frames: [1, 30, 60]
            seed_seq = X_tensor[i, :seed_length, :].unsqueeze(0) 
            generated = [seed_seq]

            for _ in range(sim_length):
                output = model(seed_seq)
                next_frame = output[:, -1:] # [1, 1, 60]
                generated.append(next_frame)
                seed_seq = torch.cat([seed_seq[:, 1:], next_frame], dim=1)

            full_sequence = torch.cat(generated, dim=1).squeeze(0) # [T, 60]
            full_sequence_np = full_sequence.numpy() # [T, 60]
            temp_seq = full_sequence_np.reshape(total_length, 20, 3).copy()
            final_seq = temp_seq.transpose(1, 0, 2)
            final_seq_contiguous = np.ascontiguousarray(final_seq)
            generated_results.append(final_seq_contiguous)

    return generated_results