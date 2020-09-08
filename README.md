# MECDLRL

*AI Driven Heterogeneous MEC System with UAV Assistance for Dynamic Environment - Challenges and Solutions*

Matlab code to reproduce our works.
- [AIUE.m](AIUE.m): Convert independent output AI solutions into time slice AI solutions

- [allocUE.m](allocUE.m): Convert the generated solution into a normative solution (satisfy constraints)

- [CalR.m](CalR.m): Calculate the distance between UE and MEC

- [CalT.m](CalT.m): Calculate the delay time

- [cluUE.m](cluUE.m): Classify current users according to the distance from MEC

- [corresult.m](corresult.m): Correct the output solution of the neural network

- [DNNopt2.m](DNNopt2.m): Code for DNN in a dynamic environment to solve a and f

- [drawfigs.m](drawfigs.m): Optimization and plot

- [DRLopt.m](DRLopt.m): The code use DRL to solving a and f

- [epsgreedy.m](epsgreedy.m): Random Algorithm in RL 

- [fitfunc.m](fitfunc.m): Calculation time delay as the fitness function

- [GreedyUE.m](GreedyUE.m): Greedy algorithm to solve this problem

- [LocalUE.m](LocalUE.m): Execute the tasks locally

- [RandomUE.m](RandomUE.m): Random algorithm to solve this problem

- [SA.m](SA.m): The simulated annealing algorithm in RL

- [WheelSel.m](WheelSel.m): Use roulette algorithm to generate random individuals

- [main.m](main.m): run this file, including setting system parameters

## About our works

1. Jiang F, Wang K, Dong L, et al. AI Driven Heterogeneous MEC System with UAV Assistance for Dynamic Environment - Challenges and Solutions[J]. arXiv preprint arXiv:2002.05020, 2020.

## About authors

- Feibo Jiang  (jiangfb@hunnu.edu.cn) is with Hunan Provincial Key Laboratory of Intelligent Computing and Language Information Processing, Hunan Normal University, Changsha, China, 
- Kezhi Wang (kezhi.wang@northumbria.ac.uk) is with the department of Computer and Information Sciences, Northumbria University, UK, 
- Li Dong (Dlj2017@hunnu.edu.cn) is with Key Laboratory of Hunan Province for New Retail Virtual Reality Technology, Hunan University of Commerce, Changsha, China, 
- Cunhua Pan (Email: c.pan@qmul.ac.uk) is with School of Electronic Engineering and Computer Science, Queen Mary University of London, London, E1 4NS, UK, 
- Wei Xu (wxu@seu.edu.cn) is with NCRL, Southeast University, Nanjing, China,	
- Kun Yang (kunyang@essex.ac.uk) is with the School of Computer Sciences and Electrical Engineering, University of Essex, CO4 3SQ, Colchester, UK and also with University of Electronic Science and Technology of China, Chengdu, China

## Required

- Matlab 2020a

- DeepLearnToolbox


## How the code works

- run the file, [main.m](main.m)
