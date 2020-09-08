function [popA] = allocUE(pop,para)
%Convert the generated solution into a normative solution (satisfy constraints)
fGS=para.fGS;
fL=para.fL;
UEn=para.UEn;
MECn=para.MECn;
cludata=pop(1:UEn);
f=pop(UEn+1:2*UEn);
p=pop(2*para.UEn+1:3*para.UEn);
cludata=round(cludata);  %Rounding the UE's resource allocation
%Assign value to locally executed f
f(find(cludata==0))=fL;
p(find(cludata==0))=para.PL;
%Constraint check on f
for j=1:MECn
    fsum=sum(f(find(cludata==j)));
%     if fsum>fGS(j)
       f(find(cludata==j))=f(find(cludata==j)).*(fGS(j)/fsum);
%     end
end
popA=[cludata f p];


