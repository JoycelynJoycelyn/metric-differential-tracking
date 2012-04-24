function jk_i = gaussian_kernel_gradient_i(i, j, s)

%va fatto in entrambe le direzioni
%i e j sono già centrati e spostati della giusta quantità delta

%ro = 20;

d = exp(- (i^2 + j^2) / (2*(s^2)) );

n = (1/sqrt(2*pi*s^2)) * (i / s^2 );

jk_i = n * d;

end