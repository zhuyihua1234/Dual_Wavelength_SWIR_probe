%Creates structure of dat images inside working directory
  d=dir('*.tif');
  for i=1:length(d)
      %Reads in .tiff file
      fname = d(i).name;
      raw_img=imread(fname);
      img_8 = uint8(raw_img/256);
      img = rgb2gray(img_8);
      rgb = ind2rgb(img,hsv(256));
      I = rgb;
      %Converts to TIF and gives it the .tif extension
      fname = [fname(1:end-4),'.tiff'];
      imwrite(I,fname,'tiff');

  end