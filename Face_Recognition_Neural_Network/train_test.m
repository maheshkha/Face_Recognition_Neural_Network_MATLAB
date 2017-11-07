clc
close all
clear all
MASK = ones(27,18);
NI   = size(find(MASK),1);
% Neural net constants
FACE_T =  0.9;
FACE_F = -0.9;

     FACES = loadimages('./RHome/orl-s1-', {'1' '2' '3' '4' '5' },...
       {'x'},'JPG', 1);
    FACES = augmentlr(FACES);
%     [NORM_FACES, SHADING] = normalize(FACES, MASK);
    NORM_FACES = FACES;
    % Expand image set here
    FACEV = buildimvector(NORM_FACES, MASK);
    FACER = buildresvector(NORM_FACES, FACE_T);

    % Load the non-face images, normalize, and set training vectors
    NFACES = loadimages('./Test-10/n', ...
        {'01' '02' '03' '04' '05'}, ...
            {'x'}, 'PNG', 1);
    NFACES = augmentlr(NFACES);
    NFACES = augmentud(NFACES);
    [NORM_NFACES, NSHADING] = normalize(NFACES, MASK);
    % Expand image set here
    NFACEV = buildimvector(NORM_NFACES, MASK);
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
%   TEST = classifynn(NET, FACES{i}, MASK,1,1);
%   fprintf(1, '(Target, Test, Match): (%f,%f,%d)\n', FACE_T, TEST, TEST > 0);   
%   ferr = ferr + (TEST < 0);
% end
for i=1:NUM_FACES,
    IM(:,1)=FACEV(:,i);
%     [IM, PLANE] = normalize(IM, MASK); 
    TEST = sim(NET, IM);
%     [RECT, IMR,TEST] = facescan(NET, IM, MASK, 0.4, 1, 1, 1.2, 2);

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
for i=1:NUM_NFACES,
    IM(:,1)=NFACEV(:,i);
%     [IM, PLANE] = normalize(IM, MASK); 
    TEST = sim(NET, IM);
%     [RECT, IMR,TEST] = facescan(NET, IM, MASK, 0.4, 1, 1, 1.2, 2);

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