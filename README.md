# infection_delay_code
# infection_delay_code

This GitHub repository contains all of the code required for the preprocessing, implementation, and subsequent analysis of the Infection Delay Model paper.

## 1. Preprocessing

Contains the code for the interpolation of census and commuting survey data to the h3 hexagons.

## 2. Effective Distance/SIR Model

Once the preprocessing is complete, this directory contains the necessary steps to calculate the dominant path effective distances on the h3-interpolated commuting network. This includes both the baseline and real mobility reduction scenarios. The h3 hexagons used in the analysis must be filtered by coordinating across the SIR and effective distance files, to ensure that all conditions necessary to run the analyses are met. The hexagons must have mobility data immediately before and after the lockdown, and must meet a threshold in the population-commuter table in the SIR model's code.

## 3. Infection Delay Code

Calculates the infection delay values for every region across all outbreak scenarios -- each of the 2599 output files show the infection delay values for every recipient location, for a given outbreak location. Changes the orientation so that each file represents the infection delay values for a single recipient location across all outbreak scenarios.

## 4. Results

The results file first organizes the income and centrality data, then creates the weighted median infection delay values and the unweighted median infection delay values. It also divides the outbreak locations into top and bottom 50% in-degree centrality groups, and calculates each region's median infection delay under each centrality grouping. 