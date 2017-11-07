% Desc:   Normalizes an image by removing shading plane and adjusting
%         histogram to scale to min/max [0,1]
%
% [OUT] = normalize(IN, MASK)
function [OUT, SHADING] = normalize(IN, MASK)

% Retrieve the indices for the given mask
IND = find(MASK);

% Set up matrices for planar projection calculation
% i.e. Ax = B  so  x = (A'*A)^-1 * A'*B
x = 1:1:size(IN{1},2);
y = 1:1:size(IN{1},1);
[mx,my] = meshgrid(x,y);
mxc = mx(IND);
myc = my(IND);
mcc = ones(size(myc));
A = [mxc, myc, mcc];

% Cycle through each image removing shading plane 
% and adjusting histogram
for i=1:size(IN,2),
   
   % Calculate plane: z = ax + by + c
   B = IN{i}(IND);
   x = inv(A'*A)*A'*B;
   a = x(1); b = x(2); c = x(3);
   
   %This is the color plane itself
   SHADING{i} = mx.*a + my.*b + c;
   
   %This is the image minus the color plane 
   %(the constant will be normalized out in histogram recentering)
   OUT{i} = IN{i} - (mx.*a + my.*b + c);
   
   % Now, recenter the histogram
   maximum = max(max(OUT{i}.*MASK));
   minimum = min(min(OUT{i}.*MASK));   %minimum = min(min(OUT{i}))
   diff = maximum - minimum;
   OUT{i} = ((OUT{i}-minimum)./diff).*MASK;
   
end

