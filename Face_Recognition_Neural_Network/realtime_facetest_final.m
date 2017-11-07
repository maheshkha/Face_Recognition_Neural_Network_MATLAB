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

%Do extra check to check that VFM works
try
    x=vfm('grab');
catch
    disp('VFM not found (vfm.dll) or webcam not connected.')    
    disp('If you forgot to connect your webcam: restart Matlab and run again.')
    break;
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