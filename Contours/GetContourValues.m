% GetContourValues.m

% This script calculates the mean and std of image values defined by a
% contour. The contour must be in binary format with outside of contour = 0
% and indside of contour = 1. The binary contour image and the image must have
% equal dimensions.

% inputs
% contour: a binary contour image of dimensions (image_x, image_y)
% image: image of dimension (image_x, image_y)
% mode: mode of data vaues, 'mean' of pixels, 'median' of pixels or 'sum' of pixels

function [output, Cstd] = GetContourValues(contour, image, mode)

contour(contour == 0) = NaN;           % no zeroes
Cvalue = image .* contour;             % extract values
Cvalue(isnan(Cvalue)) = [];            % remove NaNs
Cvalue = Cvalue(:);
Cstd = std(Cvalue);                    % take std

switch mode

    case 'mean'
        output = mean(Cvalue);   % take mean

    case 'median'
        output = median(Cvalue); % take median

    case 'sum'
        output = sum(Cvalue);   % take sum

end

end
