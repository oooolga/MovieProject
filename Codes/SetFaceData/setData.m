clear; clc
rng(123);

dataLocation
thres = 0.13;
iter = 30;
load(strcat(data_dir, 'anno.mat'))

data_size = size(anno);

data_set = cell(1);

for i = 1:data_size(1)
    imname = anno(i,1);
    imname = imname{1};
    
    info = struct();
    info.name = imname;
    
    bounding_boxes = anno(i,2);
    bounding_boxes = bounding_boxes{1};
    info.bs = cell(1);
    info.false_bs = cell(1);
    
    img = imread([data_dir imname]);
    clf;
    figure(1);
    imagesc(img);
    hold on;
    axis image;
    axis off;
    
    bs_count = 1;
    counter = 1;
    
    for bs = bounding_boxes
        bs = bs{1};
        bs = uint16(bs);
        x1 = bs(1,1);
        x2 = bs(2,1);
        y1 = bs(1,2);
        y2 = bs(2,2);
        info.bs{bs_count} = [x1 y1; x2 y2];
        
        bs_count = bs_count + 1;
        
        line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', 'color', 'b', ...
            'linewidth', 1);
        
        for c = 1:iter
            xb1 = randi(size(img,2)-x2+x1);
            yb1 = randi(size(img,1)-y2+y1);
            xb2 = xb1 + x2 - x1;
            yb2 = yb1 + y2 - y1;
            ratio = 0;
            
            for bs_j = bounding_boxes
                bs_j = bs_j{1};
                bs_j = uint16(bs_j);
                xa1 = bs_j(1,1);
                xa2 = bs_j(2,1);
                ya1 = bs_j(1,2);
                ya2 = bs_j(2,2);
                SI= max(0, min(xa2, xb2) - max(xa1, xb1))...
                    * max(0, min(ya2, yb2) - max(ya1, yb1));
                S = (xa2-xa1)*(ya2-ya1) + (xb2-xb1)*(yb2-yb1) - SI;
                SI = double(SI);
                S = double(S);
                ratio = ratio + SI/S;
            end
            for bs_j = 1:counter-1
                xa1 = info.false_bs{bs_j}(1, 1);
                xa2 = info.false_bs{bs_j}(2, 1);
                ya1 = info.false_bs{bs_j}(1, 2);
                ya2 = info.false_bs{bs_j}(2, 2);
                SI= max(0, min(xa2, xb2) - max(xa1, xb1))...
                    * max(0, min(ya2, yb2) - max(ya1, yb1));
                S = (xa2-xa1)*(ya2-ya1) + (xb2-xb1)*(yb2-yb1) - SI;
                SI = double(SI);
                S = double(S);
                ratio = ratio + SI/S;
            end
            if ratio < thres
                line([xb1 xb1 xb2 xb2 xb1]', [yb1 yb2 yb2 yb1 yb1]', 'color', 'r', ...
            'linewidth', 1);
                info.false_bs{counter} = [xb1 yb1; xb2 yb2];
                counter = counter + 1;
                break
            end
        end
            
    end
    drawnow;
    data_set{i} = info;
end
save(strcat(data_dir, 'train_dataset.mat'), 'data_set')
