function varargout = mainpage(varargin)
% MAINPAGE M-file for mainpage.fig
%      MAINPAGE, by itself, creates a new MAINPAGE or raises the existing
%      singleton*.
%
%      H = MAINPAGE returns the handle to a new MAINPAGE or the handle to
%      the existing singleton*.
%
%      MAINPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINPAGE.M with the given input arguments.
%
%      MAINPAGE('Property','Value',...) creates a new MAINPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainpage_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainpage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help mainpage

% Last Modified by GUIDE v2.5 18-Mar-2008 22:42:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainpage_OpeningFcn, ...
                   'gui_OutputFcn',  @mainpage_OutputFcn, ...
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


% --- Executes just before mainpage is made visible.
function mainpage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainpage (see VARARGIN)

% Choose default command line output for mainpage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mainpage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mainpage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Main_gui;
close mainpage;
