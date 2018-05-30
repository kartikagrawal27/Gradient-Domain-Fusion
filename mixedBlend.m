function [ im_blend ] = mixedBlend( im_src, mask, im_bg )
%POISSONBLEND

[src_height, src_width, src_layers] = size(im_src);

pixel_count = src_height * src_width;

im2var = zeros(src_height, src_width);
im2var(1:pixel_count) = 1:pixel_count;

vChannels = {};

num_equations = (4*(pixel_count) - (2*(src_height + src_width)));

for i = 1:src_layers
  
  e = 1;
  b = zeros(num_equations, 1);
  
  triplet_i = [];
  triplet_j = [];
  triplet_v = [];
  
  for y = 1:src_height
    for x = 1:src_width
        
      if (mask(y,x)==0)
          
        triplet_i = [triplet_i e];
        triplet_j = [triplet_j im2var(y,x)];
        triplet_v = [triplet_v 1];
        
        b(e) = im_bg(y, x, i);
        e = e + 1;
      else
          
        if (x - src_width > 0)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x)];
          triplet_v = [triplet_v 1];
          
          if (mask(y, x+1)==1)
            triplet_i = [triplet_i e];
            triplet_j = [triplet_j im2var(y,x+1)];
            triplet_v = [triplet_v -1];
          end
          
          src_gradient = im_src(y,x,i) - im_src(y,x+1,i);
          target_gradient = im_bg(y,x,i) - im_bg(y,x+1,i);
          
          if abs(src_gradient) > abs(target_gradient)
            b(e) = src_gradient;
          else
            b(e) = target_gradient;
          end
          
          if (mask(y,x+1)==0)
            b(e) = b(e) + im_bg(y,x+1,i);
          end
          
          e = e + 1;
        end
        
        if (x - 1  > 0) 
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x)];
          triplet_v = [triplet_v 1];
          
          if (mask(y, x-1)==1)
            triplet_i = [triplet_i e];
            triplet_j = [triplet_j im2var(y,x-1)];
            triplet_v = [triplet_v -1];
          end
          
          b(e) = calculateB(im_src, im_bg, y, x, i);
          
          if (mask(y,x-1)==0)
            b(e) = b(e) + im_bg(y,x-1,i);
          end
          
          e = e + 1;
        end

        if (y - 1 > 0) 
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x)];
          triplet_v = [triplet_v 1];
          
          if (mask(y-1, x)==1)
            triplet_i = [triplet_i e];
            triplet_j = [triplet_j im2var(y-1,x)];
            triplet_v = [triplet_v -1];
          end
          
          b(e) = calculateB(im_src, im_bg, y, x, i);
          
          if (mask(y-1,x)==0)
            b(e) = b(e) + im_bg(y-1,x,i);
          end
          
          e = e + 1;
        end
        
        if (y - src_height > 0)
          triplet_i = [triplet_i e];
          triplet_j = [triplet_j im2var(y,x)];
          triplet_v = [triplet_v 1];
          
          if (mask(y+1, x)==1)
            triplet_i = [triplet_i e];
            triplet_j = [triplet_j im2var(y+1,x)];
            triplet_v = [triplet_v -1];
          end
          
          b(e) = calculateB(im_src, im_bg, y, x, i);
          
          if (mask(y+1,x)==0)
            b(e) = b(e) + im_bg(y+1,x,i);
          end
          
          e = e + 1;
        end
        
        
      end
    end
  end
  
  A = sparse(triplet_i, triplet_j, triplet_v, num_equations, pixel_count);
  vChannels{i} = lscov(A,b);
  vChannels{i}(vChannels{i} < 0) = 0;
end

for i = 1:src_layers
  im_blend(:,:,i) = reshape(vChannels{i}, [src_height src_width]);
end
imshow(im_blend)

