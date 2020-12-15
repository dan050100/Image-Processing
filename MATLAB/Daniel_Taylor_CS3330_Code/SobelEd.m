%This Script was used specifically to segment images 
%using only the sobel edge detection for testing and comparison purposes.

function pic = Sobel(img)
im = imread(img);                               
im = rgb2gray(im);                              %Preprocessing stage of reading image, converting it to 
img = filter2(fspecial('gaussian',5,1),im);     %greyscale and applying a gaussian filter to remove noise

pic = sobelEd(img);                                         %Applies the sobel edge detection
pic=morph(pic);                                             %fills the letters

pic = uint8(255*(1-pic));                                   %Invert black and white

%Displays the final sobel edged map
%figure,imshow(pic), title("Sobel Edge");
end

%Used the built in method only for testing purposes of sobel edge detection alone
function pic = sobelEd(img)
[~,thresh] = edge(img,'sobel');          
fudFac = 0.5;
pic = edge(img,'sobel',thresh * fudFac);      
end

function pic = morph(img)
se = strel('disk',2);           %morphologcial technique Used for filling letters
pic = imclose(img, se);         %as imfill() method had severly poor results when testing with OCR (<25%)
% imfill(img, 'holes');         %Uncomment this line and comment out lines 26 and 27 for the comparison
end