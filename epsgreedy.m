function [pop,Youtput,History_fit] = epsgreedy(pop,para,Xinput)
%Random Algorithm in RL 
epsilon=0.8;
iternum=100;%Randomly update the solution several times
History_fit=zeros(1,iternum);
if rand<epsilon %Random update pop
 for iter=1:iternum
  popnew=pop;
  [T_before]=fitfunc(pop,para);%Calculate the objective function of the current solution
  History_fit(iter)=T_before;
  %%%Convert the solution to a and f
  DRL_a=pop(1:para.UEn);
  DRL_f=pop(para.UEn+1:2*para.UEn);
  idx=randperm(para.UEn,1);
  if rand<0.4
   DRL_a(idx)=randperm(para.MECn+1,1)-1;
  else
   DRL_a(idx)=WheelSel(Xinput(idx,3:6)'); 
  end
  popnew(1:para.UEn)=DRL_a;
  popnew(para.UEn+1:2*para.UEn)=DRL_f;
  [popA] = allocUE(popnew,para);
  [T_after]=fitfunc(popA,para);
  Dfit = T_after - T_before;
    if  Dfit<0 %The new solution is better than the old one
        pop=popA;
    end
 end
end
%%%In order to facilitate calculation, change the absolute value of f in pop to a relative value
  DRL_a=pop(1:para.UEn);
  DRL_f=pop(para.UEn+1:2*para.UEn);
      for k=1:para.MECn+1 %5 is the number of decisions for a
         k;
         if k==1
         DRL_f(find(DRL_a==k-1))=1;
         else 
         DRL_f(find(DRL_a==k-1))= DRL_f(find(DRL_a==k-1))./para.fGS(k-1);
         end
      end
 %Change pop to the form required by the neural network: independent onehot encoding
 Youtput1=[DRL_a' DRL_f'];
 Youtput=zeros(size(Youtput1,1),5);
for i=1:size(Youtput1,1) %Onehot encode Y
    Youtput(i,Youtput1(i,1)+1)=1;
end
    Youtput(:,6)=Youtput1(:,2); 
end

