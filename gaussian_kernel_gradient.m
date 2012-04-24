function jk = gaussian_kernel_gradient(i, j)

ro = 5;

x_q = [i  ; j ];

%d = exp(- (i^2 + j^2) / (2*(ro^2)) );
d = exp(- (norm(x_q,1)^2) / (2*(ro^2)) );

n = -(1/sqrt(2*pi*ro^2))*2*(norm(x_q,1));

jk = n * d;
%asddsa

end