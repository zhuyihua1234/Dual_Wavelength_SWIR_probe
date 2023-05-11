img_raw = load('C:\Users\Daniel Fried\Desktop\Yihua\Dual_probe\RawImages_InGaAs\raw dat images\7_9_20_dat\bsl11_t_BP1150_OPR 20.dat');
img_raw_16 = img_raw * 16;
img = uint16(img_raw_16);

%Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(img, []);
axis on;
title('Original Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask.
message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
xy = hFH.getPosition;

% Display image
subplot(2, 1, 1);
imshow(img, []);
axis on;
drawnow;
title('Original Image', 'FontSize', fontSize);

% Label the binary image to transillumination image and compute the centroid and center of mass.
labeledImage = bwlabel(binaryImage);
measurements_trans = regionprops(binaryImage, img, ...
    'Area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area_trans = measurements_trans.Area
centroid_trans = measurements_trans.Centroid
centerOfMass_trans = measurements_trans.WeightedCentroid
perimeter_trans = measurements_trans.Perimeter

% Calculate the area, in pixels, that they drew.
numberOfPixels1 = sum(binaryImage(:))
% Another way to calculate it that takes fractional pixels into account.
numberOfPixels2 = bwarea(binaryImage)

% Get coordinates of the boundary of the freehand drawn region.
structBoundaries = bwboundaries(binaryImage);
xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
x = xy(:, 2); % Columns.
y = xy(:, 1); % Rows.
subplot(2, 1, 1); % Plot over original image.
hold on; 
plot(x, y, 'LineWidth', 2);
drawnow; % Force it to draw immediately.


% Mask the images outside the mask, and display it.
% Will keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage = img;
blackMaskedImage(~binaryImage) = 0;

% Calculate the means
meanGL = mean(blackMaskedImage(binaryImage));
sdGL = std(double(blackMaskedImage(binaryImage)));

% Report results.
message = sprintf('ROI mean = %.3f\nROI Standard Deviation = %.3f\nNumber of pixels = %d', meanGL, sdGL, numberOfPixels1);
msgbox(message);