function [pop] = GreedyUE(h,para)
%Greedy algorithm to solve this problem
iter=2;
UEn=para.UEn;
hdivd=reshape(h,para.MECn,para.UEn);
%Assign the UE nearby to get the initial solution
maxh = max(hdivd);
f=zeros(1,UEn);
p=ones(1,UEn); 
cludataC=zeros(1,UEn);
for i=1:para.MECn
    cludataC(find(hdivd(i,:) == maxh))=i;
end
f(find(cludataC==0))=para.fL;
for j=1:para.MECn
    f(find(cludataC==j))=para.fGS(j)./size(find(cludataC==j),2);
end
pop=[cludataC f p];
for k=1:iter
 [popQ,T,E,Qvector]=fitfunc(pop,para);
 [Value,idx]=max(Qvector);
 for j=1:para.MECn
     pop(idx)=j;
     [popfindQ(j)]=fitfunc(pop,para);
 end
 [Value2,idx2]=min(popfindQ);
 pop(idx)=idx2;
end
end

