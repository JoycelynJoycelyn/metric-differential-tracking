%function q = get_histogram_feature(subIm, BB, m)
function q = get_histogram_feature(T, subIm, m)

q = zeros(m,1)'; 
 
U = get_U(subIm, m);
K = T.target.K;
if(size(U,1) ~= size(K,1))
    display('dimensioni diverse');
    K = get_K(subIm);
%    pause();
end
q = U' * K;
%q = q ./ norm(q,2);

%q = q + 0.0001 ;
%q = q ./ sum(q);
%sum(q)

end