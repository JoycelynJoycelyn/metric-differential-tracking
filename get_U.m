function U = get_U(subIm, m)
U = zeros(size(subIm,1) * size(subIm,2), m);

%crea matrice rg della subIm da tracciare
RGB = sum(subIm, 3)+eps;
r = subIm(:,:,1) ./ RGB;
g = subIm(:,:,2) ./ RGB;
%tra 0 e 14
r = round(r*14);
g = round(g*14);
%crea b
b = r + g * 15 +1;
b = reshape(b, 1, size(subIm,1) * size(subIm,2) );
size(subIm)
U = U';
j = 1 : size(subIm,1)*size(subIm,2);
U(b + (j-1)*size(U,1)) = 1;
U = U';
%i = 1 : size(subIm,2);
%

%U(j + (i-1)*size(subIm,1), b( j , i )) = 1;
    % i o x
    % for i = 1 : size(subIm,2)
%        % j o y
%         for j = 1 : size(U , 1)
%             %U(j + (i-1)*size(subIm,1) , b( j , i ) )=  1;
%             U(j , b( j ) )=  1;
%         end
     %end
end