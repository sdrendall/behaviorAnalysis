function mouseCentroid = findMouse(im, thresh)
    %% mouseCentroid = findMouse(im)
    %
    % finds a black mouse on a white background within an image
    %
    % returns coordinates for the mouse's centroid

% Downsample im
resizeScale = .1;
im = imresize(im, resizeScale);

% grayscale and normalize
im = mat2gray(rgb2gray(im));

% set threshold, if necessary
if ~exist('thresh', 'var')
    thresh = .1;
end

% segment
im = 1 - im2bw(im, thresh);
im = imclose(im, strel('disk', 3));

% Label
im = logical(im);

% get props
props = regionprops(im, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Centroid', 'Perimeter');

% Filter by Area
areas = [props(:).Area];
candidateLabels = props(areas >= 75 & areas <= 200);


if isempty(candidateLabels)
    winner = props(find(areas == max(areas)), 1, 'first');
elseif size(candidateLabels, 1) > 1
    perimeters = [props(areas >= 75 & areas <= 200).Perimeter];
    areas = areas(areas >= 75 & areas <= 200);

    winner = candidateLabels(find(perimeters./areas == min(perimeters./areas), 1, 'first'));
else
    winner = candidateLabels;
end
    
mouseCentroid = winner(1).Centroid .* 1/resizeScale;