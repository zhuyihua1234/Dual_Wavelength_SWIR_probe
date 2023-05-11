% This code converts 10 bit Triwave image to 16 bit tif image
% This code corrects the Triwave camera transillumination artifact
% The mask is a brightfield correction image taken by Triwave
% This code draws a ROI and finds the mean intensity and standard deviation

% load the original image taken by Triwave
triwave_pic = imread('B4_psi25_300mA');

% Load the mask
load ('/Users/danielfried/Desktop/Yihua/Dual_probe/transillumination_mask.mat');
%Choose what bit depth you want for the new images
%Subtract image by background
%Choose what bit depth you want for the new images
%Subtract image by background

bitdepth = 16;
img = uint16((triwave_pic) * (2^(bitdepth))/(2^(10)));

%Normalization
grayimg = mat2gray(img);

% Internal Artifact Correction
newgray = 1 - grayimg;
imageCopy = newgray;
imageCopy(~mask) = 0;

%Apply Internal Artifact Correction and choose how much you want to correct
img_correct = grayimg + 0.07*imageCopy;
imshow(img_correct);
imwrite(img_correct,'/Users/danielfried/Desktop/Yihua/Dual_probe/10_29_19/corrected_tif/O12_T.tif')
