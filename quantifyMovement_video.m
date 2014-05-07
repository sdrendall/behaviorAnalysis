function quantifyMovement_video(vidPath)
    %% quantifies freezing in a video given a path (or cell array of paths) to that video(s)

% unpack cells
if iscell(vidPath)
    for i = 1:length(vidPath)
        quantifyMovement_video(vidPath{i});
    end
end

% create VideoReader
vid = VideoReader(vidPath)

% get centroids
centroids = zeros(vid.NumberOfFrames, 2);
parfor i = 1:vid.NumberOfFrames
    currFrame = vid.read(i);
    centroids(i, :) = findMouse(currFrame);
end

% calculate displacement between frames
displacement = calculateCentroidDisplacement(centroids);