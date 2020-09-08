function [AIresult2] = corresult(AIresult,Qvector,para)
%Correct the output solution of the neural network
  DNNa2 =AIresult(1:para.UEn);
  DNNf2=AIresult(para.UEn+1:2*para.UEn);
  DNNa2(find(Qvector>para.Tlocal))=0;
  DNNf2(find(Qvector>para.Tlocal))=para.fL;
  AIresult2(1:para.UEn)=DNNa2;
  AIresult2(para.UEn+1:2*para.UEn)= DNNf2;
  AIresult2(2*para.UEn+1:3*para.UEn)=para.p;
  AIresult2=allocUE(AIresult2,para);
end

