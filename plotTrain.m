clear all; close all;
%figure; 
figure();
%I = imread('cover1.jpg');
I = imread('IMG_3164.JPG');
imshow(I);
I = im2double(I);
box = getrect;
T=[];
T = trainSample(I,box, 15, 30, T);
A= T.target.A;
pos_point = A*T.target.pos_feature_tot';
neg_point = A*T.target.neg_feature_tot';
figure();
plot(pos_point(1,:),pos_point(2,:),'.g',neg_point(1,:),neg_point(2,:),'.r')