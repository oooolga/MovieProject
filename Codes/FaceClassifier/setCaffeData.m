clear; clc
globalVariables

load(strcat(data_dir, 'data.mat'))
load(strcat(data_dir, 'label.mat'))

train_fileID = fopen(strcat(train_dir, 'label.txt'), 'wt');
test_fileID = fopen(strcat(test_dir, 'label.txt'), 'wt');
num_train = uint16(length(data) * train_test_ratio);

for i = 1:length(data)
    if i <= num_train
        dir = train_dir;
        fileID = train_fileID;
    else
        dir = test_dir;
        fileID = test_fileID;
    end
    fileName = strcat(dir, int2str(i), '.jpg');
    img = imresize(data{i}, [250 250]);
    imwrite(img, fileName);
    fprintf(fileID, sprintf('%s %d\n', fileName, label(i)));%fileName, '' ', int2str(label(i)), '\n'));
end

fclose(train_fileID);
fclose(test_fileID);