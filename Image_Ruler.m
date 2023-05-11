%load the image
img_raw = load('D:\Occlusal lesion depth project\Images\8_12_22\5_1450_BP1550_OPR 22');
%I = img_raw;
img_raw_16 = img_raw * 16;
I = uint16(img_raw_16);
%crop the image [x1 y1 (x2-x1) (y2-y1)]
%I = imcrop(img, [456 240 1034-456 787-240]);
% show the image
 imshow(I);
 % set up the measuring tool
 h = imdistline(gca);
 api = iptgetapi(h);
 api.setLabelVisible(false);
 % pause -- you can move the edges of the segment and then press  a key to continue
 pause();
 % get the distance
 dist = api.getDistance();
 % print the result
 fprintf('The length of the segment is: %0.2f pixels \n', dist)