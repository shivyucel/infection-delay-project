import os
from multiprocessing import Pool
import pandas as pd
import numpy as np
import glob


import sys
data_path = '/Users/shivyucel/Documents/Github.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/'

#file path to all 2599 infection delay tables
file_directory = ''
file_list = glob.glob(file_directory)


#get dictionary with all 2599 tables loaded
new_dic = {}
for file in file_list:
    ts = pd.read_csv(file, index_col = 'Unnamed: 0')
    ts = ts.clip(lower=0)
    new_dic[file] = ts
    

counter = {}
time_dic = {}
count = 0 

#get all region IDs
all_locations = pd.Series(new_dic[file_list[0]].columns).append(pd.Series(new_dic[file_list[1]].columns))
all_locations.drop_duplicates(inplace=True)

#concatenate every region's infection delays across all outbreak scenarios
#iterate across dictionary to find all of a region's infection delay curves and turn them into one table
output_directory = ''
def get_all_time_saved(location):
    loc_df = pd.DataFrame()
    for key in list(new_dic.keys()):
        if key.split('/')[-1][:-4] != location:
            to_concat = pd.DataFrame(new_dic[key][location])
            to_concat.columns =  [key.split('/')[-1][:-4]]
            loc_df = pd.concat([loc_df, to_concat], axis=1)

    loc_df.to_csv(output_directory + f'{str(location)}.csv')

#takes multiple hours to run

for location in all_locations:
    get_all_time_saved(location)
    