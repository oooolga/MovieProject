function cropped_im=cropBox(im, bs)
    x1 = min(bs.xy(:,1));
    x2 = max(bs.xy(:,3));
    y1 = min(bs.xy(:,2));
    y2 = max(bs.xy(:,4));
    w = x2 - x1;
    h = y2 - y1;
    % cropped_im(i) = flipdim(flipdim(imcrop(im, [x1, y1, w, h]),1),2)
    cropped_im = imcrop(im, [x1, y1, w, h]);
end