
%Creates structure of dat images inside working directory
  d=dir('*.tif');
  for i=1:length(d)
      %Reads in .dat file
      fname = d(i).name;
      raw_img=load(fname);
      img = raw_img * 4;
      img16 = uint16(img);
      %Converts to TIF and gives it the .tif extension
      fname = [fname(1:end-4),'.tif'];
      imwrite(img16,fname,'tif');
      %Reloads it in a TIF format
       A = imread(fname);
      newImage = repmat(A,[1 1 3]);
      %Rewrites in into working Directory
      imwrite(newImage,fname,'tif');
  end