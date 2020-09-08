function [pop,Youtput,bestfit] = SA(pop,para,Xinput,damp)
%The simulated annealing algorithm in RL

T_ini = 1000;         %The initial temperature
T_min = 1;     %the Lowest temperature
iter = 0;           %Iteration count
K = 0.01;    %
fth=1.6; %Set the threshold of f, the smaller, the closer to a certain point

while T_ini > T_min
 while 1
  %Randomly generate new solutions
  popnew=pop;
  [T_before]=fitfunc(pop,para);%Calculate the objective function of the current solution
  %%%Convert the solution to a and f
  DRL_a=pop(1:para.UEn);
  DRL_f=pop(para.UEn+1:2*para.UEn);
  idx=randperm(para.UEn,1);
  sum_f=sum(Xinput(idx,3:6));
  if sum_f<fth
      [v,p]=max(Xinput(idx,3:6));
      DRL_a(idx)=p;
  else 
      DRL_a(idx)=WheelSel(Xinput(idx,3:6)'); %To be checked
  end
  popnew(1:para.UEn)=DRL_a;
  popnew(para.UEn+1:2*para.UEn)=DRL_f;
  [popA] = allocUE(popnew,para);
  [T_after]=fitfunc(popA,para);
        %Calculate fitness difference
        Dfit = T_after - T_before;

        if Dfit < 0
            break
        elseif rand < exp(-Dfit/(K * T_ini))
            break
        end
 end
    
    %Update solution
    pop = popA;    
    iter = iter + 1;
    History_fit(iter) = T_after;              %Store current fitness
    %Drop temperature
    T_ini = T_ini * damp;
end
%%%In order to facilitate the calculation, replace the relative value with the absolute value of f in pop
  DRL_a=pop(1:para.UEn);
  DRL_f=pop(para.UEn+1:2*para.UEn);
      for k=1:para.MECn+1 
         k;
         if k==1
         DRL_f(find(DRL_a==k-1))=1;
         else 
         DRL_f(find(DRL_a==k-1))= DRL_f(find(DRL_a==k-1))./para.fGS(k-1);
         end
      end
 %Then change pop to the form required by the neural network: independent onehot encoding
 Youtput1=[DRL_a' DRL_f'];
 Youtput=zeros(size(Youtput1,1),5);
for i=1:size(Youtput1,1) %Onehot encode Y
    Youtput(i,Youtput1(i,1)+1)=1;
end
 Youtput(:,6)=Youtput1(:,2); 
 bestfit=History_fit(end);
end

