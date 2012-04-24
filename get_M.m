function M = get_M(p, U, Jk)
    
    d = diag(p + eps,0) ;

    M = (1/2) * sqrt(inv(d)) * U' * Jk;
    
end