%% SET UP DATA
clear; clc;
globalVariables

%% Set up data
movies_dir = dir(data_location);
movies_dir = {movies_dir.name};
movies_dir(ismember(movies_dir, {'.','..','.DS_Store'})) = [];

image_dir = dir(image_location);
image_dir = {image_dir.name};

%% SET UP FACE-TRACKER
run('face-release1.0-basic/compile.m');
addpath('./face-release1.0-basic');
load face-release1.0-basic/face_p146_small.mat

% Set up model 5 levels for each octave
model.interval = 5;
% Set up the threshold
model.thresh = min(threshold, model.thresh);

% define the mapping from view-specific mixture id to viewpoint
if length(model.components)==13 
    posemap = 90:-15:-90;
elseif length(model.components)==18
    posemap = [90:-15:15 0 0 0 0 0 0 -15:-15:-90];
else
    error('Can not recognize this model');
end


%% Run model on data
for movie_dir = movies_dir
    % get the cast list
    movie_data_file = sprintf('%s%s%s', data_location, char(movie_dir),...
        '/actor_info.txt');
    display(movie_data_file)
    fid = fopen(movie_data_file);
    tline = fgetl(fid);
    
    while ischar(tline)
        % get the actors' ids
        if length(tline) > 8 && strcmp(tline(1:8), 'actor_id')
            actor_id = tline(11:end);
            
            display(strcat('Facetracking: ', actor_id));
            % check if the actor is in the imdb data
            if ismember(actor_id, image_dir)
                
                % get all images
                curr_dir = strcat(image_location, actor_id, '/pics/');
                ims = dir(strcat(curr_dir, '*.jpg'));
                infs = dir(strcat(curr_dir, '*.mat'));           

                facetracker = cell(1, length(ims));
                
                for i = 1:length(ims)
                    
                    image_struct = struct();
                    image_struct.name = ims(i).name;
                    
                    fprintf('testing: %d/%d\n', i, length(ims));
                    
                    try
                        info = strcat(curr_dir,infs(i).name);
                        load(info)

                        restricted_length = length(picinfo.names);
                        im = imread([curr_dir ims(i).name]);

                        bs = detect(im, model, model.thresh);
                        bs = clipboxes(im, bs);
                        bs = nms_face(bs,0.3);

                        if restrict_top_score & restricted_length < length(bs)
                            bs = bs(1:restricted_length);
                        end

                        image_struct.bs = bs;
                        %keyboard;
                        image_struct.bounding_box = [];
                        for j = 1:length(bs)
                        x1 = min(bs(j).xy(:,1));
                        x2 = max(bs(j).xy(:,3));
                        y1 = min(bs(j).xy(:,2));
                        y2 = max(bs(j).xy(:,4));
                        tmp = [x1 x2 y1 y2];
                        image_struct.bounding_box = [
                        image_struct.bounding_box; tmp];
                        end

                    catch
                        warning(sprintf('Error occured on image %s.',...
                            ims(i).name));
                    end
                    facetracker{i} = image_struct;
                end
                
                file_naming = '/facetrack.mat';
                if restrict_top_score
                    file_naming = '/facetrack_restricted.mat';
                end

                save(strcat(image_location, actor_id, file_naming),...
                    'facetracker');
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end