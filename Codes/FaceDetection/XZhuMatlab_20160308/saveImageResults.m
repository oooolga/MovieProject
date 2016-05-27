%% SET UP DATA
clear; clc;
globalVariables

movies_dir = dir(data_location);
movies_dir = {movies_dir.name};
movies_dir(ismember(movies_dir, {'.','..','.DS_Store'})) = [];

image_dir = dir(image_location);
image_dir = {image_dir.name};


%% Run model on data
for movie_dir = movies_dir
    % get the cast list
    movie_data_file = sprintf('%s%s%s', data_location, char(movie_dir),...
        '/actor_info.txt');
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

                facetracker = strcat(image_location, actor_id, '/facetrack_restricted.mat');
                load(facetracker);
                
                for i = 1:length(ims)
                    
                    try
                        info = strcat(curr_dir,infs(i).name);
                        load(info)
                        %if length(picinfo.names) == 1
                            im = imread([curr_dir ims(i).name]);
                            bs = facetracker{i}.bs;
                            fig = saveBox(im, bs);
                            saveas(fig,strcat(result_location, 'topScoringBB/', actor_id, '_', int2str(i), '.jpg'))
                        %end

                    catch
                        warning(sprintf('Error occured on image %s.',...
                            ims(i).name));
                    end
                end
                
            end
        end
        tline = fgetl(fid);
    end
    fclose(fid);
end