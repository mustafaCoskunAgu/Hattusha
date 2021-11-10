# -*- coding: utf-8 -*-
"""
Created on Mon Nov  8 13:16:40 2021

@author: Secil
"""
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 16 15:29:58 2021

@author: Secil
"""
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  2 09:44:08 2021

@author: Secil
"""
import scipy.io as sio
from graph import Graph,wl_labeling
import networkx as nx
from utils import per_section,indices_to_one_hot
from collections import defaultdict
import numpy as np
import math
import os,sys
#sys.path.append(os.path.realpath('../lib'))
#from data_loader import load_local_data
from custom_svc import Graph_FGW_SVC_Classifier
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

import numpy as np
import os,sys
#sys.path.append(os.path.realpath('../lib'))
from graph import graph_colors,draw_rel,draw_transp,Graph,wl_labeling
from ot_distances import Fused_Gromov_Wasserstein_distance,Wasserstein_distance
import copy
from data_loader import load_local_data,histog,build_noisy_circular_graph
import matplotlib.pyplot as plt
import networkx as nx

import glob
#dir_name = 'C:/Users/Secil/Desktop/OTResearch/FGW-master/lib/TEdgeLists/'
# Get list of all files in a given directory sorted by name
#list_of_files = sorted( filter( os.path.isfile,
#                        glob.glob(dir_name + '*') ) )


def read_for_gae(filename, weighted=False):
    datapath = 'EdgeLists/'
    #print("Loading training graph for learning embedding...")
    edgelist = np.loadtxt(datapath+filename, dtype='float')
    if weighted:
        edgelist = [(int(edgelist[idx, 0]), int(edgelist[idx, 1])) for idx in range(edgelist.shape[0]) if
                    edgelist[idx, 2] > 0]
    else:
        edgelist = [(int(edgelist[idx, 0]), int(edgelist[idx, 1])) for idx in range(edgelist.shape[0])]
    G=nx.from_edgelist(edgelist)
    node_list=list(G.nodes)
    adj = nx.adjacency_matrix(G, nodelist=node_list)
    #print("Graph Loaded...")
    return G


all_files = os.listdir("EdgeLists/")


mysortedFiles = ["" for x in range(10)]

#Since pyhton does not read file by name order
for file in all_files:
    #filename = all_files[file]
    x = file.split('.')
    index = int(x[0])
    mysortedFiles[index-1] = file



graphList = []

for file in mysortedFiles:
    G = read_for_gae(file,False)
    g = Graph(G)
    graphList.append(g)

print("All graphs are loaded...")
distanceMatrix = np.zeros((10,10))
# I am lazzy to write this code efficient, the same thing calculated twice and no need to compute diagonals
for i in range(10):
    for j in range(10):
        if j<=i:
            dgw=Fused_Gromov_Wasserstein_distance(alpha=1,features_metric='dirac',method='shortest_path').graph_d(graphList[i],graphList[j])
            distanceMatrix[i][j] = dgw
        print('Inner Loop',j)                


mdic = {"distanceMatrix": distanceMatrix}
sio.savemat("Drug_GWD_Matrix.mat", mdic)