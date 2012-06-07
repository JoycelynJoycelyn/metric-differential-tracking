function dc = get_dc(T)
    
    U = get_U(T.target.subIm, 216);
    %
    J = T.target.J;
    T.target.M = zeros(216 ,2);
    
    if(size(U,1) ~= size(J,1))
        J = get_J(T.target.subIm);
    end
    
    T.target.M = get_M(T.target.p, U, J); 
    
    S = (T.target.M'*(T.target.A'*T.target.A)*T.target.M) \ ( T.target.M'*(T.target.A'*T.target.A));
    
    dc = S * (sqrt(T.target.q) - sqrt(T.target.p));

end