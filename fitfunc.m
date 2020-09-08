
function [Q,T,E,Qvector] = fitfunc(particle,para)
%Calculation time delay as the fitness function
factor_T=1;%Time factor
factor_E=0;%Energy consumption factor
QoS=zeros(1,para.UEn);%Time delay
Eng=zeros(1,para.UEn);%Energy consumption
cludata=particle(1:para.UEn);
f=particle(para.UEn+1:2*para.UEn);
p=particle(2*para.UEn+1:3*para.UEn);
for i=1:para.UEn
    for j=1:para.MECn
    if cludata(i)==0 %Local execution
        QoS(i)=para.Fcom(i)/para.fL;%para.K*(para.fL^(para.V));
        Eng(i)=para.Fcom(i)*para.PL/para.fL;
    elseif cludata(i)==j %Execute on MEC
        r(i)=para.B.*log2(1+para.p*para.h(para.MECn*(i-1)+j)/para.delta);
        T_tran(i)=para.Dcom(i)/r(i);
        T_com(i)=para.Fcom(i)/f(i);
        QoS(i)=T_tran(i)+T_com(i);
        Eng(i)=T_tran(i)*p(i);
    end
    end
end
T=sum(QoS);
E=sum(Eng);
Q=factor_T*T+factor_E*E; %Objective function
Qvector=factor_T.*QoS+factor_E.*Eng;
end






