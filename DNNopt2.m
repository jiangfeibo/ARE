 function [avgT,er,fmse,DNNloss,nn] = DNNopt2(Xtrain,Ytrain,para,sample)
%Code for DNN in a dynamic environment to solve a and f
%%Eliminate invalid data
Ytrain(any(isnan(Xtrain), 2),:) = [];
Xtrain(any(isnan(Xtrain), 2),:) = [];
%%%%Onehot encoding Ytrain
Ytrain2=Ytrain;
Ytrain=zeros(size(Ytrain2,1),5);
for i=1:size(Ytrain2,1) 
    Ytrain(i,Ytrain2(i,1)+1)=1;
end
Ytrain(:,6)=Ytrain2(:,2);
%%%Set neural network parameters%%%
loss=[];
rand('state',0)
nn = nnsetup([size(Xtrain,2) 64 32 size(Ytrain,2)]);
% nn = nnsetup([6 32 6]); %add dropout 0.3
if para.incre==0
opts.numepochs =500;   % Data set training times
else
opts.numepochs =200;
end
opts.plot= 0;
nn.learningRate = 1.5; 
nn.activation_function = 'sigm';    %  Sigmoid activation function sigm
% nn.output               = 'softmax';                   %  Use cross entropy output
trainpercent=0.88; %Set the proportion of training samples
trainno=(para.sampNo*trainpercent)*para.UEn;
trainpercentstag1=0.4;%The number of pre-training samples, also the size of the dynamic database behind
trainnostag1=(para.sampNo*trainpercentstag1)*para.UEn;
batchinT=Xtrain(1:trainnostag1,:);%Pre-training samples for the first stage
batchoutT=Ytrain(1:trainnostag1,:);
batchinT2=Xtrain(trainnostag1+1:trainno,:);%The second stage dynamic training samples
batchoutT2=Ytrain(trainnostag1+1:trainno,:);
batchinV=Xtrain(trainno+1:end,:);%Test sample
batchoutV=Ytrain(trainno+1:end,:);
%%%%%Pre-training stage
opts.batchsize=trainnostag1; 
[nn, L, loss] = nntrain(nn, batchinT, batchoutT, opts, batchinV, batchoutV);%Training a neural network
DNNtrainloss=loss.train.e;
DNNvalloss=loss.val.e;
[er,bad,fmse] = nntest(nn, batchinV, batchoutV);%Output error rate and MSE of test data
[er2,bad2,fmse2] = nntest(nn, batchinT, batchoutT);%%Output error rate and MSE of training data
%%%%%The second stage of dynamic training
if para.incre==1
opts.plot=0;
opts.numepochs=10; 
entropyth=0.7;%Judging the threshold of entropy
memsize=trainnostag1; %Initialize the database
memin=batchinT;
memout=batchoutT;
%Determine whether new data is added to the database
for i=1:size(batchinT2,1)/para.UEn
    i
    Xinput=batchinT2((i-1)*para.UEn+1:i*para.UEn,:);
    Youtput=batchoutT2((i-1)*para.UEn+1:i*para.UEn,:); %Direct the optimal solution as the output of the neural network
    [labels,fpred1,entropy] = nnpredict(nn, Xinput);
    if mean(entropy)>entropyth  %Entropy detection
      memin(1:memsize-para.UEn,:)=memin(para.UEn+1:memsize,:);
      memin(memsize-para.UEn+1:end,:)=Xinput;
      memout(1:memsize-para.UEn,:)=memout(para.UEn+1:memsize,:);
      memout(memsize-para.UEn+1:end,:)=Youtput;
      [nn, LD, lossD] = nntrain(nn, memin, memout, opts, batchinV, batchoutV);%Training neural network
      DNNtrainloss=[DNNtrainloss, lossD.train.e(end-1:end);];
      DNNvalloss=[DNNvalloss,lossD.val.e(end-1:end);];
    end
end
end

%%%Output the output result of the test data, used to count the objective function (time delay)
[labels,fpred1,entropy] = nnpredict(nn, batchinV);
%%%Calculate the test delay%%%
Snumb=size(batchinV,1)/para.UEn;%Calculate the number of scenarios based on the number of test data (1 scenario = UEn samples)
apred=reshape(labels,para.UEn, Snumb)';
fpred=reshape(fpred1, para.UEn, Snumb)';
aexpt=reshape(Ytrain2(trainno+1:end,1),para.UEn, Snumb)';
fexpt=reshape(Ytrain2(trainno+1:end,2),para.UEn, Snumb)';
for i=1:Snumb
  para.h=sample.Dreplaybufferin(para.sampNo*trainpercent+i,:); %Find the corresponding h
  DNNa=apred(i,:)-1;
  DNNf=fpred(i,:);
  AIresult=AIUE(DNNa,DNNf,para); %Generate af according to the output of DNN, where f needs to be converted from a relative value to an absolute value
  [Ttep,QoS,Eng,Qvector]=fitfunc(AIresult,para);
  %%%%%%%Correct the output solution of the neural network%%%%%%%%%%
 AIresult2 = corresult(AIresult,Qvector,para);
 T(i,1)=fitfunc(AIresult2,para);
  %%%%%%Output of other algorithms%%%%%%%%%%%%%%%%%%%%%%%%
  Gredresult=GreedyUE(para.h,para);
  T(i,2)=fitfunc(Gredresult,para);
  Randresult = RandomUE(para.h,para);
  T(i,3)=fitfunc(Randresult,para);
end
 avgT=mean(T);
 DNNloss.DNNtrainloss=DNNtrainloss;
 DNNloss.DNNvalloss=DNNvalloss;
 end

