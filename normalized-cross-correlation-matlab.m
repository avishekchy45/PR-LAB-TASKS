clc;
close all;

% Reading Dataset & Candidate Image
% candidate = imread('D:\Avishek\Dataset\Numbers_0.png');
dataset = imread(fullfile(matlabdrive, 'DATASET_PRL','Vowels_Template.png'));
candidate = imread(fullfile(matlabdrive, 'DATASET_PRL','Vowels_9.png'));
% dataset = imread(fullfile(matlabdrive, 'DATASET_PRL','Numbers_Template.png'));
% candidate = imread(fullfile(matlabdrive, 'DATASET_PRL','Numbers_9.png'));
figure(),imshow(dataset);
figure(),imshow(candidate);

% Defining Size of Dataset
n = 11;

% Calculating Height & Weight of Images
m = 50;
dataset_height = m;
candidate_height = dataset_height;
dataset_weight = n * m;
candidate_weight = m;

% Resizing Images
dataset = imresize(dataset, [dataset_height dataset_weight]);
candidate = imresize(candidate, [candidate_height candidate_weight]);
% figure(),imshow(dataset);
% figure(),imshow(candidate);

% Converting RGB Images to Grayscale
dataset_gray = rgb2gray(dataset);
candidate_gray = rgb2gray(candidate);
% figure(),imshow(dataset_gray);
% figure(),imshow(candidate_gray);

% Computing a Global Threshold Value from Grayscale Image(Using Otsu Method)
dataset_threshold = graythresh(dataset_gray);
candidate_threshold = graythresh(candidate_gray);

% Converting Grayscale Image to Binary Image
% candidate_bw = im2bw(candidate_gray, candidate_threshold);
dataset_bw = imbinarize(dataset_gray, dataset_threshold);
candidate_bw = imbinarize(candidate_gray, candidate_threshold);
% figure(),imshow(dataset_bw);
% figure(),imshow(candidate_bw);

% Computing Correlation Coefficient between Candidate & Each Image of Dataset
j = 0;
all_cc = zeros(0, n); % Creating array of all zeros for storing Correlation Coefficient values
for i = 0:n-1
    Image = imcrop(dataset_bw,[j+1 1 candidate_weight-1 candidate_height]); % Cropping image one by one from dataset for template matching
    % figure(),imshow(Image);
    all_cc(i+1) = corr2(candidate_bw, Image); % Computing the 2-D correlation coefficient
    fprintf('%f ',all_cc(i+1));
    j = j + 50;
end

% Checking for the Value and Index of the Highest Correlation Coefficient
[value, index] = max(all_cc);
fprintf('\nCandidate Image Best Matched with %d ( %.2f )', index-1, value);

% Drawing a Bundary Box on the Dataset for Matched Candidate
figure(),imshow(dataset);
title('Matched Template with Boundary Box');
rectangle('Position',[(index-1)*candidate_weight+1  1 candidate_weight-1  candidate_height-1], 'Curvature', 0.2, 'Edgecolor', 'g', 'LineWidth', 3);
