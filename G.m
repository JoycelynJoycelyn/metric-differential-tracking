function V = G( A, pos_sample, neg_sample )
    V = 0;
    sum_p =0;
    sample = [pos_sample neg_sample];
    

    
    
    
    for i=1:size(pos_sample,2)
        sum=0;
        for z=1:size(sample,2)
            sum = sum + exp(-(norm(A*sample(:,i)-A*sample(:,z)))^2);
        end
        for j=1:size(pos_sample,2)
            sum_p = sum_p + p_ij(A,sample,i,j,sum);
        end
    end
    
    V = V + log(sum_p);
    sum_p = 0;
    
    for i=1:size(neg_sample,2)
        sum=0;
        for z=1:size(sample,2)
            sum = sum + exp(-(norm(A*sample(:,size(pos_sample,2)+i)-A*sample(:,z)))^2);
        end
        for j=1:size(neg_sample,2)
            sum_p = sum_p + p_ij(A,sample,size(pos_sample,2)+i,size(pos_sample,2)+j,sum);
        end
    end
    
    V =  (V + log(sum_p));

end

