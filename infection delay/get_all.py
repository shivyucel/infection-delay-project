import os
from multiprocessing import Pool
import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
matplotlib.rc('figure', dpi=200)
import glob
import pandas as pd
import seaborn as sns

from scipy.cluster.hierarchy import fcluster

from tslearn.clustering import TimeSeriesKMeans

import sys
data_path = '/Users/shivyucel/Documents/Github.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/'

#populations = np.loadtxt(data_path + 'SIR/v1_populations.txt')
#
#populations = pd.Series(populations)
#
#
#top_1000 = populations.sort_values(ascending=False).index
#
#
#top_1000_files = [data_path + f'SIR/time_saved/DPED/new_real_reduction/all/{x}.csv' for x in top_1000]
file_list = glob.glob('/Volumes/harddrive/Data/v2_uniform_infection_delays/*')


new_dic = {}
for file in file_list:
    ts = pd.read_csv(file, index_col = 'Unnamed: 0')
    ts = ts.clip(lower=0)
    new_dic[file] = ts
    

counter = {}
time_dic = {}
count = 0 

all_locations = pd.Series(new_dic[file_list[0]].columns).append(pd.Series(new_dic[file_list[1]].columns))
all_locations.drop_duplicates(inplace=True)

def get_all_time_saved(location):
    loc_df = pd.DataFrame()
    for key in list(new_dic.keys()):
        if key.split('/')[-1][:-4] != location:
            #try:
            to_concat = pd.DataFrame(new_dic[key][location])
            to_concat.columns =  [key.split('/')[-1][:-4]]
            loc_df = pd.concat([loc_df, to_concat], axis=1)
            #except:
             #   continue
    loc_df.to_csv(f'/Volumes/harddrive/Data/v2_uniform_concat/{location}.csv')


current = glob.glob('/Volumes/harddrive/Data/v2_uniform_concat/*')
current.sort()

#current = pd.Series(current)
#current = current.str.split('/')
#current = [x[-1] for x in current]
#current = [x.split('.') for x in current]
#current = [x[0] for x in current]

allnums = pd.Series(np.arange(0, 2599)).astype(str)
to_do = [str(x) for x in allnums.values if x not in current]
#to_do = [f'/Volumes/harddrive/Data/v2_uniform_infection_delays/{x}.csv' for x in to_do]

for location in to_do:
    get_all_time_saved(location)
    
#all_files =   glob.glob
#from multiprocessing import Pool
#
#
#if __name__ == '__main__':
#    with Pool(8) as p:
#        print(p.map(get_all_time_saved, all_locations.values))