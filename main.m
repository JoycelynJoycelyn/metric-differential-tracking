clear all; close all;
%figure; 
%I = imread('prova_1.jpg');
%play_video('car-1.avi');
%I = imread('tfcountd.jpg');
I = imread('cover1.jpg');
%I = imread('the_best_of_me.jpg');
%I = imread('peppers.png');
I = im2double(I);
%I = imread('elio_e_le_storie_tese_cicciput.jpg');
rect = [0 0 0 0]; 
[I2 rect] = imcrop(I);
rect

I2 = I2 / 255.0;
I2

%get_histogram(rect, I);
% 225 bins
i_c = round(rect(3)/2 + rect(1));
j_c = round(rect(4)/2 + rect(2));
i_c
j_c
%q = get_histogram_feature(I2, rect, 225, i_c, j_c)
q = zeros(225,1)'; 
 
U = get_U(I2, 225);
K = get_K(I2);%, rect, i_c, j_c); %gi� normalizzato, pixel centrati e la relativa distanza dal centro

q = U' * K
J = get_J(I2, rect);%, i_c, j_c);

Kmn = reshape(K, size(I2,1), size(I2,2));
figure(2);
imagesc(Kmn, [min(Kmn(:)) max(Kmn(:))]);
figure(3)
imagesc(J(:,1))
