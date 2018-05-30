function [ triplet_i, triplet_j, triplet_v ] = updateTriplets(triplet_i, triplet_j, triplet_v, ec, im2var, y, x);
%UPDATETRIPLETS Summary of this function goes here
%   Detailed explanation goes here


triplet_i = [triplet_i ec];
        triplet_j = [triplet_j im2var(y,x)];
        triplet_v = [triplet_v 1];

end

