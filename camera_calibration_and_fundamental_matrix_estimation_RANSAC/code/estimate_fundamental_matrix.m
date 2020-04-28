% Fundamental Matrix Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by Henry Hu

% Returns the camera center matrix for a given projection matrix

% 'Points_a' is nx2 matrix of 2D coordinate of points on Image A
% 'Points_b' is nx2 matrix of 2D coordinate of points on Image B
% 'F_matrix' is 3x3 fundamental matrix

% Try to implement this function as efficiently as possible. It will be
% called repeatly for part III of the project

function [ F_matrix ] = estimate_fundamental_matrix(Points_a,Points_b)

%%%%%%%%%%%%%%%%
% Your code here
Cu_a = mean(Points_a(:,1));
Cv_a = mean(Points_a(:,2));
Cu_b = mean(Points_b(:,1));
Cv_b = mean(Points_b(:,2));

u_a = Points_a(:,1);
v_a = Points_a(:,2);
u_b = Points_b(:,1);
v_b = Points_b(:,2);

s_a = 1/sqrt(mean(((u_a-Cu_a).^2)+((v_a-Cv_a).^2)));
S_a = [s_a 0 0;
     0 s_a 0;
     0 0 1];
CUV_a = [1 0 -Cu_a;
       0 1 -Cv_a;
       0 0 1];
T_a = S_a*CUV_a;

s_b = 1/sqrt(mean(((u_b-Cu_b).^2)+((v_b-Cv_b).^2)));
S_b = [s_b 0 0;
     0 s_b 0;
     0 0 1];
CUV_b = [1 0 -Cu_b;
       0 1 -Cv_b;
       0 0 1];
T_b = S_b*CUV_b;

UV_a = T_a*[u_a'; v_a'; ones(1,size(Points_a,1))];
UV_b = T_b*[u_b'; v_b'; ones(1,size(Points_b,1))];

Points_a = [UV_a(1,:)' UV_a(2,:)'];
Points_b = [UV_b(1,:)' UV_b(2,:)'];

nPoints = size(Points_a, 1);
A = zeros(nPoints, 9);
for i=1:nPoints
    A(i,:) = [Points_b(i,1)*Points_a(i,1) Points_b(i,1)*Points_a(i,2) ...
              Points_b(i,1) Points_b(i,2)*Points_a(i,1) ...
              Points_b(i,2)*Points_a(i,2) Points_b(i,2) ...
              Points_a(i,1) Points_a(i,2) 1];
end
[U, S, V] = svd(A);
F_matrix = V(:,end);
F_matrix = reshape(F_matrix, [3 3])';
[U, S, V] = svd(F_matrix);
S(3,3) = 0;
F_matrix = U*S*V';

F_matrix = T_b'*F_matrix*T_a;
%%%%%%%%%%%%%%%%

%This is an intentionally incorrect Fundamental matrix placeholder
% F_matrix = [0  0     -.0004; ...
%             0  0      .0032; ...
%             0 -0.0044 .1034];
        
end

