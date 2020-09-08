clear
clc
close all
addpath(genpath('DeepLearnToolbox'));
para.gridnl=50;para.gridn2=50;%The simulation range
para.MECn=4; %MEC number
para.sampNo=500;%Scenarios number
para.UEn=50;  %UE number
para.Dcom=10^6.*(0.95+0.1*rand(1,para.UEn));    %transfer data of MEC Task 
para.Fcom=10^9.*(0.95+0.1*rand(1,para.UEn));   %computing resources of MEC Task 
para.B=10^6;              %bandwidth
para.p=1;                 %Transmission power
para.PL=1;                %Local execution power
para.delta=10^(-12);       %Standard Deviation in Shannon formula when calculating r
para.K=10^-27;             %Energy consumption factor for local execution K*(fL^V)
para.V=3;                  %Locally executed energy consumption index
para.fL=1e9;               %Maximum omputing resource for UE
para.fGS=[15e9 15e9 30e9 50e9];           % Maximum computing resource for MEC
para.vel=3;    %UE's motion coefficient
para.GSpos=[15,15];  %GS coordinates
para.GVline=[3,2,-180];   %ax+by+c=0, a,b,c are the straight line of the highway for GV
para.th=0.54; 
para.Tlocal=1; 

load data1.mat %Load environmental data
%Optimization and plot
 [avgT1,avgT2]=drawfigs(Xtrain,Ytrain,para,sample);

