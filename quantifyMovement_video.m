function quantifyMovement_video(vidPath)
    %% quantifies freezing in a video given a path (or cell array of paths) to that video(s)

% unpack cells
if iscell(vidPath)
    for i = 1:length(vidPath)
        quantifyMovement_video(vidPath{i});
    end
end

disp('loading video.....')
% create VideoReader
vid = VideoReader(vidPath)

disp('analyzing images.....')
% get centroids
centroids = zeros(vid.NumberOfFrames, 2);
parfor i = 1:vid.NumberOfFrames
    currFrame = vid.read(i);
    centroids(i, :) = findMouse(currFrame);
end

disp('calculating frame to frame displacement.....')
% calculate displacement between frames
displacement = calculateCentroidDisplacement(centroids);

% Save to file
[~, saveName] = fileparts(vidPath);
disp(['saving to', saveName, '.mat'])
save(saveName, 'displacement', 'centroids')