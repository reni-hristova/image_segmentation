% Load the image and create a grey scale copy
cells_img = imread('cells.png');
gray_cells_img = uint8(rgb2gray(cells_img));

% Enhance the contrast of the image
img_imadjust = imadjust(gray_cells_img);

% Apply Opening by reconstruction
se = strel('disk', 15);
img_erode = imerode(img_imadjust,se);
img_open_reconstruct = imreconstruct(img_erode,img_imadjust);

% Apply Closing by reconstruction
img_dilate = imdilate(img_open_reconstruct,se);
img_close_reconstruct = imreconstruct(imcomplement(img_dilate),imcomplement(img_open_reconstruct));
img_close_reconstruct = imcomplement(img_close_reconstruct);

% Transform the background into a binary image
bg_regions_binary = imbinarize(img_open_reconstruct);

% Determine the Regional maximum
regional_max = imregionalmax(img_close_reconstruct);

% Compute the gradient of the image 
gradient = imgradient(img_imadjust);

% Distance transform 
dist_transform = bwdist(bg_regions_binary);
labels = watershed(dist_transform);
ridge_lines = labels == 0;

% Compute Watershed based segmentation
lines_complement = imimposemin(gradient, ridge_lines | regional_max);
final_labels = watershed(lines_complement);

% Create labels
colour_labels = label2rgb(final_labels,'jet','k','shuffle');

% Superimpose the segmentation on the image
figure(1)
imshow(img_imadjust)
hold on
overlayed_image = imshow(colour_labels);
overlayed_image.AlphaData = 0.4;
title('Visualise segmentation');
pause(1);