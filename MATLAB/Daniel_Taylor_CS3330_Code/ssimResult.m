%Calculates the ssim value between two images. Takes into
%consideration the structural similarity of the two.
%Used in the coursework to compare the ground truth and
%the new approaches result
function [perc, ssimMap]= ssimResult(GrImg, img)
ground = uint8(imread(GrImg));
tester = uint8(imread(img));

[ssimVal,ssimMap] = ssim(ground,tester);
perc=num2str(ssimVal);
end