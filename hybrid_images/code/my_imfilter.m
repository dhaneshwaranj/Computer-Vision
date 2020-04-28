function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should work for color images. Simply filter each color
% channel independently.

% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.

% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.

% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);


%%%%%%%%%%%%%%%%
% Your code here
%% Assigning Parameters
[frow,fcol] = size(filter);                                                 %filter size
rowshift = floor(frow/2);                                                   %param for padding rows
colshift = floor(fcol/2);                                                   %param for padding cols
image = padarray(image,[rowshift, colshift], 'symmetric');                  %pad image (0s/circ/repl/symm)
[nrows, ncols, nchannels] = size(image);                                    %image size
output = zeros(nrows,ncols,nchannels);                                      %intermediate output image size
%imwrite(image, 'Padded.jpg', 'quality', 95);                               %Saving intermediate image
%% Filtering
for i=1:nchannels                                                           %For each channel
    for j=1+rowshift:nrows-rowshift                                         %For each Row
        for k=1+colshift:ncols-colshift                                     %For each Column
            temp = image(j-rowshift:j+rowshift, ...                         %Multiplying the filter and 
                   k-colshift:k+colshift,i).*filter;                        %the image element-wise
            output(j,k,i) = sum(temp(:));                                   %Add and store in center pixel         
        end
    end
end

%% Cutting the padded part
output = output(rowshift+1:nrows-rowshift, colshift+1:ncols-colshift, :);
%imwrite(output, 'Filtered.jpg', 'quality', 95);                            %Saving intermediate image
%%%%%%%%%%%%%%%%
