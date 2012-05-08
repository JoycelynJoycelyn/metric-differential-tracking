function  p  = p_ij(A,X,i,j,sum)
q=exp(-  (norm(A*X(:,i)-A*X(:,j))^2)  );

p=q/(sum-1);    
return
end
