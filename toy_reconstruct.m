function [ im_out ] = toy_reconstruct( toyim )

[imh, imw, layers] = size(toyim);
im2var = zeros(imh, imw);
im2var(1:imh*imw) = 1:imh*imw; 

A = sparse([], [], [], 2*(imh*imw) + 1, imh*imw);
b = zeros(2*(imh*imw) + 1, 1);

% Objective 1
ec = 1;
for y = 1:imh
    for x = 1:imw-1
        A(ec, im2var(y,x+1)) = 1;
        A(ec, im2var(y,x)) = -1;
        b(ec) = toyim(y,x+1)-toyim(y,x);  
        ec = ec+1;
    end  
end

for y = 1:imh-1
    for x = 1:imw
        A(ec, im2var(y+1,x)) = 1;
        A(ec, im2var(y,x)) = -1;
        b(ec) = toyim(y+1,x)-toyim(y,x);  
        ec = ec+1;
    end  
end

A(ec, im2var(1,1)) = 1;
b(ec) = toyim(1,1);

% Solve
v = lscov(A,b);
im_out = reshape(v, [imh imw]);