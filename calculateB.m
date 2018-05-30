function [ val ] = calculateB(im_src, im_bg, y, x, i)
%CALCULATEB Summary of this function goes here
%   Detailed explanation goes here

src_gradient = im_src(y,x,i) - im_src(y-1,x,i);
target_gradient = im_bg(y,x,i) - im_bg(y-1,x,i);

if abs(src_gradient) > abs(target_gradient)
    val = src_gradient;
else
    val = target_gradient;
end


