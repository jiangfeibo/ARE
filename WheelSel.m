function pop=WheelSel(U)
%Use roulette algorithm to generate random individuals

U=U';
for i=1:size(U,1)
     V=U(i,:);
     n=size(V,2);%
    if max(V)==0&min(V)==0
        pop(i)=ceil(rand(1,1)*n);
    else
        
        temindex=find(V~=0);
        n=length(temindex);
        V=V(temindex);
        pop(i)=zeros(1,1);
        V=cumsum(V)/sum(V);
        randP=rand(1,1);
            for j=1:n,
                if randP<V(j)
                    pop(i)=j;
                    break
                end
            end
     end
        pop(i)=temindex(pop(i));
end


