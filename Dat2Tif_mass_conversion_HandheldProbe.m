%This program converts 12 bit dat images into 16 bit tif images
%Instructions: 1. Change current folder to the folder containing all the images
%Instructions: 2. Click Run
%Written by Yihua Zhu

  d=dir('*.dat');
  for i=1:length(d)
      %Reads in .dat file
      fname = d(i).name;
      raw_img=load(fname);
      img = raw_img * 2^(8);
      img16 = uint16(img);
      img_flip = flip(img16,2);
      img_gray = rgb2gray(img_flip);
      %Converts to TIF and gives it the .tif extension
      fname = [fname(1:end-4),'.tif'];
      imwrite(img_gray,fname,'tif');
      %Reloads it in a TIF format
       A = imread(fname);
      newImage = repmat(A,[1 1 3]);
      %Rewrites in into working Directory
      imwrite(newImage,fname,'tif');
  end