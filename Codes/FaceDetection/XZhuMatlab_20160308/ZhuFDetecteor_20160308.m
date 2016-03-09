run('face-release1.0-basic/compile.m');

load face-release1.0-basic/face_p146_small.mat

% 5 levels for each octave
model.interval = 5;
% set up the threshold
model.thresh = min(-0.65, model.thresh);

% define the mapping from view-specific mixture id to viewpoint
if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end

ims = dir('../../Data/*.jpg');
for i = 1:length(ims),
    fprintf('testing: %d/%d\n', i, length(ims));
    im = imread(['images/' ims(i).name]);
    clf; imagesc(im); axis image; axis off; drawnow;
    
    tic;
    bs = detect(im, model, model.thresh);
    bs = clipboxes(im, bs);
    bs = nms_face(bs,0.3);
    dettime = toc;
    
    % show highest scoring one
    figure,showboxes(im, bs(1),posemap),title('Highest scoring detection');
    % show all
    figure,showboxes(im, bs,posemap),title('All detections above the threshold');
    
    fprintf('Detection took %.1f seconds\n',dettime);
    disp('press any key to continue');
    pause;
    close all;
end
disp('done!');