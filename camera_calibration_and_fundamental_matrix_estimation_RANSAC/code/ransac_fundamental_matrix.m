% RANSAC Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Find the best fundamental matrix using RANSAC on potentially matching
% points

% 'matches_a' and 'matches_b' are the Nx2 coordinates of the possibly
% matching points from pic_a and pic_b. Each row is a correspondence (e.g.
% row 42 of matches_a is a point that corresponds to row 42 of matches_b.

% 'Best_Fmatrix' is the 3x3 fundamental matrix
% 'inliers_a' and 'inliers_b' are the Mx2 corresponding points (some subset
% of 'matches_a' and 'matches_b') that are inliers with respect to
% Best_Fmatrix.

% For this section, use RANSAC to find the best fundamental matrix by
% randomly sample interest points. You would reuse
% estimate_fundamental_matrix() from part 2 of this assignment.

% If you are trying to produce an uncluttered visualization of epipolar
% lines, you may want to return no more than 30 points for either left or
% right images.

function [ Best_Fmatrix, inliers_a, inliers_b] = ransac_fundamental_matrix(matches_a, matches_b)


%%%%%%%%%%%%%%%%
% Your code here
nSamples = 8;
n = size(matches_a,1);
delta = 0.001;
N = 0;
best_sample = zeros(nSamples,1);
confidences = zeros(n,1);
j = 0;
while N<(0.50*n)
    j = j+1;
    samples = randsample(n, nSamples);
    samples_a = matches_a(samples, :);
    samples_b = matches_b(samples, :);
    Best_Fmatrix = estimate_fundamental_matrix(samples_a, samples_b);
    N_temp = 0;
    for i=1:n
        a = [matches_a(i,:), 1]';
        b = [matches_b(i,:), 1]';
        residue = b'*Best_Fmatrix*a;
        confidences(i) = abs(residue);
        if abs(residue) < delta
           N_temp = N_temp+1;
        end
    end
    if N_temp > N
        N = N_temp;
        best_sample = samples;
    end
end
j
[confidences index] = sort(confidences);
inliers_a = matches_a(index(1:N),:);
inliers_b = matches_b(index(1:N),:);
%%%%%%%%%%%%%%%%

% Your ransac loop should contain a call to 'estimate_fundamental_matrix()'
% that you wrote for part II.

%placeholders, you can delete all of this
% Best_Fmatrix = estimate_fundamental_matrix(matches_a(1:10,:), matches_b(1:10,:));
% inliers_a = matches_a(1:30,:);
% inliers_b = matches_b(1:30,:);

end

