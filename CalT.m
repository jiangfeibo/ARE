function [T,f] = CalT(UEsort,hinf,para,j)
%Calculate the delay time
f=para.fGS(j)/size(UEsort,1); 
for i=1:size(UEsort,1)
    Idx=UEsort(i,1); %Find the number of the current user
    r=para.B.*log2(1+para.p*hinf(Idx,j)/para.delta);
    T_tran=para.Dcom(Idx)/r;
    T_com=para.Fcom(Idx)/f;
    QoS=T_tran+T_com;
    T(i,:)=[Idx QoS T_tran T_com];
end
end

