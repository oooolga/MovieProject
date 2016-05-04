clear; clc

globalVariables
rng(seed);

load(strcat(data_dir, 'train_dataset.mat'))

data = cell(0);
label = [];
counter = 0;
for i = 1:length(data_set)
    d = data_set{i};
    img = imread([data_dir d.name]);
    
    f_bs_len = length(d.false_bs);
    for j = 1:length(d.bs)
        counter = counter + 1;
        
        bs =d.bs{j};
        x1 = bs(1,1);
        x2 = bs(2,1);
        y1 = bs(1,2);
        y2 = bs(2,2);
        
        %figure(1);
        %imshow(img(y1:y2,x1:x2));
        data{counter} = img(y1:y2,x1:x2);
        label = [label 1];
        if j <= f_bs_len
            counter = counter + 1;
            bs =d.false_bs{j};
            x1 = bs(1,1);
            x2 = bs(2,1);
            y1 = bs(1,2);
            y2 = bs(2,2);
            data{counter} = img(y1:y2,x1:x2);
            label = [label 0];
        end
    end
end

ind = randperm(length(label));
data = data(ind);
label = label(ind);

% num_train = uint16(length(data) * train_test_ratio);
% num_test = length(data) - num_train;
% 
% train_data = data(1:num_train);
% test_data = data(num_train+1:end);
% train_label = label(1:num_train);
% test_label = label(num_train+1:end);

save(strcat(data_dir, 'data.mat'), 'data')
save(strcat(data_dir, 'label.mat'), 'label')
        