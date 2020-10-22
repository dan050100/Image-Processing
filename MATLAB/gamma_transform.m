function img = gamma_transform(img,gamma)
img = imread(img);

img = double(img);
img = 255*(img/255).^gamma;
img = uint8(img);
end

