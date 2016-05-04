%% SET UP DATA
clear; clc;
data_location = '../../../Data/movies/';
image_location = '../../../Data/imdb/';
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
                mkdir(strcat('../../../Results/XZhu/', actor_id));
                ims = dir(strcat(curr_dir, '*.jpg'));           

                facetracker = strcat(image_location, actor_id, '/facetrack.mat');
                load(facetracker);
                
                for i = 1:3%length(ims)
                    
                    try
                        if i <length(ims)
                            im = imread([curr_dir ims(i).name]);
                            bs = facetracker{i}.bs;
                            fig = saveBox(im, bs);
                            saveas(fig,strcat('../../../Results/XZhu/', actor_id,'/', int2str(i), '.jpg'))
                        end

                        %fprintf('Detection took %.1f seconds\n',dettime);
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