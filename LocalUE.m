function [Localresut] = LocalUE(para)
%Execute the tasks locally 
  Localresut(1:para.UEn)=0;
  Localresut(para.UEn+1:2*para.UEn)=para.fL;
  Localresut(2*para.UEn+1:3*para.UEn)=para.PL;
end

