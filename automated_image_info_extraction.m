% Crop the binary mask and contrast images
% Draw ROI in imfreehand and get ROI info
fontSize = 16;
imshow(img_16);
axis on;
title('Contrast_adjusted_image', 'FontSize', fontSize);
set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.

% Ask user to draw freehand mask for Sound ROI.
message = sprintf('Left click and hold to begin drawing targeted tooth.\nSimply lift the mouse button to finish');
uiwait(msgbox(message));
hFH = imfreehand(); % Actual line of code to do the drawing.
% Create a binary image ("mask") from the ROI object.
binaryImage_contrast = hFH.createMask();

close all;

% Crop images
blackMaskedImage_contrast = contrast_img;
blackMaskedImage_contrast(~binaryImage_contrast) = 0;
cropped_mask = mask;
cropped_mask(~binaryImage_contrast) = 0;

% Display the binary mask image
imshow(cropped_mask);
title('Binary Mask');

% Find connected components in the binary mask
cc = bwconncomp(cropped_mask);

% Get properties of all connected components
props = regionprops(cc, 'all');

% Prompt the user to click on a region
disp('Click on a region to select it.');
[x, y] = ginput(1); % Wait for user input

% Convert clicked (x, y) coordinates to (row, column) format
clickedRow = round(y);
clickedColumn = round(x);

% Find the component index corresponding to the clicked pixel
clickedComponentIndex = 0;

for i = 1:cc.NumObjects
    % Check if the clicked coordinates fall within the region's PixelIdxList
    if ismember(sub2ind(size(cropped_mask), clickedRow, clickedColumn), cc.PixelIdxList{i})
        clickedComponentIndex = i;
        break;
    end
end

% Check if a valid region was clicked
if clickedComponentIndex > 0
    selectedRegion = props(clickedComponentIndex);
    assignin('base', 'selectedRegion', selectedRegion);
    disp('Selected region properties have been loaded into the workspace.');
    
    % Display the selected region using its bounding box
    selectedRegionImage = false(size(cropped_mask));
    selectedRegionImage(cc.PixelIdxList{clickedComponentIndex}) = true;
    
    figure;
    imshow(selectedRegionImage);
    title('Selected Region');
else
    disp('No region selected.');
end

% Calculate the contrast within this ROI
ROI_contrast = mean(contrast_img(selectedRegionImage));
formattedLength = sprintf('%.6f', ROI_contrast);
disp(['Mean ROI Contrast: ' formattedLength]);
% Display Area of the ROI
disp(['Number of pixels in the ROI: ' num2str(selectedRegion.Area)]);

% Draw the ruler by dragging the mouse cursor
hLine = imline;
position = wait(hLine);
delete(hLine);
    
% Calculate distance and orientation of the ruler line
dx = position(2, 1) - position(1, 1);
dy = position(2, 2) - position(1, 2);
distance = sqrt(dx^2 + dy^2);
orientation = atan2d(dy, dx);
    
% Display ruler line on the image
hold on;
plot(position(:, 1), position(:, 2), 'r', 'LineWidth', 2);
hold off;
    
% Calculate the length of non-zero pixels along the ruler
rulerProfile = improfile(selectedRegionImage, position(:, 1), position(:, 2));
lengthNonZeroPixels = sum(rulerProfile);
    
disp(['Length of non-zero pixels along the ruler: ' num2str(lengthNonZeroPixels)]);
% Display the frame number of the analyzed image
file

    
