

This repository contains the MATLAB implementation and data for the paper:


Chen, Y, Srivastava, A., and Park, C., (in press) Statistical Emulations of Human Operational Motions in Industrial Environments


 **Prerequisites** 


1.MATLAB

-  Tested on version R2024a 
-  Required Toolboxes: Curve Fitting, Statistics and Machine Learning              

2.This project uses the MATLAB\-to\-Python interface for the baseline method implemtation.. 

-  Python Version: 3.9  
-  Required Packages: 'numpy==1.24.3' , 'torch: 2.7.0', 'gpflow: 2.9.0', 'tensorflow: 2.13.0' 

External Dependencies:


The following packages and functions must be downloaded and added to the MATLAB path before running the script *`PCA_Result_Figure6_7_10.m`*

1.  tensor\_toolbox\-v3.6: [Tensor Toolbox Version 3.6 (R2023b) 28\-Sep\-2023 · tensors / tensor\_toolbox · GitLab](https://gitlab.com/tensors/tensor_toolbox/-/releases/v3.6)
2. MPCA fucntion: [Multilinear Principal Component Analysis (MPCA) \- File Exchange \- MATLAB Central](https://www.mathworks.com/matlabcentral/fileexchange/26168-multilinear-principal-component-analysis-mpca)


**Project Structure:**

-  *`run_all_simulations.m`* **\- Master Script 1** : Contains the full simulation pipeline. 
-  *`generate_all_results.m`* \- **Master Script 2**: Aggregates data and generates all evaluation tables. 
-  *`generate_figures.m`* \- **Master Script 3**: Aggregates data and generates figures and tables. 
-  *`data/`* \- Contains preprocessed raw data used as simulation input. 
-  *`functions/`* \- Core utility and processing functions. 
-  *`metrics/`* \- Evaluation metrics and pre\-computed model (e.g., clustering results and kernel density). 
-  *`scripts/`* \- Individual simulation execution scripts for different datasets. 
-  *`baselinemethods/`* \- Implementations and wrappers for comparison methods. 
-  *`results/`* \- Output directory for `.mat` files and generated figures. 
-  *`supplementary/`* \- Scripts for figures and tables in the Supplementary Information. 

**Setup**


Clone the repository and add all subfolders to your MATLAB path: *`addpath(genpath(pwd));`*


**Reproducing Results**

-  To generate the figures and tables exactly as they appear in the paper using the provided pre\-computed data: Run *`generate_all_results.m`* and *`generate_figures.m`* 
-  To re\-run the simulations from scratch: Run *`run_all_simulations.m.`* 

**Copyright ©2026 Yanliang Chen**


**Academic Credit & Collaborations**

-  The clustering method is based on the work by Deng et al. (2022) 
-  The visulization and geometry operations were re\-implemented by the author for this pipeline, the original logic remains the intellectual property of the original authors. 
