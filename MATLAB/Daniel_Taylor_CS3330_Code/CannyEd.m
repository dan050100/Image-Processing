%This Script was used specifically to segment images 
%using only the canny edge detection for testing purposes.
%The novel approach in the paper conists of a more complexed 
%version with better accuracy.

function pic = Canny(img)
im = imread(img);                               
im = rgb2gray(im);                              %Preprocessing stage of reading image, converting it to 
img = filter2(fspecial('gaussian',5,1),im);     %greyscale and applying a gaussian filter to remove noise

pic = cannyEd(img);
%[Gx,Gy] = imgradientxy(pic);                   %The magnitude and gradient is used in canny edge detection 
%[Gmag,Gdir] = imgradient(Gx,Gy);               %to pick up the lines in order to get the edge map


se = strel('disk',2);                           %morphologcial technique Used for filling letters
pic = imclose(pic, se);                         %as imfill() method had severly poor results when testing with OCR (<25%)
%imfill(pic, 'holes');                          %Uncomment this line and comment out lines 16 and 17 for the comparison 

%Displays the magnitude of the edges
%figure, subplot(2,2,1), imshow(Gmag), title("Magnitude");  %uncomment this line to view the magnitude map

%Displays the direction of the edges
%subplot(2,2,2), imshow(Gdir), title("Direction");          %uncomment this line to view the direction map

pic = uint8(255*(1-pic));                                   %invertion of image colour
%Displays the final canny edged map
%subplot(2,2,3.5), imshow(pic), title("Canny Edge");        %uncomment this line to view the canny edge map
end

function pic = cannyEd(img)
pic = edge(img,'canny');      %Used the built in method only for testing purposes of canny edge detection alone
end
