% load global variables
globalVariables

files = dir(fullfile(data_dir, '*.ppm'));

% setup
face_labels = cell(0);
last_name = '';

for file_i = 1:length(files)
	file_name = files(file_i).name;
	face_name = strsplit(file_name, '_');
	face_name = face_name(1:end-1);
	face_name = strjoin(face_name, '');

	if ~strcmp(face_name, last_name)
		face_labels{end+1} = cell(0);
	end 

	face_labels{end}{end+1} = files(file_i).name;
	last_name = face_name;
end

save(strcat(data_dir, '/../face_sort_by_name_labels.mat'), 'face_labels')
