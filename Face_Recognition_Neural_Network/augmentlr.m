% Desc:   Augments an image array with the L<->R reversed images
%
% IM_NEW = augmentlr(IM)
function IM = augmentlr(IM)

num = size(IM,2);
nrows = size(IM{1},1);
ncols = size(IM{1},2);

for i=1:num,
	IM{i+num} = IM{i}(1:1:nrows,ncols:-1:1);
end

