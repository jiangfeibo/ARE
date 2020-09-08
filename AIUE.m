function [particle] = AIUE(DNNa,DNNf,para)
%Convert independent output AI solutions into time slice AI solutions
  particle(1:para.UEn)=DNNa;
  fpercent=DNNf;
  for k=1:para.UEn
      if particle(k)==0
          f(k)=para.fL;
      else
          f(k)=fpercent(k)*para.fGS(particle(k));
      end
  end
  particle(para.UEn+1:2*para.UEn)=f;
  particle(2*para.UEn+1:3*para.UEn)=para.p;
  particle=allocUE(particle,para);
end

