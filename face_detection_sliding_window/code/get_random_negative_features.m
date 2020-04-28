% Starter code prepared by James Hays for CS 4476, Georgia Tech
% This function should return negative training examples (non-faces) from
% any images in 'non_face_scn_path'. Images should be converted to
% grayscale because the positive training data is only available in
% grayscale. For best performance, you should sample random negative
% examples at multiple scales.

function features_neg = get_random_negative_features(non_face_scn_path, feature_params, num_samples)
% 'non_face_scn_path' is a string. This directory contains many images
%   which have no faces in them.
% 'feature_params' is a struct, with fields
%   feature_params.template_size (default 36), the number of pixels
%      spanned by each train / test template and
%   feature_params.hog_cell_size (default 6), the number of pixels in each
%      HoG cell. template size should be evenly divisible by hog_cell_size.
%      Smaller HoG cell sizes tend to work better, but they make things
%      slower because the feature dimensionality increases and more
%      importantly the step size of the classifier decreases at test time.
% 'num_samples' is the number of random negatives to be mined, it's not
%   important for the function to find exactly 'num_samples' non-face
%   features, e.g. you might try to sample some number from each image, but
%   some images might be too small to find enough.

% 'features_neg' is N by D matrix where N is the number of non-faces and D
% is the template dimensionality, which would be
%   (feature_params.template_size / feature_params.hog_cell_size)^2 * 31
% if you're using the default vl_hog parameters

% Useful functions:
% vl_hog, HOG = VL_HOG(IM, CELLSIZE)
%  http://www.vlfeat.org/matlab/vl_hog.html  (API)
%  http://www.vlfeat.org/overview/hog.html   (Tutorial)
% rgb2gray

image_files = dir( fullfile( non_face_scn_path, '*.jpg' ));
num_images = length(image_files);
index = randsample(num_images, num_images);
D = (feature_params.template_size / feature_params.hog_cell_size)^2 * 31;
template = feature_params.template_size;
template2 = (feature_params.template_size)^2;
cellsize = feature_params.hog_cell_size;
features_neg = zeros(num_samples, D);

count = 1;
for i=1:num_images
   if count > num_samples
       break;
   end
   
   img = im2single(rgb2gray(imread(fullfile(non_face_scn_path, image_files(index(i)).name))));
   [row, col] = size(img);
   num = round(row*col/template2);
   for j=1:num
       r = randi([1 row-template], 1, 1);
       c = randi([1 col-template], 1, 1);
       img1 = img(r:r+template,c:c+template);
       hog_features = reshape(vl_hog(img1, cellsize), [1, D]);
       features_neg(count,:) = hog_features;
       count = count + 1;
       if count > num_samples
           break;
       end
   end
   
end


% placeholder to be deleted. 100 random features.
% features_neg = rand(100, (feature_params.template_size / feature_params.hog_cell_size)^2 * 31);