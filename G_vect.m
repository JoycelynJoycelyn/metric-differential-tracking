function g = G_vect(  A, pos_sample, neg_sample)
    sample = [pos_sample neg_sample];
    X = - (  pdist((A*sample)') .^2);
    den_i = sum(X,2)-diag(x); 
    X = X ./repmat(den_i,1,size(X,2));
    pos_pij = X(1:size(pos_sample,2),1:size(pos_sample,2));
    neg_pij = X(size(pos_sample,2)+1:size(X,1),size(pos_sample,2)+1:size(X,1));
    g = sum(log(sum(pos_pij,2)-diag(pos_pij))) + sum(log(sum(neg_pij,2)-diag(neg_pij)));
end

