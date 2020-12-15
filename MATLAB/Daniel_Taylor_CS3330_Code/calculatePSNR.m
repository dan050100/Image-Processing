%Calculates the psnr value between two images
%Used in the coursework to compare the ground truth and
%the new approaches result
function ret = calculatePSNR(img1,pic2)
pic = imread(img1);

diff = (uint8(pic) - uint8(pic2)).^2;
sumdiff = sum(diff, 'all');
[width,height] = size(pic);
pixels = width*height;
mse = sumdiff/pixels;
ret = 10.*log10(8*8/mse);
end

