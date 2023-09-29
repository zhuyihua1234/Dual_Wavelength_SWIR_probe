%Import image
file = uigetfile('*.*');
raw_img = imread(file);
img_16 = fliplr(raw_img);
grayImage = double(img_16);

%%
% Select imaging modality
options = {'Reflectance', 'Transillumination'};

% Display a dialog box to choose between the options
choice = listdlg('PromptString', 'Select a variable:', ...
                 'SelectionMode', 'single', ...
                 'ListString', options, ...
                 'Name', 'Variable Selection');

% Depending on the choice, define the selected variable
if choice == 1
    selectedVariable = 'R'; % Replace with the actual variable name
elseif choice == 2
    selectedVariable = 'T'; % Replace with the actual variable name
else
    error('No variable selected.');
end

%%
%Calibrate contrast threshold by calculating contrast of every pixel

%Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(grayImage, []);
axis on;
title('Original Grayscale Image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask for Sound ROI.
message = sprintf('Left click and hold to begin drawing Sound ROI.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage = hFH.createMask();
xy = hFH.getPosition;

close all;

% Label the binary image and computer the centroid and center of mass.
labeledImage = bwlabel(binaryImage);
measurements = regionprops(binaryImage, grayImage, ...
    'area', 'Centroid', 'WeightedCentroid', 'Perimeter');
area = measurements.Area
centroid = measurements.Centroid
centerOfMass = measurements.WeightedCentroid
perimeter = measurements.Perimeter

% Calculate the area, in pixels, that they drew.
numberOfPixels1 = sum(binaryImage(:))
% Another way to calculate it that takes fractional pixels into account.
numberOfPixels2 = bwarea(binaryImage)

% Mask the image outside the mask, and display it.
% Will keep only the part of the image that's inside the mask, zero outside mask.
blackMaskedImage = grayImage;
blackMaskedImage(~binaryImage) = 0;

% Calculate the means for both lesion and sound
meanGL = mean(blackMaskedImage(binaryImage));
sdGL = std(double(blackMaskedImage(binaryImage)));


% Calculate contrast for every single pixel

% Get image dimensions
[rows,cols,channels] = size(grayImage);

if selectedVariable == 'R',
    % Reflectance

    % Define the transformation equation
    transformationEquation = @(x) (x - meanGL)/x; 
elseif selectedVariable == 'T',
    transformationEquation = @(x) (abs((meanGL - x)/meanGL));
else
    error('No variable selected.');
end

% Apply the equation to each pixel
for row = 1:rows
    for col = 1:cols
        for channel = 1:channels
            contrast_img(row, col) = transformationEquation(grayImage(row, col));
        end
    end
end


% Set contrast threshold
if selectedVariable == 'R',
    threshold = 0.10;
elseif selectedVariable == 'T',
    threshold = 0.10;
else
    error('No variable selected.');
end

% Create a mask for pixels with intensity above X
mask = contrast_img > threshold;

% Initialize the output image with zeros
outputImage = zeros(size(contrast_img), 'like', contrast_img);

% Apply the mask to the output image
outputImage(mask) = contrast_img(mask);

% Display the masked image
subplot(2,2,1);
imshow(img_16);
title('Original Image', 'FontSize', fontSize);

subplot(2,2,2);
imshow(contrast_img);
title('Contrast corrected image', 'FontSize', fontSize);

subplot(2,2,3);
imshow(outputImage);
title('0.1 Contrast Thresholding Image', 'FontSize', fontSize);

subplot(2,2,4);
imshow(mask);
title('0.1 Contrast Thresholding Mask', 'FontSize', fontSize);

