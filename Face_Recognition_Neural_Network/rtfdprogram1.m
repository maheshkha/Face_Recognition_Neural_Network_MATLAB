function varargout = rtfdprogram1(varargin)
% RTFDPROGRAM1 Application M-file for rtfdprogram1.fig
%    FIG = RTFDPROGRAM1 launch rtfdprogram1 GUI.
%    RTFDPROGRAM1('callback_name', ...) invoke the named callback.

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
% Load the image oval mask
MASK = buildmask;
NI   = size(find(MASK),1);
load NET;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              Image Loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Do extra check to check that VFM works
try
    x=vfm('grab');
catch
    disp('VFM not found (vfm.dll) or webcam not connected.')    
    disp('If you forgot to connect your webcam: restart Matlab and run again.')
    return;
end

disp('Press CTRL-C to break.')
while 1
    tic
    x=vfm('grab');
    try
        x=rgb2gray(x);%image toolbox dependent
    catch
        x=sum(double(x),3)/3;%if no image toolbox do simple sum
    end
    x=double(x);

%     hold off
%     clf
%     cla
    imagesc(x);colormap(gray)
    ylabel('Press CTRL-C to break.')
    [output,count,m]=facefind(x,48,[],2,2);%speed up detection, jump 2 pixels and set minimum face to 48 pixels
    
    plotsize(x,m)
    plotbox(output)
    drawnow;
    N=size(output,2);

if (N>0)
    x1=output(1,1);
    x2=output(3,1);
    y1=output(2,1);
    y2=output(4,1);
    img=imcrop(x,[x1 x2 y1 y2]);
    % Load the face images, normalize, and set training vectors
     % IM = imread('./scaled/test05-c.jpg');
    IM = imresize(img,[27 18]);
    % IM = imread('./scaled/test03-c.jpg');
    IM1 = IM;
    IM=im2bw(IM);
    [RECT, IMR,TEST] = facescan(NET, IM, MASK, 0.4, 1, 1, 1.2, 2);

    % START can be 1, but use to ignore smaller rectangles (level to start at)
    % THR is good around .4 - .6
    % STEP is good at 2
    % LEVELS is good at 6 (number of pyramid levels with 1 being initial image)
    % SCALEFACT is good at 1.2
      if (TEST > 0.4)
           fprintf(1, '\n TEST):  %5.3f   ', TEST);
    %        imshow(IM1);
    %        title('FACE DETECTED');
            disp('FACE DETECTED')
       else
           fprintf(1, '\n TEST):  %5.3f   ', TEST);
    %        imshow(IM1);
    %        title('FACE NOT DETECTED ');
           disp('FACE NOT DETECTED ')
      end
    
end
toc
end
