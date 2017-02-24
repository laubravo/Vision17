%% Lab 4 
close all;clear all;clc
Max = imread('max.jpeg');
Kyra = imread('kyra.jpeg');
%%
window = [0.5 1.5 720 651]; Max = imcrop(Max,window);

% Low-pass filter
maxLP = imfilter(Max, fspecial('gaussian',50,25));
kyraLP = imfilter(Kyra, fspecial('gaussian',350,350));
% High-pass filter
maxHP = Max - maxLP;
kyraHP = Kyra - kyraLP;

%%
%close all;
figure();imshow(Max); axis off
figure();imshow(maxLP); axis off
figure();imshow(kyraLP); axis off
figure();imshow(maxHP); axis off
%% match sizes
kyraHP = imresize(kyraHP,[NaN size(Max,2)]);
hibrido = maxLP+kyraHP; 
%hibrido2 = maxHP+kyraLP; 
% show hybrid ims
%figure();imshow(hibrido);
%% Apply pyramid to both images
h1     = impyramid(hibrido,'reduce');
h2     = impyramid(h1,'reduce');
h3     = impyramid(h2,'reduce');

figure();imshow(hibrido); axis off
figure(); imshow(h1); axis off
figure(); imshow(h2); axis off
figure(); imshow(h3); axis off