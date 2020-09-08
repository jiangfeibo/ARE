function [er, bad,fmse] = nntest(nn, x, y)
%     labels = nnpredict(nn, x);
    [labels,fpred] = nnpredict(nn, x);
%     [dummy, expected] = max(y,[],2);
   [dummy, expected] = max(y(:,1:5),[],2);
    bad = find(labels ~= expected);    
    er = numel(bad) / size(x, 1);
    fmse=mse(fpred,y(:,6));
end
