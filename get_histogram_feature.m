function q = get_histogram_feature(subIm, BB, m)

%i_c e j_c sono le coordinate del centro della bounding box
%i_dc e j_dc sono le distanze sugli assi dal centro (per q sono zero)

q = zeros(m,1)'; 
 
U = get_U(subIm, m);
K = get_K(subIm);%, BB, i_c, j_c); %già normalizzato, pixel centrati e la relativa distanza dal centro
%K = get_K(BB);
%immagine K
% Kmn = reshape(K, size(subIm,1), size(subIm,2));
% figure(2);
 
% imagesc(Kmn, [min(Kmn(:)) max(Kmn(:))]);
 %imshow(Kmn, [min(Kmn(:)) max(Kmn(:))]);
 %i = 1 : size(Kmn,1);
 %j = 1 : size(Kmn,2);
 %plot3(i, j, Kmn(:,:))
% 
% 
% %elemento di centro
% Kmn( round(size(Kmn, 1) /2) , round(size(Kmn, 2) /2 ))

q = U' * K;


end