function q = get_histogram_feature(subIm, BB, m)

q = zeros(m,1)'; 
 
U = get_U(subIm, m);
K = get_K(subIm); %già normalizzato, pixel centrati e la relativa distanza dal centro
q = U' * K;

q = q + 0.001 ;
q = q ./ sum(q);
%sum(q)

end