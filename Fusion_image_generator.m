%% Select Files

file = uigetfile('*.*', 'select transillumination image');
t_img = imread(file);

file = uigetfile('*.*', 'select reflectance image');
r_img = imread(file);


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

%% Draw Lesion vs. Sound ROI with freehand

%Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(r_img, []);
axis on;
title('Original Transillumination Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
xy = hFH.getPosition;


%%


%Plot the Images
subplot(2, 6, 1);
imshow(r_img);
axis on;
drawnow;
title('R');

subplot(2, 6, 2);
imshow(add_01);
axis on;
drawnow;
title('a=0.1');

subplot(2, 6, 3);
imshow(add_02);
axis on;
drawnow;
title('a=0.2');

subplot(2, 6, 4);
imshow(add_03);
axis on;
drawnow;
title('a=0.3');

subplot(2, 6, 5);
imshow(add_04);
axis on;
drawnow;
title('a=0.4');

subplot(2, 6, 6);
imshow(add_05);
axis on;
drawnow;
title('a=0.5');

subplot(2, 6, 7);
imshow(add_06);
axis on;
drawnow;
title('a=0.6');

subplot(2, 6, 8);
imshow(add_07);
axis on;
drawnow;
title('a=0.7');

subplot(2, 6, 9);
imshow(add_08);
axis on;
drawnow;
title('a=0.8');

subplot(2, 6, 10);
imshow(add_09);
axis on;
drawnow;
title('a=0.9');

subplot(2,6,11);
imshow(t_img);
axis on;
drawnow;
title('Transillumination');

%%
% Label the binary image to reflectance image and compute the controid and center of mass.
measurements_ref = regionprops(binaryImage, r_img, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_ref = measurements_ref.Area
centroid_ref = measurements_ref.Centroid
centerOfMass_ref = measurements_ref.WeightedCentroid
perimeter_ref = measurements_ref.Perimeter

% Calculate the area, in pixels, that they drew.
numberOfPixels1 = sum(binaryImage(:))
% Another way to calculate it that takes fractional pixels into account.
numberOfPixels2 = bwarea(binaryImage)

% Get coordinates of the boundary of the freehand drawn region.
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
subplot(2, 6, 11); % Plot over original Transillumination image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
subplot(2, 6, 1); % Plot over original Reflectance image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
%%


% Mask the images outside the mask, and display it.
% Will keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage_trans = t_img;
blackMaskedImage_trans(~binaryImage) = 0;

blackMaskedImage_ref = r_img;
blackMaskedImage_ref(~binaryImage) = 0;

blackMaskedImage_add01 = add_01;
blackMaskedImage_add01(~binaryImage) = 0;

blackMaskedImage_add02 = add_02;
blackMaskedImage_add02(~binaryImage) = 0;

blackMaskedImage_add03 = add_03;
blackMaskedImage_add03(~binaryImage) = 0;

blackMaskedImage_add04 = add_04;
blackMaskedImage_add04(~binaryImage) = 0;

blackMaskedImage_add05 = add_05;
blackMaskedImage_add05(~binaryImage) = 0;

blackMaskedImage_add06 = add_06;
blackMaskedImage_add06(~binaryImage) = 0;

blackMaskedImage_add07 = add_07;
blackMaskedImage_add07(~binaryImage) = 0;

blackMaskedImage_add08 = add_08;
blackMaskedImage_add08(~binaryImage) = 0;

blackMaskedImage_add09 = add_09;
blackMaskedImage_add09(~binaryImage) = 0;

% Calculate the means
meanGL_trans = mean(blackMaskedImage_trans(binaryImage));
sdGL_trans = std(double(blackMaskedImage_trans(binaryImage)));
meanGL_ref = mean(blackMaskedImage_ref(binaryImage));
sdGL_ref = std(double(blackMaskedImage_ref(binaryImage)));
meanGL_add01 = mean(blackMaskedImage_add01(binaryImage));
sdGL_add01 = std(double(blackMaskedImage_add01(binaryImage)));
meanGL_add02 = mean(blackMaskedImage_add02(binaryImage));
sdGL_add02 = std(double(blackMaskedImage_add02(binaryImage)));
meanGL_add03 = mean(blackMaskedImage_add03(binaryImage));
sdGL_add03 = std(double(blackMaskedImage_add03(binaryImage)));
meanGL_add04 = mean(blackMaskedImage_add04(binaryImage));
sdGL_add04 = std(double(blackMaskedImage_add04(binaryImage)));
meanGL_add05 = mean(blackMaskedImage_add05(binaryImage));
sdGL_add05 = std(double(blackMaskedImage_add05(binaryImage)));
meanGL_add06 = mean(blackMaskedImage_add06(binaryImage));
sdGL_add06 = std(double(blackMaskedImage_add06(binaryImage)));
meanGL_add07 = mean(blackMaskedImage_add07(binaryImage));
sdGL_add07 = std(double(blackMaskedImage_add07(binaryImage)));
meanGL_add08 = mean(blackMaskedImage_add08(binaryImage));
sdGL_add08 = std(double(blackMaskedImage_add08(binaryImage)));
meanGL_add09 = mean(blackMaskedImage_add09(binaryImage));
sdGL_add09 = std(double(blackMaskedImage_add09(binaryImage)));

%% Report Results
ImageModality = {'reflectance', 'a01','a02','a03','a04','a05','a06','a07','a08','a09','transillumination'};
ROI_Intensity = [meanGL_ref,meanGL_add01,meanGL_add02,meanGL_add03,meanGL_add04,meanGL_add05,meanGL_add06,meanGL_add07,meanGL_add08,meanGL_add09,meanGL_trans];
ROI_STDL = [sdGL_ref,sdGL_add01,sdGL_add02,sdGL_add03,sdGL_add04,sdGL_add05,sdGL_add06,sdGL_add07,sdGL_add08,sdGL_add09,sdGL_trans];

T = table(ImageModality',ROI_Intensity',ROI_STDL','VariableNames',{'Image Modality','Intensity','Standard Deviation'});

disp(T);





