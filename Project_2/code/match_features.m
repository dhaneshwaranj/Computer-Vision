% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the interest points as additional features.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
% num_features = min(size(features1, 1), size(features2,1));
% matches = zeros(num_features, 2);
% matches(:,1) = randperm(num_features);
% matches(:,2) = randperm(num_features);
% confidences = rand(num_features,1);

%%My Code

%%Assigning parameters
matches = zeros(size(features1, 1), 2);                                     %Matches
confidences = zeros(size(features1, 1));                                    %Confidence
for i = 1:size(features1, 1)                                                %For each Feature in Image 1
    dist = zeros(size(features2, 1));                                       %Distances Vector
    for j = 1:size(features2, 1)                                            %For each Feature in Image 2
        dist(j) = norm(features1(i,:)-features2(j,:));                      %Compute Distances
    end
    [dist index] = sort(dist);                                              %Sort Distances in ascending Order
    confidences(i) = dist(2)/dist(1);                                       %Compute Comfidence
    matches(i,:) = [i, index(1)];                                           %Fix Matches based on Distance
end

% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
[confidences, ind] = sort(confidences, 'descend');
confidences = confidences(1:100);
matches = matches(ind(1:100),:);