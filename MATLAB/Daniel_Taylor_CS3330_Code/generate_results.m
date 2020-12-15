%This is the script which is to be run to display
%All the variations of techniques used on the images 
%As well as displaying the psnr and ssim values

figure, subplot(3,2,1);
pic=imread("HW3.png");
imshow(pic), title("Original HW3");         %Displays the original HW3 image

subplot(3,2,2);
pic = OtsuThresholding("HW3.png");
imshow(pic), title("HW3 Otsu Threshold");   %Displays Otsus thresholded algorithm used on the HW3 image

subplot(3,2,3);
pic = CannyEd("HW3.png");
imshow(pic), title("HW3 Canny Edge");       %Displays the Canny edge detection algorithm used on the HW3 image

subplot(3,2,4);
pic = SobelEd("HW3.png");
imshow(pic), title("HW3 Sobel Edge");       %Displays the sobel edge detection algorithm used on the HW3 image

subplot(3,2,5);
finalhw3 = coursework_script("HW3.png");    
imshow(finalhw3), title("HW3 New Approach");
imwrite(finalhw3, "HW3binarized.tiff");     %The new approach applied to the image HW3 and written as a new image

subplot(3,2,6);
[val,map] = ssimResult("HW3_GT.tiff", "HW3binarized.tiff"); %Calculates the SSIM value of the image HW3 and its ground truth
psnr = calculatePSNR("HW3_GT.tiff", finalhw3);  %Calculates the PSNR value of the image HW3 and its ground truth
imshow(map,[]), title(['PSNR Value: ', num2str(psnr), newline 'SSIM value: ',num2str(val)]); %Displays the PSNR and SSIM values and the SSIM map



figure, subplot(3,2,1);
pic=imread("PR8.png");
imshow(pic), title("Original PR8");         %Displays the original PR8 image

subplot(3,2,2);
pic = OtsuThresholding("PR8.png");
imshow(pic), title("PR8 Otsu Threshold");   %Displays Otsus thresholded algorithm used on the PR8 image

subplot(3,2,3);
pic = CannyEd("PR8.png");
imshow(pic), title("PR8 Canny Edge");       %Displays the Canny edge detection algorithm used on the PR8 image

subplot(3,2,4);
pic = SobelEd("PR8.png");
imshow(pic), title("PR8 Sobel Edge");       %Displays the sobel edge detection algorithm used on the PR8 image

subplot(3,2,5);
finalpr8 = coursework_script("PR8.png");
imshow(finalpr8), title("PR8 New Approach");
imwrite(finalpr8, "PR8binarized.tiff");     %The new approach applied to the image PR8 and written as a new image

subplot(3,2,6);
[val,map] = ssimResult("PR8_GT.tiff", "PR8binarized.tiff"); %Calculates the SSIM value of the image PR8 and its ground truth
psnr = calculatePSNR("PR8_GT.tiff", finalpr8);  %Calculates the PSNR value of the image PR8 and its ground truth
imshow(map,[]), title(['PSNR Value: ', num2str(psnr), newline 'SSIM value: ',num2str(val)]); %Displays the PSNR and SSIM values and the SSIM map
