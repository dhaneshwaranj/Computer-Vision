% Starter code prepared by James Hays for Computer Vision

%This feature representation is described in the handout, lecture
%materials, and Szeliski chapter 14.

function image_feats = get_bags_of_sifts(image_paths)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every run.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram
% ('vocab_size') below.

% You will want to construct SIFT features here in the same way you
% did in build_vocabulary.m (except for possibly changing the sampling
% rate) and then assign each local feature to its nearest cluster center
% and build a histogram indicating how many times each cluster was used.
% Don't forget to normalize the histogram, or else a larger image with more
% SIFT features will look very different from a smaller version of the same
% image.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be used for extra
  credit if you are constructing a "spatial pyramid".
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

D = vl_alldist2(X,Y) 
   http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator '  You can use this to figure out the closest
    cluster center for every SIFT feature. You could easily code this
    yourself, but vl_alldist2 tends to be much faster.

Or:

For speed, you might want to play with a KD-tree algorithm (we found it
reduced computation time modestly.) vl_feat includes functions for building
and using KD-trees.
 http://www.vlfeat.org/matlab/vl_kdtreebuild.html

%}

load('vocab.mat')
vocab_size = size(vocab, 1);

image_feats = zeros(size(image_paths,1),21*vocab_size);
% image_feats = [];
step = 14;

% % GIST Parameters:
% clear param
% param.imageSize = [256 280]; % set a normalized image size
% param.orientationsPerScale = [8 8 8 8]; % number of orientations per scale (from HF to LF)
% param.numberBlocks = 4;
% param.fc_prefilt = 4;
% 
% % Pre-allocate gist:
% Nfeatures = sum(param.orientationsPerScale)*param.numberBlocks^2;

for i=1:size(image_paths,1)
    img = single(imread(image_paths{i}));
    [locations, SIFT_features] = vl_dsift(img,'Step', step);
    D = vl_alldist2(single(SIFT_features), vocab');
    hist = zeros(1,21*vocab_size);
    for j=1:size(SIFT_features, 2)
        [dist index] = min(D(j,:));
        y = locations(1,j);
        x = locations(2,j);
        [M, N] = size(img);
        
        %Level-0
        hist(index) = hist(index) + 1;
        
        %Level-1
        if (y <= M/2) && (x <= N/2)
            hist(vocab_size + index) = hist(vocab_size + index) + 1;
        end
        if (y <= M/2) && (x > N/2)
            hist(2*vocab_size + index) = hist(2*vocab_size + index) + 1;
        end
        if (y > M/2) && (x <= N/2)
            hist(3*vocab_size + index) = hist(3*vocab_size + index) + 1;
        end
        if (y > M/2) && (x > N/2)
            hist(4*vocab_size + index) = hist(4*vocab_size + index) + 1;
        end
        
        %Level-2
        if (y <= M/4) && (x <= N/4)
            hist(5*vocab_size + index) = hist(5*vocab_size + index) + 1;
        end
        if (y <= M/4) && (x > N/4) && (x <= N/2)
            hist(6*vocab_size + index) = hist(6*vocab_size + index) + 1;
        end
        if (y <= M/4) && (x > N/2) && (x <= 3*N/4)
            hist(7*vocab_size + index) = hist(7*vocab_size + index) + 1;
        end
        if (y <= M/4) && (x > 3*N/4)
            hist(8*vocab_size + index) = hist(8*vocab_size + index) + 1;
        end
        
        if (y > M/4) && (y <= M/2) && (x <= N/4)
            hist(9*vocab_size + index) = hist(9*vocab_size + index) + 1;
        end
        if (y > M/4) && (y <= M/2) && (x > N/4) && (x <= N/2)
            hist(10*vocab_size + index) = hist(10*vocab_size + index) + 1;
        end
        if (y > M/4) && (y <= M/2) && (x > N/2) && (x <= 3*N/4)
            hist(11*vocab_size + index) = hist(11*vocab_size + index) + 1;
        end
        if (y > M/4) && (y <= M/2) && (x > 3*N/4)
            hist(12*vocab_size + index) = hist(12*vocab_size + index) + 1;
        end
        
        if (y > M/2) && (y <= 3*M/4) && (x <= N/4)
            hist(13*vocab_size + index) = hist(13*vocab_size + index) + 1;
        end
        if (y > M/2) && (y <= 3*M/4) && (x > N/4) && (x <= N/2)
            hist(14*vocab_size + index) = hist(14*vocab_size + index) + 1;
        end
        if (y > M/2) && (y <= 3*M/4) && (x > N/2) && (x <= 3*N/4)
            hist(15*vocab_size + index) = hist(15*vocab_size + index) + 1;
        end
        if (y > M/2) && (y <= 3*M/4) && (x > 3*N/4)
            hist(16*vocab_size + index) = hist(16*vocab_size + index) + 1;
        end
        
        if (y > M/4) && (x <= N/4)
            hist(17*vocab_size + index) = hist(17*vocab_size + index) + 1;
        end
        if (y > M/4) && (x > N/4) && (x <= N/2)
            hist(18*vocab_size + index) = hist(18*vocab_size + index) + 1;
        end
        if (y > M/4) && (x > N/2) && (x <= 3*N/4)
            hist(19*vocab_size + index) = hist(19*vocab_size + index) + 1;
        end
        if (y > M/4) && (x > 3*N/4)
            hist(20*vocab_size + index) = hist(20*vocab_size + index) + 1;
        end
        
    end
    for k=1:21*vocab_size
        if hist(k)==0
            hist(k) = -10;
        end
    end
    hist = hist/norm(hist);
    image_feats(i,:) = hist;
    
%     % Load first image and compute gist:
%     if i==1
%         [gist, param] = LMgist(img, '', param); % first call
%     % Loop:
%     else
%         gist = LMgist(img, '', param); % the next calls will be faster
%     end
%     feats = [hist gist];
%     feats = feats/norm(feats);
%     image_feats = [image_feats; feats];
end

end


