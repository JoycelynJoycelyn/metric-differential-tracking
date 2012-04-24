function k = gaussian_kernel(i, j, s)

%va fatto in entrambe le direzioni
%i e j sono già centrati

%ro = 50;

d = exp(- (i^2 + j^2) / (2*(s^2)) );

n = 1/sqrt(2*pi*s^2);

k = n * d;

end