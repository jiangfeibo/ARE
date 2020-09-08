function [entropy] = compentropy(aoutput)
pro=aoutput./sum(aoutput,2);
pro(find(pro==0))=0.0001;
entropy=sum(-(pro.*log2(pro)),2);
end

