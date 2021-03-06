function [mouseCentroid, mask] = findMouse(im, thresh)
    %% mouseCentroid = findMouse(im)
    %
    % finds a black mouse on a white background within an image
    %
    % returns coordinates for the mouse's centroid

% grayscale and normalize
im = mat2gray(im);

% Downsample im
resizeScale = .4;
im = imresize(im, resizeScale);

% set threshold, if necessary
if ~exist('thresh', 'var')
    thresh = .1;
end

% segment
im = imfilter(im, fspecial('gaussian', 24, 8));
im = imerode(im, strel('disk', 8));
im = 1 - im2bw(im, thresh);
im = imclose(im, strel('disk', 12));

% Label
im = logical(im);

% get props
props = regionprops(im, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Centroid', 'Perimeter');

% Filter by Area
areas = [props(:).Area];
candidateLabels = props(areas >= 8 * 75 & areas <= 16 * 200);

if isempty(candidateLabels)
    try
        maxAreaInd = find(areas == max(areas), 1, 'first');
        winner = props(maxAreaInd);
    catch err
        disp(['maxAreaInd: ', maxAreaInd])
        disp(getReport(err))
        mouseCentroid = [0, 0];
        mask = im;
        return
    end

elseif size(candidateLabels, 1) > 1
    perimeters = [props(areas >= 8 * 75 & areas <= 16 * 200).Perimeter];
    areas = areas(areas >= 8 * 75 & areas <= 16 * 200);
    
    minPerimeterRatioInd = find(perimeters./areas == min(perimeters./areas), 1, 'first');
    winner = candidateLabels(minPerimeterRatioInd);

else
    winner = candidateLabels;
end

mouseCentroid = winner(1).Centroid .* 1/resizeScale;
mask = im;
