function K = get_K(subIm)%, BB, i_c, j_c)

np = size(subIm,1) * size(subIm,2);

K = zeros(np, 1);
C=0;
s = min(size(subIm,1) , size(subIm,2)) / 2;

% ji = 1 : np;
% i = 1 : size(subIm,2);
% j = 1 : size(subIm,1);

% K(ji) = gaussian_kernel(i - size(subIm,2)/2 , j - size(subIm,1)/2 , s);
% C = K(j + (i-1)*size(subIm,1),1);    

for i = 1 : size(subIm,2)
       % j o y
       for j = 1 : size(subIm,1)
           %gaussiano
           K(j + (i-1)*size(subIm,1) , 1) = gaussian_kernel(i - size(subIm,2)/2 , j - size(subIm,1)/2 , s);
           
           %Epanechnikov
           %x = [(i - size(subIm,1)/2) (j - size(subIm,2)/2)];
           %K(i + (j-1)*size(subIm,1) , 1)  = (3/4)*(1 - norm(x,2)^2);
           
           C = C + K(j + (i-1)*size(subIm,1),1);    
       end
end

K = (1/C) * K ; 
    
end