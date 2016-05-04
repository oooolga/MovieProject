function figure1=showBox(im, bs)
    close all
    figure1 = figure(1);
    
    axes1 = axes('Parent',figure1);
    hold(axes1,'all');
    imagesc(im);
    %hold on;
    axis image;
    axis off;
    
    for i = 1:length(bs)
        x1 = min(bs(i).xy(:,1));
        x2 = max(bs(i).xy(:,3));
        y1 = min(bs(i).xy(:,2));
        y2 = max(bs(i).xy(:,4));
        line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', 'color', 'b', ...
            'linewidth', 1);
    end
    %drawnow;
end