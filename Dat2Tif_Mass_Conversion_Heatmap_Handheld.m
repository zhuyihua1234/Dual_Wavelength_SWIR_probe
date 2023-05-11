t_img_raw = load('C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\7_10_20\bsl5_1_t_BP1300_OPR 20.dat');
r_img_raw = load('C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\7_10_20\bsl5_1_r_BP1300_OPR 20.dat');

t_img_raw_8 = t_img_raw / 16;
r_img_raw_8 = r_img_raw / 16;

t_img = uint8(t_img_raw_8);
r_img = uint8(r_img_raw_8);

img_t = 0.4*(256 - t_img);
img_r = 0.6*(r_img);
img_addition = imadd(img_t,img_r,'uint8');

rgbImage = ind2rgb(img_addition, jet(256));
%imshow(rgbImage);
imwrite(rgbImage,'C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\7_10_20\bsl5_1_rgb.tif')
imwrite(img_addition,'C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\7_10_20\bsl5_1.tif')