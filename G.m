function V = G( A, pos_sample, neg_sample )
    
    V = 0;
    sum_p =0;
    
    for i=1:size(pos_sample,2)
        for j=1:size(pos_sample,2)
            sum_p = sum_p + p_ij(A,pos_sample,i,j);
        end
    end
    V = V + log(sum_p);
    sum_p = 0;
    
    for i=1:size(neg_sample,2)
        for j=1:size(neg_sample,2)
            sum_p = sum_p + p_ij(A,neg_sample,i,j);
        end
    end
    
    V =  (V + log(sum_p));

end

