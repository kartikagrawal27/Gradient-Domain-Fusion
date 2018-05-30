% starter script for project 3
DO_TOY = false;
DO_BLEND = true;
DO_MIXED  = false;
DO_COLOR2GRAY = false;

if DO_TOY 
    toyim = im2double(imread('./samples/toy_problem.png')); 
    % im_out should be approximately the same as toyim
    im_out = toy_reconstruct(toyim);
    disp(['Error: ' num2str(sqrt(sum((toyim(:)-im_out(:)).^2)))])
end

if DO_BLEND
    % do a small one first, while debugging
    im_background = (im2double(imread('./samples/sun_skies.jpg')));
    im_object = imresize(im2double(imread('./samples/high_whale.png')), 0.60, 'bilinear');

    % get source region mask from the user
    objmask = getMask(im_object);
    % align im_s and mask_s with im_background
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);

    % blend
    im_blend = poissonBlend(im_s, mask_s, im_background);
end

if DO_MIXED
    % read images
    %...
    im_background = (im2double(imread('./samples/triangles.jpg')));
    im_object = imresize(im2double(imread('./samples/text.jpg')), 0.60, 'bilinear');
    
    objmask = getMask(im_object);
    
    [im_s, mask_s] = alignSource(im_object, objmask, im_background);
    
    % blend
    im_blend = mixedBlend(im_s, mask_s, im_background);
    close all;
    figure(1), hold off, imshow(im_blend);
end

if DO_COLOR2GRAY
    % also feel welcome to try this on some natural images and compare to rgb2gray
    im_rgb = im2double(imread('./samples/colorBlind4.png'));
    im_gr = color2gray(im_rgb);
end
