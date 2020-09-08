function [R] = CalR(UE,center)
%Calculate the distance between UE and MEC
for i=1:size(center,1)
R(:,i)=((UE(:,1)- center(i,1)).^2+(UE(:,2)- center(i,2)).^2).^0.5;
end

