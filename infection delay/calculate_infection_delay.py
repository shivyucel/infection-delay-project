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

baseline = np.loadtxt(data_path + f'h3/effective_distance/updated2/DPED_real_commuting.csv')

reduced = np.loadtxt(data_path + f'h3/effective_distance/updated2/v2_uniform_DPED_real_commuting.csv')


#beta (infection rate) = mu * R0
#mu (recovery rate)

#arrival time = EDij/(beta-mu)

mu = 1/9.2
R0=2.9

time_saved = (reduced - baseline)/((mu*R0) - mu)

def get_time_saved(outbreak_file):
    time_saved_dic = {}
    arrival_times = pd.read_csv(outbreak_file)
    arrival_times.rename(columns={'0':'arrival'}, inplace=True)
    outbreak_location = int(outbreak_file.split('/')[-1][:-4])
    arrival_times.loc[outbreak_location, 'arrival'] = arrival_times.loc[outbreak_location, 'arrival'] = 0
    time_saved_dic[f'outbreak_{outbreak_location}'] = {}
    
    
    for index, row in arrival_times[arrival_times.index != outbreak_location].iterrows():
        time_saved_dic[f'outbreak_{outbreak_location}'][index] = {}
        for t in range(0, int(arrival_times['arrival'].max()+1)):
            arrived = arrival_times[arrival_times['arrival'] <= t]
            arrived = arrived.reset_index()
            arrived['index'] = arrived['index'].astype(int)
            arrived_index = np.array(arrived['index'])
            closest_time_saved = time_saved[arrived_index, index].min()
            time_saved_dic[f'outbreak_{outbreak_location}'][index][t] = closest_time_saved
    
            #closest_i = np.where(time_saved[arrived_index, index] == closest_time_saved)
            #min_time_saved = time_saved[closest_i, index].min()
            #print(dic)
            #arr = np.array([x for x in dic.values()])
            #min_time_saved = np.where(arr == arr.min())
            #closest_i = closest[min_time_saved]
            #saved = time_saved[closest_i, index]
            
        time_saved_dic[f'outbreak_{outbreak_location}'][index][t + 1] = 0
    df = pd.DataFrame()
    for key in time_saved_dic[f'outbreak_{outbreak_location}'].keys():    
        df[key] = time_saved_dic[f'outbreak_{outbreak_location}'][key].values()
    df.to_csv(f'/Volumes/harddrive/Data/v2_uniform_infection_delays/{outbreak_location}.csv')
    print('done')
    
from multiprocessing import Pool

current = glob.glob('/Volumes/harddrive/Data/v2_uniform_infection_delays/*')
current.sort()

current = pd.Series(current)
current = current.str.split('/')
current = [x[-1] for x in current]
current = [x.split('.') for x in current]
current = [x[0] for x in current]

allnums = pd.Series(np.arange(0, 2599)).astype(str)
to_do = [x for x in allnums.values if x not in current]

to_do = [f'/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/SIR/paper_outbreaks/new_all/{x}.csv' for x in allnums.values]

if __name__ == '__main__':
    with Pool(8) as p:
        print(p.map(get_time_saved, to_do))
