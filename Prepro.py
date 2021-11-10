# -*- coding: utf-8 -*-
"""
Created on Wed Dec 18 21:35:47 2019

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
sys.path.append(os.path.realpath('../lib'))
#from data_loader import load_local_data
from custom_svc import Graph_FGW_SVC_Classifier
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt
class NotImplementedError(Exception):
    pass

def compute_adjency(name):
    adjency= defaultdict(list)
    with open(name) as f:
        sections = list(per_section(f))
        for elt in sections[0]:
            adjency[int(elt.split(',')[0])].append(int(elt.split(',')[1]))
    return adjency

mymat = sio.loadmat('DBLP_B.mat')
def label_wl_dataset(X,h):
    X2=[]
    for x in X:
        x2=Graph()
        x2.nx_graph=wl_labeling(x.nx_graph,h=2)
        X2.append(x2)
    return X2

#g = graph
mymatdata = mymat['data']
nodeList = mymatdata['nodes']
node_dic = mymatdata['nl']
labels = mymat['labels']
AdjMatrix = mymatdata['am']
data=[]
adjency=compute_adjency('DBLP_B.txt')
        
firstNodes = nodeList[0,1]
firstLabels = node_dic[0,1]

for i  in range(1000):    
    Nodes = nodeList[0,i]
    Labels = node_dic[0,i]
    firstAdj = AdjMatrix[0,i]
    g = Graph()
    g.name = i
    for j in range(len(Nodes)):
        theNode = Nodes[j,0]
        theAttribute = Labels[j,0]
        g.add_vertex(theNode)
        g.add_one_attribute(theNode, theAttribute)
        
        edges = np.nonzero(firstAdj[j])
        neighbors = Nodes[edges]
        for n in range(len(neighbors)):
            g.add_edge((theNode,neighbors[n][0]))
        
    data.append((g,labels[i][0]))
    if(i % 100 == 0):
        print("Progress: number = ", i)
    
        
X,y=zip(*data)
X = np.array(X, dtype=object)
y = np.array(y)
wl = 0

if wl!=0:
    X=label_wl_dataset(X,h=wl)
    
graph_svc=Graph_FGW_SVC_Classifier(C=1,gamma=1,alpha=0.7,method='shortest_path',features_metric='hamming_dist',wl=2)

X_train, X_test, y_train, y_test=train_test_split(X,y,test_size=0.33, random_state=42)


graph_svc.fit(X_train,y_train)

preds=graph_svc.predict(X_test)

np.sum(preds==y_test)/len(y_test)

