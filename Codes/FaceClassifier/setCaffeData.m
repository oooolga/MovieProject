clear; clc
globalVariables

load(strcat(data_dir, 'data.mat'))
load(strcat(data_dir, 'label.mat'))

train_fileID = fopen(strcat(train_dir, '../train.txt'), 'wt');
test_fileID = fopen(strcat(test_dir, '../val.txt'), 'wt');
if restrict_length
	data = data(1:num_data);
end
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
    if resize
        img = imresize(data{i}, [resize_size resize_size]);
    else
        img = data{i};
    end

    img = uint8(img);
    imwrite(img, fileName);

    tmpFileName = strcat(int2str(i), '.jpg');
    fprintf(fileID, sprintf('%s %d\n', tmpFileName, label(i)));
end

fclose(train_fileID);
fclose(test_fileID);