% Desc:   Builds an image vector from an image array, uses the mask
%         to find the appropriate indices
% 
% IMVECTOR = buildimvector(IM, MASK)
function IMVECTOR = buildimvector(IM, MASK)

pics = size(IM,2);
INDICES = find(MASK);

IMVECTOR = zeros(size(find(MASK),1),pics);
for i=1:pics,
  IMVECTOR(:,i) = IM{i}(INDICES);
end
