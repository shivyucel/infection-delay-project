import pandas as pd
import numpy as np
from final_model import SIRModel
import matplotlib
import matplotlib.pyplot as plt
matplotlib.rc('figure', dpi=200)
import glob
import pandas as pd
import seaborn as sns

from scipy.cluster.hierarchy import fcluster


data_path = '/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/'

populations = np.loadtxt(data_path + 'h3/population/new_h3_pop.csv', delimiter =',')

baseline_infection_delay_path
baseline = np.loadtxt(data_path + baseline_infection_delay_path)

reduced_infection_delay_path = ''
reduced = np.loadtxt(data_path + reduced_infection_delay_path)

#epidemiological parameters for the effective velocity
mu = 1/9.2
R0=2.9

time_saved = (reduced - baseline)/((mu*R0) - mu)

#input infection delay table for all regions for a given outbreak location
def get_time_saved(outbreak_file):
    time_saved_dic = {}
    arrival_times = pd.read_csv(outbreak_file)
    arrival_times.rename(columns={'0':'arrival'}, inplace=True)
    outbreak_location = int(outbreak_file.split('/')[-1][:-4])
    arrival_times.loc[outbreak_location, 'arrival'] = arrival_times.loc[outbreak_location, 'arrival'] = 0
    time_saved_dic[f'outbreak_{outbreak_location}'] = {}
    
    # for a given outbreak table
    # for every recipient region
    # for every time t
    # find the places already infected, find the one with the minimum infection delay (time saved) to the recipient location
    # select that infection delay value, move onto the next time t
    for index, row in arrival_times[arrival_times.index != outbreak_location].iterrows():
        time_saved_dic[f'outbreak_{outbreak_location}'][index] = {}
        for t in range(0, int(arrival_times['arrival'].max()+1)):
            arrived = arrival_times[arrival_times['arrival'] <= t]
            arrived = arrived.reset_index()
            arrived['index'] = arrived['index'].astype(int)
            arrived_index = np.array(arrived['index'])
            closest_time_saved = time_saved[arrived_index, index].min()
            time_saved_dic[f'outbreak_{outbreak_location}'][index][t] = closest_time_saved
            
        time_saved_dic[f'outbreak_{outbreak_location}'][index][t + 1] = 0
    df = pd.DataFrame()
    for key in time_saved_dic[f'outbreak_{outbreak_location}'].keys():    
        df[key] = time_saved_dic[f'outbreak_{outbreak_location}'][key].values()
    # create dataframe of infection delay time series for a given outbreak locations

    output_directory = ''
    filepath = ''
    df.to_csv(output_directory + filepath)
    
from multiprocessing import Pool

current = glob.glob(file_path)
current.sort()

#this takes 12+ hours to run

if __name__ == '__main__':
    with Pool(8) as p:
        print(p.map(get_time_saved, to_do))
