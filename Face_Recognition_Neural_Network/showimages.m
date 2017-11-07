% Desc:   Displays an image array
%
% showimages(IM, xdim, ydim, start, end, fign)
function showimages(IM, xdim, ydim, start, end1, fign)

% Show the image set if fign is valid
if (fign>0)
   figure(fign);
   for i=start:end1,
      subplot(xdim,ydim,i-start+1);
      imagesc(IM{i});
      colormap gray;
   end
end
