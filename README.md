This repository contains the MATLAB implementation and data for the paper:


Chen, Y, Srivastava, A., and Park, C., Statistical Emulations of Human Operational Motions in Industrial Environments


 ## **Prerequisites** 


1.MATLAB

-  Tested on version R2024a 
-  Required Toolboxes: Deep Learning, Statistics and Machine Learning, Econometrics, Communication              

2.This project uses the MATLAB\-to\-Python interface for the baseline method implemtation.. 

-  Python Version: 3.9  
-  Required Packages: 'numpy==1.24.3' , 'torch: 2.7.0', 'gpflow: 2.9.0', 'tensorflow: 2.13.0' 

External Dependencies:


The following packages and functions must be downloaded and added to the MATLAB path before running the script *`PCA_Result_Figure6_7_10.m`*

1.  tensor\_toolbox\-v3.6: [Tensor Toolbox Version 3.6 (R2023b) 28\-Sep\-2023 · tensors / tensor\_toolbox · GitLab](https://gitlab.com/tensors/tensor_toolbox/-/releases/v3.6)
2. MPCA fucntion: [Multilinear Principal Component Analysis (MPCA) \- File Exchange \- MATLAB Central](https://www.mathworks.com/matlabcentral/fileexchange/26168-multilinear-principal-component-analysis-mpca)


## **Project Structure:**

-  *`run_all_simulations.m`* - **Master Script 1** : Contains the full simulation pipeline and saves the raw outputs.
    - Note: This script handles the heavy computation only; it does not generate individual tables or figures directly.  
-  *`generate_all_results.m`* - **Master Script 2**: Aggregates data and generates all evaluation tables.
    -  Main Manuscript: Table 2, 3, 4, 5, and 6.
    -  Supplementary Material: Table 1 to 14.
-  *`generate_figures.m`* - **Master Script 3**: Aggregates data and generates figures and tables.
    -  Tables: Table 1.
    -  Figures & Panels: 1c, 2, 5d-e, 6-11, 12b-c.
    -  Note: Remaining panels for Figures 1, 5, and 12 are generated using external tools.
-  *`generate_two_level_simulation_results.m`* - **Master Script 4**: Aggregates results for table 7 and figure 13.
-  *`01_data/`* - Contains preprocessed raw data used as simulation input. 
-  *`02_functions/`* - Core utility and processing functions. 
-  *`03_metrics/`* - Evaluation metrics and pre-computed model (e.g., clustering results and kernel density). 
-  *`04_simulation_scripts/`* - Individual simulation execution scripts for different datasets.
-  *`05_figure_scripts/`* - Individual execution scripts to generate figures and tables.
-  *`06_results/`* - [Empty]Output directory for `.mat` files and generated figures.
    - `/WorkerData/`: Subfolder for `.mat` files of the Worker dataset results.
    - `/exerciseData/`: Subfolder for `.mat` files of the Exercise dataset results.
    - `/TwoLevelSimulation/`: Subfolder for `.mat` files of the two level simulation results.
    - `/figures/`: Subfolder for exported `.pdf` visualizations.
-  *`07_baselinemethod/`* - Implementations and wrappers for comparison methods. 
-  *`08_supplementary/`* - Scripts for figures and tables in the Supplementary Information.
-  *`CreateVideos.m`* - Additional tool for creating videos from the skeleton data. 

## **Data Summary**
The provided data consists of pre-processed skeleton sequences stroed in *`.mat`* files. All data is preprocessed, including normalization and temporal registration, as descripbed in Sec. 3.
-  Worker Motion:
    -    5 Motion class stored in a standalone *`.mat`* file with filename *`RWP_[ClassID]_Outcome_300.mat`*. For example, *'RWP_1_Outcome_300.mat`* is the first motion class.
    -    In each *`.mat`* file, *`aligned`* is the preprocessed posture data and *`tree`* is the hierachy tree of the landmarks
-  Exercise Motion:
    -    1 Motion class stored in a *`.mat`* file with filename *`MotionNew_Outcome_800.mat`*
    -    In each *`.mat`* file, *`X`* is the preprocessed posture data and *`tree`* is the hierachy tree of the landmarks

## **Setup**

Clone the repository and add all subfolders to your MATLAB path: *`addpath(genpath(pwd));`*

## **Reproducing Results**

To maintain a lightweight repository, this package contains the **Raw Data** and **Initialization Seeds** only. 
The processed data are **not included** due to their significant file size (>2GB). 
To reproduce the results presented in the paper, the full simulation pipeline must be executed locally.

-  To re\-run the simulations from scratch: Run *`run_all_simulations.m.`* 
-  To generate the figures and tables exactly as they appear in the paper using the provided pre\-computed data: Run *`generate_all_results.m`*, *`generate_figures.m`*, and *`generate_two_level_simulation_results.m`*

## **Estimated Runtime**

-  The simulation of each dataset is expected to take upwards of 8–12 hours.
-  Running the full pipeline consecutively may require 24 hours uninterrupted computation.

**Academic Credit & Collaborations**

-  The clustering method is based on the work by Deng et al. (2022) 
-  The geometry operations were re\-implemented by the author for this pipeline, the original logic remains the intellectual property of the original authors.
-  The visulization functions were modified by the author for this piple line, the original logic remains the intellectual property of the original authors.
