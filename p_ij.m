function  p  = p_ij(A,X,i,j )
q=exp(-  (norm(A*X(:,i)-A*X(:,j))^2)  );
sum=0;
for z=1:size(X,2)
    if(~(z==i))
        sum = sum + exp(-norm(A*X(:,i)-A*X(:,z)));
    end
end
p=q/sum;    
return
end
