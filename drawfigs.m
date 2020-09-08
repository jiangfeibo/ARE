function [avgT1,avgT2] = drawfigs(Xtrain,Ytrain,para,sample)
%%Optimization and plot

%fig 3 (a)
para.incre=1; %Increment learning
tic
[avgT1,er1,fmse,DNNloss1,DNN1] = DNNopt2(Xtrain,Ytrain,para,sample);
DNNtraintime=toc;
para.incre=0; 
[avgT,er,fmse,DNNloss2] = DNNopt2(Xtrain,Ytrain,para,sample);
figure
semilogy(1:size(DNNloss1.DNNtrainloss,2),DNNloss1.DNNtrainloss,'-','linewidth',1.5)
hold on
semilogy(1:size(DNNloss1.DNNvalloss,2),DNNloss1.DNNvalloss,'-','linewidth',1.5)
grid on
semilogy(1:size(DNNloss2.DNNtrainloss,2),DNNloss2.DNNtrainloss,'-','linewidth',1.5)
semilogy(1:size(DNNloss2.DNNvalloss,2),DNNloss2.DNNvalloss,'-','linewidth',1.5)
legend('DNN based ARE training loss','DNN based ARE testing loss','Traditional DNN training loss','Traditional DNN testing loss','Location','best')
xlabel('Iteration')
ylabel('Loss value')
xlim([0 500])

%fig3 (b)
para.SA=1; %action refinement
tic
[avgT2,er2,fmse,reward1,DRL1]=DRLopt(Xtrain,Ytrain,para,sample);
DRLtraintime=toc;
para.SA=0; %random search
[avgT,er,fmse,reward2]=DRLopt(Xtrain,Ytrain,para,sample);
figure
plot(1:size(reward1,2),reward1,'-','linewidth',1.5)
hold on
plot(1:size(reward2,2),reward2,'-','linewidth',1.5)
grid on
legend('DRL based ARE with action refinement','DRL based ARE with random exploration','Location','best')
xlabel('Iteration')
ylabel('Reward value')

%fig4
Localresut = LocalUE(para);
LocalQ=fitfunc(Localresut,para);
figure
CT=[avgT1(1) avgT2(1) avgT2(2) avgT2(3) LocalQ];
b=diag(CT);
c=bar(b,'stacked');
legend('DNN-based ARE','DRL-based ARE','Greedy','Random','Local','Location','best')
xlabel('Offloading schemes')
ylabel('Object function (s)')
set(gca, 'XTickLabels', {})
for i = 1:length(CT)
    text(i,CT(i)+1.2,strcat(num2str(CT(i),'%.4f')),'VerticalAlignment','middle','HorizontalAlignment','center');
end
grid on
axis([-0.2 6.2 25 55]);

end


