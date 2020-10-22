function im = finalimg(img)

im = slice(img, [180, 200], 0);

figure(); 
image(im);
colormap(gray(256));

end

