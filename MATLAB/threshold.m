function pict = threshold(img, thresh)

pict = imread(img);
pict(pict > thresh) = 0;
pict(pict < thresh) = 255;

end

