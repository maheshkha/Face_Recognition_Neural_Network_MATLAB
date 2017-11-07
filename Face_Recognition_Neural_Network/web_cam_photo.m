clc
close all
clear all

% Load the image oval mask
% MASK = buildmask;
% NI   = size(find(MASK),1);
% load NET;
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
    w=abs(y1-x1);
    h=abs(y2-x2);
    img=imcrop(x,[x1 x2 w h]);
    % Load the face images, normalize, and set training vectors
     % IM = imread('./scaled/test05-c.jpg');
    IM = imresize(img,[27 18]);
    imwrite(uint8(IM),'./RHome/orl-s1-4-x.jpg');
end
end