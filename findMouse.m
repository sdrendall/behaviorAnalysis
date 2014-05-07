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
im = 1 - im2bw(im, bwThresh);
im = imclose(im, strel('disk', 3));

% Label
im = logical(im)

% get props
props = regionprops(im, 'Area', 'MajorAxisLength', 'MinorAxisLength', 'Centroid');

% Filter by Area
areas = [props(:).area];
candidateLabels = props(areas >= 75 & areas <= 200);

if isempty(candidateLabels)
    winner = find(areas == max(areas));
elseif length(candidateLabels) > 1
    previousDiff = [];
    for iLab = 1:length(candidateLabels)
        diff = props(candidateLabels(iLab)).MajorAxisLength - props(candidateLabels(iLab)).MinorAxisLength;
        if iLab == 1 || diff < previousDiff
            winner = candidateLabels(iLab);
        elseif diff == previousDiff
            % FLAG
            'diffs are equal'
        end
        previousDiff = diff;
    end
elseif length(candidateLabels) == 1
    winner = candidateLabels;
end

mouseCentroid = props(winner(1).Centroid .* 1/resizeScale);