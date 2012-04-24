function jk_j = gaussian_kernel_gradient_j(i, j, s)

%va fatto in entrambe le direzioni
%i e j sono già centrati e spostati della giusta quantità delta

%ro = 20;

d = exp(- (i^2 + j^2) / (2*(s^2)) );

n = (1/sqrt(2*pi*s^2)) * (j / s^2 );

jk_j = n * d;

end