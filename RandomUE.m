function [Randompop] = RandomUE(h,para)
%Random algorithm to solve this problem
iter=1;
UEn=para.UEn;
f=zeros(1,UEn);
p=ones(1,UEn);
cludataC=zeros(1,UEn);
Randompop=cludataC;
popQbest=100;
for k=1:iter
    for i=1:para.UEn
        cludataC(i)=randperm(para.MECn+1,1)-1;
    end
    f(find(cludataC==0))=para.fL;
    for j=1:para.MECn
        f(find(cludataC==j))=para.fGS(j)./size(find(cludataC==j),2);
    end
    pop=[cludataC f p];
    para.h=h;
    popQ=fitfunc(pop,para);
    if popQ<popQbest %Choose a better random solution
        popQbest=popQ;
        Randompop=pop;
    end
end
end

