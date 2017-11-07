function varargout = featureext(varargin)
% FEATUREEXT M-file for featureext.fig
%      FEATUREEXT, by itself, creates a new FEATUREEXT or raises the existing
%      singleton*.
%
%      H = FEATUREEXT returns the handle to a new FEATUREEXT or the handle to
%      the existing singleton*.
%
%      FEATUREEXT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATUREEXT.M with the given input arguments.
%
%      FEATUREEXT('Property','Value',...) creates a new FEATUREEXT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before featureext_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to featureext_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help featureext

% Last Modified by GUIDE v2.5 23-Mar-2008 18:33:07

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @featureext_OpeningFcn, ...
                   'gui_OutputFcn',  @featureext_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before featureext is made visible.
function featureext_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to featureext (see VARARGIN)

% Choose default command line output for featureext
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes featureext wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = featureext_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% % --- Executes on button press in pushbutton1.
% function pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% page1;

in_img6 = imread('test02.jpg'); % read the image
axes(handles.axes2);
subimage(in_img6);
title('Original Image');

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global in_img6;
global x;
[fn,pn] = uigetfile('*.jpg','The file name should have jpg extension.');
in_img6 = imread([pn,fn]); % read the image
[m,n,z]=size(in_img6);
if z==3
    x=rgb2gray(in_img6);
else
    x=in_img6;
end

% in_img6 = imread('peppers.png'); % read the image
axes(handles.axes2);
subimage(in_img6);
title('Original Image');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Main_gui;
close featureext;
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% x = imread('peppers.png'); % read the image
% x=rgb2gray(x);
global x;
J = imnoise(x,'salt & pepper',0.02);
axes(handles.axes1);
subimage(J);
title('Noise Addition Image');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% x = imread('peppers.png'); % read the image
% x=rgb2gray(x);
global x;
J = imnoise(x,'salt & pepper',0.02);

L = medfilt2(J,[3 3]);
axes(handles.axes1);
subimage(L);
title('Filtered Image');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% x = imread('peppers.png'); % read the image
% x=rgb2gray(x);
global x;
% size(x)
reg_I_hist=imhist(x);
axes(handles.axes1);
plot(reg_I_hist);
title('Histogram Image');

