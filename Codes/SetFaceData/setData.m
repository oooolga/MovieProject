clear; clc

dataLocation
rng(seed);
load(strcat(data_dir, 'anno.mat'))

data_size = size(anno);

data_set = cell(0);

% get images
for i = 1:data_size(1)
    imname = anno(i,1);
    imname = imname{1};
    
    info = struct();
    info.name = imname;
    
    bounding_boxes = anno(i,2);
    bounding_boxes = bounding_boxes{1};
    info.bs = cell(0);
    info.false_bs = cell(0);
    
    img = imread([data_dir imname]);
    clf;
    figure(1);
    imagesc(img);
    hold on;
    axis image;
    axis off;
    
    % counter for true faces
    bs_count = 1;
    
    % counter for false faces
    counter = 1;
    
    % get all true faces
    for bs = bounding_boxes
        bs = bs{1};
        bs = uint16(bs);
        x1 = bs(1,1);
        x2 = bs(2,1);
        y1 = bs(1,2);
        y2 = bs(2,2);
        x1 = double(x1); y1 = double(y1);
        x2 = double(x2); y2 = double(y2);
        line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', 'color', 'g', ...
                'linewidth', 1);
            
        for t = 1:num_true_per_face
            lower_thres = sqrt(true_thres);
            range = (1 - lower_thres) * 2;
            h = uint16((rand * range + lower_thres) * (y2-y1));
            w = uint16((rand * range + lower_thres) * (x2-x1));
            while true
                xc1 = (x1+x2)/2 - randi(w);
                xc2 = min(size(img,2), xc1+w);
                yc1 = (y1+y2)/2 - randi(h);
                yc2 = min(size(img,1), yc1+h);
                
                xc1 = double(xc1); yc1 = double(yc1);
                xc2 = double(xc2);yc2 = double(yc2);
                SI= max(0, min(x2, xc2) - max(x1, xc1))...
                    * max(0, min(y2, yc2) - max(y1, yc1));
                
                S = (x2-x1)*(y2-y1) + (xc2-xc1)*(yc2-yc1) - SI;
                ratio = SI/S;
                if ratio > true_thres
                    break;
                end
            end
            xc1 = uint16(xc1); xc2 = uint16(xc2); yc1 = uint16(yc1); yc2 = uint16(yc2);
            info.bs{bs_count} = [xc1 yc1; xc2 yc2];
        
            bs_count = bs_count + 1;

            line([xc1 xc1 xc2 xc2 xc1]', [yc1 yc2 yc2 yc1 yc1]', 'color', 'b', ...
                'linewidth', 1);
            
            for t = 1:true_false_multiplier
            % iterate many times until desired bounding bounding box is found
            for c = 1:iter
                xb1 = randi(size(img,2)-xc2+xc1);
                yb1 = randi(size(img,1)-yc2+yc1);
                xb2 = xb1 + xc2 - xc1;
                yb2 = yb1 + yc2 - yc1;
                xb1 = double(xb1); yb1 = double(yb1);
                xb2 = double(xb2); yb2 = double(yb2);
                ratio = 0;

                for bs_j = bounding_boxes
                    bs_j = bs_j{1};
                    bs_j = uint16(bs_j);
                    xa1 = bs_j(1,1);
                    xa2 = bs_j(2,1);
                    ya1 = bs_j(1,2);
                    ya2 = bs_j(2,2);
                    xa1 = double(xa1); ya1 = double(ya1);
                    xa2 = double(xa2); ya2 = double(ya2);
                    SI= max(0, min(xa2, xb2) - max(xa1, xb1))...
                        * max(0, min(ya2, yb2) - max(ya1, yb1));
                    S = (xa2-xa1)*(ya2-ya1) + (xb2-xb1)*(yb2-yb1) - SI;
                    SI = double(SI);
                    S = double(S);
                    ratio = ratio + SI/S;
                end
                % add the following to avoid overlap between false bs
%                 for bs_j = 1:counter-1
%                     xa1 = info.false_bs{bs_j}(1, 1);
%                     xa2 = info.false_bs{bs_j}(2, 1);
%                     ya1 = info.false_bs{bs_j}(1, 2);
%                     ya2 = info.false_bs{bs_j}(2, 2);
%                     SI= max(0, min(xa2, xb2) - max(xa1, xb1))...
%                         * max(0, min(ya2, yb2) - max(ya1, yb1));
%                     S = (xa2-xa1)*(ya2-ya1) + (xb2-xb1)*(yb2-yb1) - SI;
%                     SI = double(SI);
%                     S = double(S);
%                     ratio = ratio + SI/S;
%                 end
                if ratio < false_thres
                    line([xb1 xb1 xb2 xb2 xb1]', [yb1 yb2 yb2 yb1 yb1]', 'color', 'r', ...
                'linewidth', 1);
                    info.false_bs{counter} = [xb1 yb1; xb2 yb2];
                    counter = counter + 1;
                    break
                end
            end
            end
        end
            
    end
    drawnow;
    data_set{i} = info;
end
save(strcat(data_dir, 'train_dataset.mat'), 'data_set')

