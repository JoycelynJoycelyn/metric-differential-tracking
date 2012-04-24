function J = get_J(subIm, BB)
%subIm è un candidato, e la relativa BB

%     i_c = round(BB(3)/2 + BB(1));
%     j_c = round(BB(4)/2 + BB(2));
%     
    np = size(subIm,1) * size(subIm,2);
    
    J = zeros(np, 2);
    s=min(size(subIm,1) , size(subIm,2));
    
    % i o x
    for i = 1 : size(subIm,2)
       % j o y
       for j = 1 : size(subIm,1)
           
           J(j + (i-1)*size(subIm,1),1) = -gaussian_kernel_gradient_i(i - size(subIm,2)/2 , j - size(subIm,2)/2 , s) ;
           J(j + (i-1)*size(subIm,1),2) = -gaussian_kernel_gradient_j(i - size(subIm,1)/2 , j - size(subIm,1)/2 , s) ;
           
           %J(i + (j-1)*size(subIm,1),1) = (3/2)*(i_n_H);
           %J(i + (j-1)*size(subIm,1),2) = (3/2)*(j_n_H);
          
           
       end
    end

end