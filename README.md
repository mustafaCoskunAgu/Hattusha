# Hattusha
Multiplex Embedding of Biological Networks Using Topological Similarity of Different Layers
# This code tested on python 3.6 and Matlab R2020b for Drug Repositioning

#Steps to run

1-) Unzip all zipped files

2-) Run ConstrucGWD.py to construct Kernel

3-) Run Prune.m to prune layers that add noise

4-) Run Main.m to precompute

5-) Run SVD for embedding

6-) To test FVAE Run cvae.py by following steps:

    1) Change line     parser.add_argument('--dir', help='dataset directory', default='C:/Users/Secil/Desktop/Hattusha/data') 
    with your path
    
    2)     parser.add_argument('--rating', help='feed input as rating', action='store_true') 
    
    3)     parser.add_argument('--save', help='save model', action='store_true') 
    
    4)     parser.add_argument('--load', help='load model, 1 for fvae and 2 for cvae', type=int, default=0)
    
6-) Run cvae.py by following steps:

        
    1)     parser.add_argument('--rating', help='feed input as rating', action='store_false') 
    
    3)     parser.add_argument('--save', help='save model', action='store_true') 
    
    4)     parser.add_argument('--load', help='load model, 1 for fvae and 2 for cvae', type=int, default=1)
    
 # To test CVAE
 
 
 6-) Run cvae.py by following steps:

        
    1)     parser.add_argument('--rating', help='feed input as rating', action='store_false') 
    
    3)     parser.add_argument('--save', help='save model', action='store_false') 
    
    4)     parser.add_argument('--load', help='load model, 1 for fvae and 2 for cvae', type=int, default=2)
 
 
 7-) To see Hattusha Running time Performance run RunTimeCompare.m
 
 
 If you find this code useful please cite
 Multiplex Embedding of Biological Networks Using Topological Similarity of Different Layers
 paper by
 
 @article {Co{\c s}kun2021.11.05.467392,
	author = {Co{\c s}kun, Mustafa and Koyut{\"u}rk, Mehmet},
	title = {Multiplex Embedding of Biological Networks Using Topological Similarity of Different Layers},
	elocation-id = {2021.11.05.467392},
	year = {2021},
	doi = {10.1101/2021.11.05.467392},
	publisher = {Cold Spring Harbor Laboratory},
	URL = {https://www.biorxiv.org/content/early/2021/11/05/2021.11.05.467392},
	eprint = {https://www.biorxiv.org/content/early/2021/11/05/2021.11.05.467392.full.pdf},
	journal = {bioRxiv}
}

If you have any question, please email me via mustafa.coskun@case.edu

