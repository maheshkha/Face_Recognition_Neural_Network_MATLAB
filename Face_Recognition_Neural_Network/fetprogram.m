function varargout = fetprogram(varargin)
% FETPROGRAM Application M-file for fetprogram.fig
%    FIG = FETPROGRAM launch fetprogram GUI.
%    FETPROGRAM('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 14-Apr-2007 14:34:58
clc
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

[fn pn] = uigetfile('*.jpg','Select an Image File')


img= imread([pn fn]);


[h1 w b]=size(img);

set(handles.oimg1,'HandleVisibility','on');
imshow(img);

if b==3
    img = rgb2gray(img);
end

entropy = imhist(img);
[h1 w] = size(img);

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
x = img;
if (size(x,3)>1)%if RGB image make gray scale
    try
        x=rgb2gray(x);%image toolbox dependent
    catch
        x=sum(double(x),3)/3;%if no image toolbox do simple sum
    end
end
x=double(x);%make sure the input is double format
[output,count,m,svec]=facefind(x);%full scan 
set(handles.oimg1,'HandleVisibility','off');
figure,
imagesc(x), colormap(gray)%show image
plotbox(output,[],8)%plot the detections as red squares
plotsize(x,m)%plot minmum and maximum face size to detect as green squares in top left corner


