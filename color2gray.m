function [ im_gr ] = color2gray( im_rgb )
%COLOR2GRAY Summary of this function goes here
%   Detailed explanation goes here
[rgb_height, rgb_width, rgb_layers] = size(im_rgb)

im_rgb2gray = rgb2gray(im_rgb);
figure(1), hold off, axis image, imshow(im_rgb2gray);

im_reconstructed = toy_reconstruct(im_rgb);

im_gr = zeros(rgb_height, rgb_width, rgb_layers);

for i=1:3
    im_gr(:, :, i) = im_reconstructed;
end

figure(2), hold off, axis image, imshow(im_gr);


