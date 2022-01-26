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

mxm = np.loadtxt(data_path + 'h3/mxm_updated_real.csv', delimiter =',')
populations = np.loadtxt(data_path + 'h3/population/new_h3_pop.csv', delimiter =',')

current = glob.glob('/Users/shivyucel/Documents/SDS_2021.nosync/SDS_2020-2021/SDS_Thesis/Data/h3/SIR/paper_outbreaks/new_all/*')
current = pd.Series(current)
current = current.str.split('/')
current = [x[-1] for x in current]
current = [x.split('.') for x in current]
current = [x[0] for x in current]

allnums = pd.Series(np.arange(0, 2599)).astype(str)
to_do = [x for x in allnums.values if x not in current]


import os
from multiprocessing import Pool

def get_SIR(outbreak_loc):
    model = SIRModel(
       mxm,
       populations,
       outbreak_source=int(outbreak_loc), # random outbreak location
       dt=1,                   # simulation time interval
       dt_save=1,               # time interval when to save observables                 # number of initial infected
       mu=(1/9.2),
       R0=2.9, 
       I0=10,
       VERBOSE=True)
    result = model.run_simulation()
    df = pd.DataFrame(result['T_arrival'])
    df.to_csv(data_path + f'h3/SIR/paper_outbreaks/new_all/{outbreak_loc}.csv')

    
from multiprocessing import Pool


if __name__ == '__main__':
    with Pool(8) as p:
        print(p.map(get_SIR, to_do))