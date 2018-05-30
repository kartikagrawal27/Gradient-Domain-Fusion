function [ im_blend ] = formFromChannels(vChannels, src_height, src_width, src_layers)
%FORMFROMCHANNELS Summary of this function goes here
%   Detailed explanation goes here

for i = 1:src_layers
  im_blend(:,:,i) = reshape(vChannels{i}, [src_height src_width]);
end

end

