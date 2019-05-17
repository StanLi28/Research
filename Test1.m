% clear all;
% close all;
% clc
%Read the image
he = imread('knee4.png');
imshow(he), title('H&E image');
%Covert the image into a two-color image
grayHE = rgb2gray(he);
ab = grayHE(:,:,1:1);
ab = im2single(ab);
nColors = 2;
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
figure, imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');

BWdfill = imfill(pixel_labels,'holes');
figure, imshow(BWdfill)

%Display the boarder of the image
gmag = imgradient(pixel_labels);
figure,imshow(gmag,[])
title('Gradient Magnitude')

%Grab the middle part of meniscus
 col = size(gmag,2)/2; 
    plot(gmag(:,col));%
 
%return;   

figure, imshow(gmag,[])

info = imfinfo('knee1.png');
w = info.Width;
h = info.Height;
