% Desc:   Main testing implementation of the face detector
%
% For now, just a script... make it so that a picture filename can be passed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                 Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all

% Load the image oval MASK1
MASK1 = ones(27,18);
NI   = size(find(MASK1),1);
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
    imwrite(uint8(IM),'./RHome/orl-s1-6-x.jpg');
    IM1 = IM;
  % Neural net constants
FACE_T =  0.9;
FACE_F = -0.9;

     FACES = loadimages('./RHome/orl-s1-', {'1' '2' '3' '4' '5' '6' },...
       {'x'},'JPG', 1);
    FACES = augmentlr(FACES);
%     [NORM_FACES, SHADING] = normalize(FACES, MASK1);
    NORM_FACES = FACES;
    % Expand image set here
    FACEV = buildimvector(NORM_FACES, MASK1);
    FACER = buildresvector(NORM_FACES, FACE_T);

    % Load the non-face images, normalize, and set training vectors
    NFACES = loadimages('./Test-10/n', ...
        {'01' '02' '03' '04' '05' '06'}, ...
            {'x'}, 'PNG', 1);
    NFACES = augmentlr(NFACES);
    NFACES = augmentud(NFACES);
%     [NORM_NFACES, NSHADING] = normalize(NFACES, MASK1);
    NORM_NFACES = NFACES;
    % Expand image set here
    NFACEV = buildimvector(NORM_NFACES, MASK1);
    NFACER = buildresvector(NORM_NFACES, FACE_F);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                          Neural Net Training
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Build a neural net and train it
    NET = createnn(NI, 3, 1, FACE_F, FACE_T);
    [NET,PERF, ERR] = trainnn(NET,[NFACEV FACEV], [NFACER FACER], .10, 1);

NUM_FACES  = size(FACES,2);
NUM_NFACES = size(NFACES,2);
% 
% ferr = 0;
% for i=1:NUM_FACES,
%   TEST = classifynn(NET, FACES{i}, MASK1,1,1);
%   fprintf(1, '(Target, Test, Match): (%f,%f,%d)\n', FACE_T, TEST, TEST > 0);   
%   ferr = ferr + (TEST < 0);
% end
% for i=1:NUM_FACES,
    [r c]=size(IM1);
    tes1=  reshape(IM1,r*c,1);

    TEST = sim(NET, tes1);
%     [RECT, IMR,TEST] = facescan(NET, IM, MASK1, 0.4, 1, 1, 1.2, 2);

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
% end
    
end
toc
end