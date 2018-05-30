function [ im_blend ] = poissonBlend(im_src, mask, im_bg)
%POISSONBLEND

[src_height, src_width, src_layers] = size(im_src);

pixel_count = src_height * src_width;

im2var = zeros(src_height, src_width);
im2var(1:pixel_count) = 1:pixel_count;

vChannels = {};

for i = 1:3
  
  ec = 1;
  b = zeros(pixel_count, 1);
  
  triplet_i = [];
  triplet_j = [];
  triplet_v = [];
  
  for y = 1:src_height
    for x = 1:src_width
        
      if (mask(y,x)==0)         
        triplet_i = [triplet_i e];
        triplet_j = [triplet_j im2var(y,x)];
        triplet_v = [triplet_v 1];
        
        b(ec) = im_bg(y, x, i);
        ec = ec + 1;
      else
          
        triplet_i = [triplet_i e];
        triplet_j = [triplet_j im2var(y,x)];
        triplet_v = [triplet_v 4];
  
        if (mask(y, x-1)==1)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x)];
          triplet_v = [triplet_v -1];
        end
        
        if (mask(y, x+1)==1)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x+1)];
          triplet_v = [triplet_v -1];
        end
        
        if (mask(y-1, x)==1)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y-1,x)];
          triplet_v = [triplet_v -1];
        end
        
        if (mask(y+1, x)==1)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y+1,x)];
          triplet_v = [triplet_v -1];
        end
        
        b(ec) = im_src(y,x,i) - im_src(y-1,x,i);
        if (mask(y-1,x)==0)
          b(ec) = b(ec) + im_bg(y-1,x,i);
        end
        
        b(ec) = b(ec) + im_src(y,x,i) - im_src(y+1,x,i);
        if (mask(y+1,x)==0)
          b(ec) = b(ec) + im_bg(y+1,x,i);
        end
        
        b(ec) = b(ec) + im_src(y,x,i) - im_src(y,x+1,i);
        if (mask(y,x+1)==0)
          b(ec) = b(ec) + im_bg(y,x+1,i);
        end
        
        b(ec) = b(ec) + im_src(y,x,i) - im_src(y,x-1,i);
        if (mask(y,x-1)==0)
          b(ec) = b(ec) + im_bg(y,x-1,i);
        end
        
        ec = ec + 1;
      end
    end
  end
  
  A = sparse(triplet_i, triplet_j, triplet_v, pixel_count, pixel_count);
  
  vChannels{i} = lscov(A, b);
  vChannels{i}(vChannels{i} < 0) = 0;
end

for i = 1:3
  im_blend(:,:,i) = reshape(vChannels{i}, [src_height src_width]);
end
imshow(im_blend)

