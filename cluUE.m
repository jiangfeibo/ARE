function [cludataC] = cluUE(para)
%Classify current users according to the distance from MEC
h=para.h;
hdivd=reshape(h,para.MECn,para.UEn);
%Assign the UE nearby to get the initial solution
maxh = max(hdivd);
for i=1:para.MECn
    cludataC(find(hdivd(i,:) == maxh))=i;
end
end

