function varargout = frnnprogram(varargin)
% FRNNPROGRAM Application M-file for frnnprogram.fig
%    FIG = FRNNPROGRAM launch frnnprogram GUI.
%    FRNNPROGRAM('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 15-Apr-2006 20:17:23

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end

%| ABOUT CALLBACKS:

% --------------------------------------------------------------------
function varargout = Untitled_1_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = fOpen_Callback(h, eventdata, handles, varargin)
global img;
global oimg;
global h1;
global w;
global map;

[fn pn] = uigetfile('*.jpg','Select an Image File')

[img,map]= imread([pn fn]);

[h1 w b]=size(img);

set(handles.oImg,'HandleVisibility','on');
%colormap(map);
imshow(img);

% if b==3
%     img = rgb2gray(img);
% end

% --------------------------------------------------------------------
function varargout = saveR_Callback(h, eventdata, handles, varargin)

[fn pn]= uiputfile('*.jpg')
global iimg;

imwrite(iimg,[pn fn],'jpg');

% --------------------------------------------------------------------
function varargout = saveF_Callback(h, eventdata, handles, varargin)

[fn pn]= uiputfile('*.jpg')
global fimg;
maxv = max(max(log(abs(fimg)+1)));
minv = min(min(log( abs(fimg) + 1)));

fimg = (log(abs(fimg)+1)-minv)/(maxv-minv);

imwrite(fimg,[pn fn],'jpg');



% --------------------------------------------------------------------
function varargout = saveE_Callback(h, eventdata, handles, varargin)

[fn pn]= uiputfile('*.jpg')
global erimg;
erimg = uint8(round(255*erimg));

imwrite(erimg,[pn fn],'jpg');

% --------------------------------------------------------------------
function varargout = proc_Callback(h, eventdata, handles, varargin)

global img;
global oimg;
global w;
global h1;

set(handles.oImg,'HandleVisibility','on');
%Do extra check to check that VFM works
title('Real time Face Dectector')
%figure,
% Load the image oval mask
MASK = buildmask;
NI   = size(find(MASK),1);
load NET;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              Image Loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the face images, normalize, and set training vectors
%IM = double(imread('./scaled/s07-c.png'));
%IM = double(imread('./scaled/HeadsBW.JPG'));
%IM  = double(imread('./scaled/Subject2.jpg'));
% IM = imread('./scaled/test02-c.jpg');
IM = img;
IM1 = IM;
IM=im2bw(IM);
[RECT, IMR,TEST] = facescan(NET, IM, MASK, 0.4, 1, 1, 1.2, 2);

% START can be 1, but use to ignore smaller rectangles (level to start at)
% THR is good around .4 - .6
% STEP is good at 2
% LEVELS is good at 6 (number of pyramid levels with 1 being initial image)
% SCALEFACT is good at 1.2


%IM = imread('./scaled/s07-c.png');
   if (TEST > 0.4)
	   fprintf(1, '\n TEST):  %5.3f   ', TEST);
       imshow(IM1);
       title('FACE DETECTED');
   else
       fprintf(1, '\n TEST):  %5.3f   ', TEST);
       imshow(IM1);
       title('FACE NOT DETECTED ');
   end
