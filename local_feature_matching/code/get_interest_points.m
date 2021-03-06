% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
% function [x, y, confidence, scale, orientation] = get_interest_points(image, feature_width)
function [x, y] = get_interest_points(image, feature_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% % Placeholder that you can delete -- random points
% x = ceil(rand(500,1) * size(image,2));
% y = ceil(rand(500,1) * size(image,1));

%%My Code
%%Assigning Parameters
F_size = 3;                                         %Filter Size                       
F_cutoff = 1;                                       %Cut-off Frequency
alpha = 0.06;

%Filters
y_sobel = fspecial('sobel');                        %Y-Direction Filter
x_sobel = y_sobel';                                 %XDirection Filter
Ix = imfilter(image, x_sobel);                      %X-Direction Gradient
Iy = imfilter(image, y_sobel);                      %Y-Direction Gradient

%%Correctness Function Calculation
Ix2 = Ix.*Ix;                                       %Correctness Function
Iy2 = Iy.*Iy;                                       %Images
IxIy = Ix.*Iy;

Gauss = fspecial('gaussian', F_size, F_cutoff);     %Big Gaussian
GIx2 = imfilter(Ix2, Gauss);
GIy2 = imfilter(Iy2, Gauss);
GIxIy2 = imfilter(IxIy, Gauss).^2;
har = GIx2.*GIy2- GIxIy2 - alpha.*(GIx2+GIy2).^2;   %Correctness Function

har = har > 0.1;                                   %Threshold

%%Non-Maxima Supppression
cc = bwconncomp(har);                               %Connected Components
x = [];
y = [];
for i = 1:cc.NumObjects                             %Non-Maxima Suppression
    patch = cc.PixelIdxList{i};                     %Indices of Conn. Comp.
    max_val = max(har(patch));                  
    for j = 1:size(patch,1)                         %For each Conn. Component
        if har(j) == max_val;
            max_index = patch(j);                   %Find Local Maximum
        end
    end
    [row, col] = size(har);                     
    [a, b] = ind2sub([row col], max_index);
    %For Rushmore, multiply feature widths by 4 and 7 for Episcodal Gaudi
    if a>feature_width && a<row-feature_width ... %Don't consider points
            && b>feature_width && b<col-feature_width
        y = [y; a];                                 %near Boundaries.
        x = [x; b];                                 
    end
end
end