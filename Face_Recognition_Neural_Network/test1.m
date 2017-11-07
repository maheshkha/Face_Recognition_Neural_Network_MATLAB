clc;
clear all;
close all;

%image read
I = imread('ref_test01.jpg');
figure;imshow(I);title('Original Image');

%rgb2 gray conversion
rgb_I=rgb2gray(I);%image toolbox dependent
figure;imshow(rgb_I);title('RGB Image');

% histrogram calculations
reg_I_hist=imhist(rgb_I);
figure;plot(reg_I_hist);

% histrogram calculations
eq_I_hist= histeq(rgb_I);
figure;imshow(eq_I_hist);

% Noise addition
J = imnoise(rgb_I,'salt & pepper',0.02);
figure;subplot(221),imshow(J);

% median filtering calculations
L = medfilt2(J,[5 5]);
subplot(222),imshow(L);

% median filtering calculations
L1 = medfilt2(J,[3 3]);
%subplot(222),imshow(L);

% error 5x5 calculations
err = L - rgb_I;
subplot(223),imshow(err);

% error 3x3 calculations
err1 = L1 - rgb_I;
subplot(224),imshow(err1);
