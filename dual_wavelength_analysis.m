%load both Transillumination and Reflectance images
t_img_raw = load('38_1300_BP1550_OPR 22.dat');
r_img_raw = load('38_1450_BP1550_OPR 22.dat');

t_img_raw_16 = t_img_raw * 16;
r_img_raw_16 = r_img_raw * 16;

t_img = uint16(t_img_raw_16);
r_img = uint16(r_img_raw_16);

%convert the 10bit images into 16 bit images
%bitdepth = 16;
%t_orig_img = uint16((transillumination_img) * (2^(bitdepth))/(2^(10)));
%r_orig_img = uint16((reflectance_img) * (2^(bitdepth))/(2^(10)));

%add reflectance image on top of the inverse of the transillumination image
img_t = 0.5*(65536 - t_img);
img_r = 0.5*(r_img);
img_addition = imadd(img_t,img_r,'uint16');
add_img = img_addition;

%Normalize them
%t_img = mat2gray(t_img_1);
%r_img = mat2gray(r_img_1);
%add_img = mat2gray(img_addition);

%Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(t_img, []);
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

% Display transillumination image
subplot(2, 3, 1);
imshow(t_img, []);
axis on;
drawnow;
title('Original Transillumination Image', 'FontSize', fontSize);

% Display reflectance image
subplot(2, 3, 2);
imshow(r_img, []);
axis on;
drawnow;
title('Original Reflectance Image', 'FontSize', fontSize);

% Display fusion image
subplot(2, 3, 3);
imshow(add_img, []);
axis on;
drawnow;
title('Dual Mode Image', 'FontSize', fontSize);

% Label the binary image to transillumination image and compute the centroid and center of mass.
labeledImage = bwlabel(binaryImage);
measurements_trans = regionprops(binaryImage, t_img, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_trans = measurements_trans.Area
centroid_trans = measurements_trans.Centroid
centerOfMass_trans = measurements_trans.WeightedCentroid
perimeter_trans = measurements_trans.Perimeter

% Label the binary image to reflectance image and compute the controid and center of mass.
measurements_ref = regionprops(binaryImage, r_img, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_ref = measurements_ref.Area
centroid_ref = measurements_ref.Centroid
centerOfMass_ref = measurements_ref.WeightedCentroid
perimeter_ref = measurements_ref.Perimeter

% Label the binary image to dual mode image and compute the controid and center of mass.
measurements_add = regionprops(binaryImage, add_img, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_add = measurements_add.Area
centroid_add = measurements_add.Centroid
centerOfMass_add = measurements_add.WeightedCentroid
perimeter_add = measurements_add.Perimeter

% Calculate the area, in pixels, that they drew.
numberOfPixels1 = sum(binaryImage(:))
% Another way to calculate it that takes fractional pixels into account.
numberOfPixels2 = bwarea(binaryImage)

% Get coordinates of the boundary of the freehand drawn region.
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
subplot(2, 3, 1); % Plot over original Transillumination image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
subplot(2, 3, 2); % Plot over original Reflectance image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.
subplot(2, 3, 3); % Plot over original Reflectance image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.


% Mask the images outside the mask, and display it.
% Will keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage_trans = t_img;
blackMaskedImage_trans(~binaryImage) = 0;
subplot(2, 3, 4);
imshow(blackMaskedImage_trans);
axis on;
title('Masked Transillumination Image', 'FontSize', fontSize);

blackMaskedImage_ref = r_img;
blackMaskedImage_ref(~binaryImage) = 0;
subplot(2, 3, 5);
imshow(blackMaskedImage_ref);
axis on;
title('Masked Reflectance Image', 'FontSize', fontSize);

blackMaskedImage_add = add_img;
blackMaskedImage_add(~binaryImage) = 0;
subplot(2, 3, 6);
imshow(blackMaskedImage_add);
axis on;
title('Masked Dual Probe Image', 'FontSize', fontSize);

% Calculate the means
meanGL_trans = mean(blackMaskedImage_trans(binaryImage));
sdGL_trans = std(double(blackMaskedImage_trans(binaryImage)));
meanGL_ref = mean(blackMaskedImage_ref(binaryImage));
sdGL_ref = std(double(blackMaskedImage_ref(binaryImage)));
meanGL_add = mean(blackMaskedImage_add(binaryImage));
sdGL_add = std(double(blackMaskedImage_add(binaryImage)));

% Report results.
message = sprintf('Trans ROI mean = %.3f\nTrans ROI Standard Deviation = %.3f\nNumber of pixels = %d\nRef ROI mean = %.3f\nRef ROI Standard Deviation = %.3f\nDual Mode ROI mean = %.3f\nRef Dual Mode Standard Deviation = %.3f', meanGL_trans, sdGL_trans, numberOfPixels1, meanGL_ref, sdGL_ref, meanGL_add, sdGL_add);
msgbox(message);



