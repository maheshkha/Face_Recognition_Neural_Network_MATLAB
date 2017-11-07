% Desc:   Main testing implementation of the face detector
%
% For now, just a script... make it so that a picture filename can be passed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                 Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all

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
IM = imread('./scaled/test05-c.jpg');
% IM = imread('./scaled/test03-c.jpg');
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
    
% Load the non-face images, normalize, and set training vectors
% NFACES = loadimages('./scaled/n', ...
% 	{'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13' '14' ...
% 	 '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26' '27' '28' ... 
%          '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' '40'}, ...
%        	{'x'}, 'PNG', 1);

% 
% % Test images
% AmyBW  = double(imread('./scaled/AmyBW.JPG'));
% GradBW = double(imread('./scaled/GradBW.JPG'));
% HeadsBW = double(imread('./scaled/HeadsBW.JPG'));
% 
 
