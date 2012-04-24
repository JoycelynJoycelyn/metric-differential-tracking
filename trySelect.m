clear all; close all;
%figure; 
I = imread('prova_1.jpg');

I = im2double(I);
%I = imread('elio_e_le_storie_tese_cicciput.jpg');
rect = [0 0 0 0]; 
[I2 rect] = imcrop(I);


%get_histogram(rect, I);
% 225 bins
i_c = round(rect(3)/2 + rect(1));
j_c = round(rect(4)/2 + rect(2));
q = get_histogram_feature(I2, rect, 225, i_c, j_c, 0, 0)


