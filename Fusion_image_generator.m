t_img_raw = load('C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\3_10_20\M11_T_BP1550_OPR 22.dat');
r_img_raw = load('C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages\3_10_20\M11_R_BP1550_OPR 22.dat');

t_img_raw_16 = t_img_raw * 16;
r_img_raw_16 = r_img_raw * 16;

t_img_uncropped = uint16(t_img_raw_16);
r_img_uncropped = uint16(r_img_raw_16);

t_img = imcrop(t_img_uncropped,[460 345 490 385])
r_img = imcrop(r_img_uncropped,[460 345 490 385])

%Compute Dual Probe Images
%a=0.5
img_05t = 0.5*(65536 - t_img);
img_05r = 0.5*(r_img);
add_05 = imadd(img_05t,img_05r,'uint16');

%a=0.1
img_01t = 0.1*(65536 - t_img);
img_01r = 0.9*(r_img);
add_01 = imadd(img_01t,img_01r,'uint16');

%a=0.2
img_02t = 0.2*(65536 - t_img);
img_02r = 0.8*(r_img);
add_02 = imadd(img_02t,img_02r,'uint16');

%a=0.3
img_03t = 0.3*(65536 - t_img);
img_03r = 0.7*(r_img);
add_03 = imadd(img_03t,img_03r,'uint16');

%a=0.4
img_04t = 0.4*(65536 - t_img);
img_04r = 0.6*(r_img);
add_04 = imadd(img_04t,img_04r,'uint16');

%a=0.6
img_06t = 0.6*(65536 - t_img);
img_06r = 0.4*(r_img);
add_06 = imadd(img_06t,img_06r,'uint16');

%a=0.7
img_07t = 0.7*(65536 - t_img);
img_07r = 0.3*(r_img);
add_07 = imadd(img_07t,img_07r,'uint16');

%a=0.8
img_08t = 0.8*(65536 - t_img);
img_08r = 0.2*(r_img);
add_08 = imadd(img_08t,img_08r,'uint16');

%a=0.9
img_09t = 0.9*(65536 - t_img);
img_09r = 0.1*(r_img);
add_09 = imadd(img_09t,img_09r,'uint16');

%a=1.0
img_10t = 1*(65536 - t_img);
img_10r = 0*(r_img);
add_10 = imadd(img_10t,img_10r,'uint16');

%Plot the Images
subplot(2, 5, 1);
imshow(r_img);
title('a=0');

subplot(2, 5, 2);
imshow(add_01);
title('a=0.1');

subplot(2, 5, 3);
imshow(add_02);
title('a=0.2');

subplot(2, 5, 4);
imshow(add_03);
title('a=0.3');

subplot(2, 5, 5);
imshow(add_04);
title('a=0.4');

subplot(2, 5, 6);
imshow(add_05);
title('a=0.5');

subplot(2, 5, 7);
imshow(add_06);
title('a=0.6');

subplot(2, 5, 8);
imshow(add_07);
title('a=0.7');

subplot(2, 5, 9);
imshow(add_08);
title('a=0.8');

subplot(2, 5, 10);
imshow(add_09);
title('a=0.9');
