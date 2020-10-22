function norm = cn_imhist(img)

img = imread(img);
h = imhist(img);

h=h/sum(h);

norm = cumsum(h);
figure, imshow(norm);

end

