% Desc:   Builds a target result vector for an image array
% 
% RESVECTOR = buildresvector(IM, val)
function RESVECTOR = buildresvector(IM, val)

RESVECTOR = ones(1,size(IM,2)).*val;
