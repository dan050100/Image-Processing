function pic = auto_threshold(img)
thresh = mean(img(:));
pic = threshold(img, thresh);

figure; image(pic); imshow(pic);
figure; imhist(pic);
end

