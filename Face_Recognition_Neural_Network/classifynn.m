% Desc:   From a given image, returns the classification value
%
% TEST = classifynn(NET, IM, MASK)
function TEST = classifynn(NET, IM, MASK, srow, scol)

% First normalize the face

V{1} = IM(srow:srow+26,scol:scol+17);
[V, PLANE] = normalize(V, MASK); 

% Now test it
TEST = simnn(NET, V{1}(find(MASK)));