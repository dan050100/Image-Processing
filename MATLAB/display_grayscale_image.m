function answ = display_grayscale_image()

pic = imread('airplane.bmp')
figure, image(pic), axis off
changed = rgb2gray(pic)
imshow(changed) 
colormap(gray(256))

end

