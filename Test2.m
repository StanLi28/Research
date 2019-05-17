%Read an image into the workspace.
I = imread('knee1.png');
imshow(I)
se = strel('disk',15)
background = imopen(I,se);
imshow(background)
I2 = I - background;
imshow(I2)
I3 = imadjust(I2);
imshow(I3)
bw = imbinarize(I3);
bw = bwareaopen(bw,50);
imshow(bw)
cc = bwconncomp(bw,4)
cc.NumObjects
grain = false(size(bw));
grain(cc.PixelIdxList{50}) = true;
imshow(grain)
labeled = labelmatrix(cc);
whos labeled
RGB_label = label2rgb(labeled,'spring','c','shuffle');
imshow(RGB_label)
graindata = regionprops(cc,'basic')
grain_areas = [graindata.Area];
grain_areas(50)
[min_area, idx] = min(grain_areas)
grain = false(size(bw));
grain(cc.PixelIdxList{idx}) = true;
imshow(grain)