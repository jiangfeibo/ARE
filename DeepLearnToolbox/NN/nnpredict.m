function [labels,fpred,entropy] = nnpredict(nn, x)
    nn.testing = 1;
    nn = nnff(nn, x, zeros(size(x,1), nn.size(end)));
    nn.testing = 0;    
%     [dummy, i] = max(nn.a{end},[],2);
    [dummy, i] = max(nn.a{end}(:,1:5),[],2);
    [entropy] = compentropy(nn.a{end}(:,1:5));
    labels = i;
    fpred=nn.a{end}(:,6);
end
