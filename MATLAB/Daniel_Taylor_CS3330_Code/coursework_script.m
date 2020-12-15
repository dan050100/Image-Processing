%This script contains the new approach to binarizing
%documents using canny edge detection and then applying 
%morphology using different structering elements in order
%to fill in the letters before finaly smoothing the image
%to remove any noise

function edge_img = coursework_script(img)
%Used to check substrings in order to determine whether the 
%image is a printed document or handwritten document - useful for
%the character width calculation 
fileType=img;                                   
typ ="PR";
typ2="H0";
typ3="H10";


%read the image in and convert it to grayscale
img = imread(img);
img = rgb2gray(img);


%Preprocessing stage to smoothen the image to reduce noise - using a gaussian
%filter
img = filter2(fspecial('gaussian',5,1),img);


% %get the local threshold values of the specific image, allowing all images to have different
% %thresholds rather than an absolute value for all images.
high_thresh = hi_threshold(uint8(img));
low_thresh = lo_threshold(uint8(img));
 
 
%Canny edge detection used to segment the foreground from the background
[grad_mag,grad_angle] = calculate_gradient(img);
grad_dir = discretize_gradient(grad_angle);
maxima_img = non_maxima_suppress(grad_mag,grad_dir);
strong_edges = threshold_matrix(maxima_img,high_thresh); 
weak_edges = threshold_matrix(maxima_img,low_thresh); 
edge_img = hysteresis(strong_edges,weak_edges);
 

%Checks what sort of document is being processed to determine 
%which calculation is to be carried out 
if contains(fileType,typ) || contains(fileType,typ2) || contains(fileType,typ3)
    widthVal = calLength(edge_img); %calculates the width of the printed text
else
    widthVal = calLength(edge_img) + 1; %calculates the width of the handwritten text
end


%Morphology techniques applied to the edge map in order to remove small
%areas of noise that may still occur whilst also filling in the letters.
se = strel('square',widthVal);
edge_img = imdilate(edge_img,se);    %imdilate used to fill in the majority of the letters
edge_img = filter2(fspecial('gaussian',3,1),edge_img); %Retains areas within looped letters such as g or d
se = strel('disk',2);
edge_img = imclose(edge_img, se);      
 
 
%filter is applied to the image to remove pixels that may still not be filled
%in, which could be seen as similar to salt and pepper noise
edge_img = filter2(fspecial('gaussian',3,1),edge_img);  
 
 
%inverting the image before sharpening it using a laplecian filter
edge_img = uint8(255*(1-edge_img));
edge_img = display_laplacian_result(edge_img);


% figure,imshow(edge_img),colormap(gray(256)),axis off
% imwrite(edge_img, "PR8binarized.png");
end


function [grad_mag,grad_dir] = calculate_gradient(img)
%CALCULATE_GRADIENT calculates the gradient magnitude and gradient
%direction of an image.
     sobel_v = fspecial('sobel');
    sobel_h = rot90(sobel_v,3);
    grad_v = filter2(sobel_v,img);
    grad_h = filter2(sobel_h,img);
    grad_mag = sqrt(grad_v.^2 + grad_h.^2);
    grad_dir = atan(grad_v./grad_h);
end

function grad_dir = discretize_gradient(grad_angle)
%DISCRETIZE_GRADIENT takes in a matrix containg a set of angles between
%-pi/2 and +pi/2 radians and discretizes them to an integer indication the
%nearest direction in an image where the values correspond to:
%   1 - Horizontal
%   2 - Diagonally upwards-and-right
%   3 - Vertical
%   4 - Diagonally upwards-and-left
    grad_angle = 8*grad_angle/pi;
    grad_dir = zeros(size(grad_angle));
    grad_dir((grad_angle>=-1) & (grad_angle<1)) = 1;
    grad_dir((grad_angle>=1) & (grad_angle<3)) = 2;
    grad_dir((grad_angle<-3) | (grad_angle>=3)) = 3;
    grad_dir((grad_angle>=-3) & (grad_angle<-1)) = 4;
end

function maxima_img = non_maxima_suppress(grad_mag,grad_dir)
%Given a matrix of gradient magnitudes and a matrix of gradient directions
%(as discretized by DISCRETIZE_GRADIENT), NON_MAXIMA_SUPPRESS returns a
%matrix where all values which are non-maximal in their local gradient
%directions are set to 0. Those which are maximal remain unchanged.
    grad_mag_e = expand_matrix(grad_mag);
    dir_1_max = max(grad_mag_e(2:end-1,1:end-2),grad_mag_e(2:end-1,3:end));
    dir_2_max = max(grad_mag_e(1:end-2,3:end),grad_mag_e(3:end,1:end-2));
    dir_3_max = max(grad_mag_e(1:end-2,2:end-1),grad_mag_e(3:end,2:end-1));
    dir_4_max = max(grad_mag_e(1:end-2,1:end-2),grad_mag_e(3:end,3:end));
    
    correct_dir_max = zeros(size(grad_mag));
    correct_dir_max(grad_dir == 1) = dir_1_max(grad_dir ==1);
    correct_dir_max(grad_dir == 2) = dir_2_max(grad_dir ==2);
    correct_dir_max(grad_dir == 3) = dir_3_max(grad_dir ==3);
    correct_dir_max(grad_dir == 4) = dir_4_max(grad_dir ==4);
    
    maxima_img = grad_mag;
    maxima_img(grad_mag<=correct_dir_max) = 0;
    
    function new_mat = expand_matrix(old_mat)
    %EXPAND_MATRIX adds a border of zeros to the original matrix passed to
    %it. It should only be used as a helper function for
    %NON_MAXIMA_SUPPRESS
        new_mat = zeros(size(old_mat,1)+2,size(old_mat,2)+2);
        new_mat(2:end-1,2:end-1) = old_mat;
    end
end

function t_img = threshold_matrix(mat,thresh)
%THRESHOLD_IMAGE takes in a matrix and a threshold. It returns a new matrix
%which is 0 where the original matrix was less than the threshold and 1
%elsewhere.
    t_img = zeros(size(mat));
    t_img(abs(mat)>=thresh) = 1;
end

function joined_img = hysteresis(strong_edge,weak_edge)
%HYSTERESIS persorms image hysteresis, joining pixels in strong_edge using
%connecting pixels in weak_edge.
    [r,c] = find(strong_edge);
    joined_img = bwselect(weak_edge,c,r,8);
end

%Calculates a local threshold using the mean of the image's pixels
function hithresh = hi_threshold(img)
hithresh = mean(img(:));          %Changing 85 will have an impact on which lines are picked up during the  
hithresh = hithresh-85;           %canny edge detection stage which follows. This value works for both images
end

function lothresh = lo_threshold(img)
lothresh = mean(img(:));          %Changing 8 will have an impact on which lines are picked up during the
lothresh = lothresh/8;            %canny edge detection stage which follows. This value works for both images
end


%Uses a laplacian filter to sharpen the image 
function sharpened = display_laplacian_result(img)
    laplac = [0,1,0;1,-4,1;0,1,0];               %Laplacian filter matrix
    lap = uint8(filter2(laplac, img, 'same'));   %Ensures the matrix size does not change when filters applied 
   
    sharpened = 3*imsubtract(img, lap);          %Change value of 3 to change level of sharpness (accuracy may worsen)
    sharpened = imadd(img, sharpened);           %Adds the sharpened map to the image for sharpening to take place
end


%Calculates the width of the characters 
function leng = calLength(img)
pic = logical(img);
[row,col] = size(img);
widths = [];
length = 0;

for rows=2:row-2
    for cols=2:col-2
        if  pic(rows,cols) == 1 && pic(rows,cols+1) == 0 && length==0   %If the pixel is the first edge
            length = length + 1;
        elseif pic(rows,cols) == 0 && length > 0                        %If the pixel is in between both edges
            length = length + 1;
        elseif pic(rows,cols) == 1 && pic(rows,cols+1) == 0 && length > 0   %If the pixel is the second/last edge
            length = length + 1;
            length = length - 2;
            widths(end+1)=length;
            length = 0;
        end
    end
end

%Uses the mode over the mean as anomally results will not impact the mode
%and are common with handwriting where letters may link
leng = mode(widths);                 
end

