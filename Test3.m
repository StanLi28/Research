rgb = imread('knee2.png');
I = rgb2gray(rgb);
ab = I(:,:,1:1);
ab = im2single(ab);
nColors = 2;
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
figure, imshow(pixel_labels, [])

gmag = imgradient(pixel_labels);
% figure, imshow(gmag,[])
title('Gradient Magnitude')

L = watershed(gmag);
Lrgb = label2rgb(L);
% figure, imshow(Lrgb);
title('Watershed Transform of Gradient Magnitude')

se = strel('disk',20);
Io = imopen(pixel_labels,se);
% figure, imshow(Io);
title('Opening')

Ie = imerode(pixel_labels,se);
Iobr = imreconstruct(Ie,pixel_labels);
% figure, imshow(Iobr);
title('Opening-by-Reconstruction')

Ioc = imclose(Io,se);
% figure, imshow(Ioc)
title('Opening-Closing')

Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
figure, imshow(Iobrcbr)
title('Opening-Closing by Reconstruction')

fgm = imregionalmax(Iobrcbr);
figure, imshow(fgm)
title('Regional Maxima of Opening-Closing by Reconstruction')

I2 = labeloverlay(pixel_labels,fgm);
imshow(I2)
title('Regional Maxima Superimposed on Original Image')

se2 = strel(ones(5,5));
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);

fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(pixel_labels,fgm4);
imshow(I3)
title('Modified Regional Maxima Superimposed on Original Image')

bw = imbinarize(Iobrcbr);
imshow(bw)
title('Thresholded Opening-Closing by Reconstruction')

D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
imshow(bgm)
title('Watershed Ridge Lines)')

gmag2 = imimposemin(gmag, bgm | fgm4);

L = watershed(gmag2);

labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(pixel_labels,labels);
imshow(I4)
title('Markers and Object Boundaries Superimposed on Original Image')

Lrgb = label2rgb(L,'jet','w','shuffle');
imshow(Lrgb)
title('Colored Watershed Label Matrix')

figure
imshow(pixel_labels)
hold on
himage = imshow(Lrgb);
himage.AlphaData = 0.3;
title('Colored Labels Superimposed Transparently on Original Image')