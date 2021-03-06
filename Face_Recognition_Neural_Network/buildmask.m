% Desc:   Builds an oval mask for face images
%
% MASK = buildmask()
function MASK = buildmask()

% An 18x27 mask
MASK = ...
     [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0; ...
      0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0; ...
      0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0; ...
      0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0; ...
      0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0; ...
      0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0; ...
      0 0 0 0 0 1 1 1 1 1 1 1 1 0 0 0 0 0; ...
      0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0; ...
      0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0      ];