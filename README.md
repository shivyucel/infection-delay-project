# Infection Delay Data and Code

This GitHub repository contains all of the code required for the preprocessing, implementation, and subsequent analysis of the Infection Delay Model paper. It also contains the raw data required for the project, along with inputs to the main models, and final result data sets. 

## Data 
**Stored here: https://www.dropbox.com/sh/04dkaz5rlhmvueu/AADr_cMxxmqBp-GJq4Mb0_Axa?dl=0**

The raw data folder contains the census and commuting data, along with the relevant shapefiles and labels. 

The prelim_data folder contains the h3_IDs table, used to numerically identify hexagons (more info included in info file in folder). It also includes the commuting data, already preprocessed using code in the Effective Distance/SIR Model folder to filter out regions which do not have suitable data. 

The SIR_model_inputs folder has the mobility matrix based on the commuting data, and the population data (both already filtered to include suitable regions, same as above).

The infection_delay_inputs folder contains the baseline and real mobility effective distance matrices. 

The mobility_data folder contains the raw mobility data from March - September 2020 (raw_mobility_data.csv), the mobility reductions across all hexagons with data around the lockdown (mobility_reduction.csv), and the mobility change (filtered_mobility_reduction.csv) used in the effective_distance_real_changes.py code, filtered for the regions which are suitable for the effective distance/SIR calculations. 

The result_data folder contains the tables used to generate the results, including the weighted median 10-day infection delay values for every region, the outbreak divided results, merged with income and centrality data. The final data files are 'weighted_hexagon_data.csv' and 'longford_outbreak_split_delays'.

NOTE: The raw infection delay files take up 30+ GB of storage, and are not included here. In both mobility scenario, 2599 tables are generated, each with 2599 columns, representing the time series of every hexagon for every outbreak scenario. These are then duplicated in reorient_infection_delay_tables.py, to make them amenable to analysis.


## Code

### 1. Preprocessing

Contains the code for the interpolation of census, income, and commuting survey data to the h3 hexagons.

### 2. Effective Distance/SIR Model *


Once the preprocessing is complete, this directory contains the necessary steps to calculate the dominant path effective distances on the h3-interpolated commuting network. This includes both the baseline and real mobility reduction scenarios. The h3 hexagons used in the analysis must be filtered by coordinating across the SIR and effective distance files, to ensure that all conditions necessary to run the analyses are met. 

The hexagons must have mobility data immediately before and after the lockdown, and must meet a threshold in the population-commuter table in the SIR model's code. These steps are already incorporated in this repo's effective distance and commuting data.

### 3. Infection Delay Code

Calculates the infection delay values for every region across all outbreak scenarios. The code outputs 2599 files, each one showing the infection delay values for every recipient location, for a given outbreak location. The other file changes the orientation so that each file represents the infection delay values for a single recipient location across all outbreak scenarios.


### 4. Results

The results file first organizes the income and centrality data, then creates the weighted median infection delay values and the unweighted median infection delay values. It also divides the outbreak locations into top and bottom 50% in-degree centrality groups, and calculates each region's median infection delay under each income and centrality grouping. 

--------------------------------------------------------------------------------------------------
Effective Distance code from: https://github.com/andreaskoher/effective_distance

Iannelli, F., Koher, A., Brockmann, D., Hövel, P., & Sokolov, I. M. (2017). Effective distances for epidemics spreading on complex networks. Physical Review. E, 95(1–1), 12313. https://doi.org/10.1103/PhysRevE.95.012313

Note: adjustments to effective_distance codea re made in effective_distance_real_changes.py to incorporate real mobility adjustments.

SIR Model code from: https://github.com/franksh/EpiCommute

Schlosser, F., Maier, B. F., Jack, O., Hinrichs, D., Zachariae, A., & Brockmann, D. (2021). COVID-19 lockdown induces disease-mitigating structural changes in mobility networks. Proceedings of the National Academy of Sciences of the United States of America, 117(52), 32883–32890. https://doi.org/10.1073/PNAS.2012326117
