% Desc:   Augments an image array with the upside down reversed images
%
% IM_NEW = augment(IM)
function IM = augmentud(IM)

num = size(IM,2);
nrows = size(IM{1},1);
ncols = size(IM{1},2);

for i=1:num,
	IM{i+num} = IM{i}(nrows:-1:1,1:1:ncols);
end
