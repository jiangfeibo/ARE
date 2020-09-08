function [avgT,er,fmse,reward,nn] = DRLopt(Xtrain,Ytrain,para,sample)
%The code use DRL to solving a and f
%%Eliminate potentially invalid data
Ytrain(any(isnan(Xtrain), 2),:) = [];
Xtrain(any(isnan(Xtrain), 2),:) = [];
 %onehot encoded
Ytrain2=Ytrain;
Ytrain=zeros(size(Ytrain2,1),5);
for i=1:size(Ytrain2,1) %Onehot encode Y
    Ytrain(i,Ytrain2(i,1)+1)=1;
end
Ytrain(:,6)=Ytrain2(:,2);   
%Set agent parameters
loss=[];
rand('state',0)
nn = nnsetup([size(Xtrain,2) 64 32 size(Ytrain,2)]);
opts.numepochs =10;   % Number of data set training
opts.plot= 0;
nn.learningRate = 1.5; 
nn.activation_function = 'sigm';    %  Sigmoid activation function sigm
%%%Set up dynamic sample library
mempercent=0.4;
memsize=(para.sampNo*mempercent)*para.UEn;
batchsize=memsize/10;
memin=[];
memout=[];
damp=linspace(0.85,0.965,size(Xtrain,1)/para.UEn);%Gradually improve SA search accuracy
for i=1:size(Xtrain,1)/para.UEn
    Xinput=Xtrain((i-1)*para.UEn+1:i*para.UEn,:);
    [labels,fpred1] = nnpredict(nn, Xinput);
    apred=labels'-1;
    fpred=fpred1';
    para.h=sample.Dreplaybufferin(i,:); 
    AIresult=AIUE(apred,fpred,para); %Generate af according to the output of DNN, where f needs to be converted from a relative value to an absolute value
    [T_DRL(i)]=fitfunc(AIresult,para);    
    %%%%%Use SA to generate Youtput according to labels, fpred1£»
    if para.SA==1
        [pop,Youtput,bestfit(i,:)]=SA(AIresult,para,Xinput,damp(i));
    else
        [pop,Youtput,epsfit(i,:)] = epsgreedy(AIresult,para,Xinput);
    end
   %update buffer    
  if size(memin,1)<memsize %At first, the data in the database is less than the number of samples
      memin=[memin;Xinput];
      memout=[memout;Youtput];
  else %FIFO when the database is full
    memin(1:memsize-para.UEn,:)=memin(para.UEn+1:memsize,:);
    memin(memsize-para.UEn+1:end,:)=Xinput;
    memout(1:memsize-para.UEn,:)=memout(para.UEn+1:memsize,:);
    memout(memsize-para.UEn+1:end,:)=Youtput;
  end
  %Random sampling training
      range=size(memin,1);%Calculate the sampling range based on the current buffersize
      if batchsize>= range  %At first£¬the size of the sample is greater than the size of the database, and all data is used for training
        batchin= memin;
        batchinout=memout;
        opts.batchsize = range;
      else
        batchindx=randperm(range,batchsize); %Random sampling
        batchin= memin(batchindx,:);
        batchinout=memout(batchindx,:);
        opts.batchsize = batchsize;
      end
     [nn, L] = nntrain(nn, batchin, batchinout, opts);
     loss=[loss; L];

end
reward=1./T_DRL;
%Test the performance of DRL
trainpercent=0.8; %Set the proportion of training samples
trainno=(para.sampNo*trainpercent)*para.UEn;%The number of training scenarios is used here, when the number of UEs changes, the number of samples will also change
batchinV=Xtrain(trainno+1:end,:);
batchoutV=Ytrain(trainno+1:end,:);
[er,bad,fmse] = nntest(nn, batchinV, batchoutV);%Output error rate and MSE of test data

%%%Output the result of the test data, used to count the objective function (time delay)
[labels,fpred1] = nnpredict(nn, batchinV);
%%%Calculate the test delay%%%
Snumb=size(batchinV,1)/para.UEn;
apred=reshape(labels,para.UEn, Snumb)';
fpred=reshape(fpred1, para.UEn, Snumb)';
aexpt=reshape(Ytrain2(trainno+1:end,1),para.UEn, Snumb)';
fexpt=reshape(Ytrain2(trainno+1:end,2),para.UEn, Snumb)';
for i=1:Snumb
  para.h=sample.Dreplaybufferin(para.sampNo*trainpercent+i,:); %Find the corresponding h
  DNNa=apred(i,:)-1;
  DNNf=fpred(i,:);
  AIresult=AIUE(DNNa,DNNf,para); 
  [Ttep,QoS,Eng,Qvector]=fitfunc(AIresult,para);
  %%%%%%%Correct the output solution of the neural network%%%%%%%%%%
  AIresult2 = corresult(AIresult,Qvector,para);
  T(i,1)=fitfunc(AIresult2,para);
  %%%%%%%%Output solutions of other algorithms%%%%%%%%%%%%%%%%%%%%%%
  Gredresult=GreedyUE(para.h,para);
  T(i,2)=fitfunc(Gredresult,para);
  Randresult = RandomUE(para.h,para);
  T(i,3)=fitfunc(Randresult,para);
end
 avgT=mean(T);
end


