%This Script was used specifically to segment images 
%using only the Otsu Thresholding method for testing 
%and comparison purposes.

function pic = Otsu(img)
im = imread(img);                               
im = rgb2gray(im);                              %Preprocessing stage of reading image, convertint it to 
img = filter2(fspecial('gaussian',5,1),im);     %greyscale and applying a gaussian filter to remove noise
pic = otsu_threshold(img);  
%figure, imshow(pic);
%imwrite(pic, "PR8localThreshold.png");
end

function pic = otsu_threshold(img)
thresh = mean(img(:));                          %The mean of the image pixels is used as the threshold                                                 
img(img >= thresh)= 255;                        %to convert the pixels to either black or white
img(img < thresh) = 0;
pic = img;
end

