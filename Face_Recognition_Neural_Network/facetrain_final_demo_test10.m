% Desc:   Main training implementation of the face detector
%
% For now, just a script... make it so that a picture filename can be passed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                 Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
close all
clear all
% Neural net constants
FACE_T =  0.9;
FACE_F = -0.9;

% Load the image oval mask
MASK = buildmask;
%IM2BW(rgb2gray(imread('./scaled/mask_96_128.jpg')));
NI   = size(find(MASK),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              Image Loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load the face images, normalize, and set training vectors
FACES = loadimages('./Test-10/orl-s1-', {'1' '2' '3' '4' '5' '6' '7' '8' '9' ...
'10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24'...
'25' '26' '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' ...
'40' '41' '42' '43' '44' '45' '46' '47' '48' '49' '50' '51' '51' '52' '53'...
'54' '55' '56' '57' '58' '59' '60' '61' '62' '63' '64' '65' '65' '66' '67'...
'68' '69' '70' '71' '72' '73' '74' '75' '76' '77' '78' '79' '80' '81' '82'},...
   {'x'},'JPG', 1);
FACES = augmentlr(FACES);
[NORM_FACES, SHADING] = normalize(FACES, MASK);
% Expand image set here
FACEV = buildimvector(NORM_FACES, MASK);
FACER = buildresvector(NORM_FACES, FACE_T);

% Load the non-face images, normalize, and set training vectors
NFACES = loadimages('./Test-10/n', ...
	{'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13'...
    '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26'...
    '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' '40'}, ...
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
[NET,PERF, ERR] = trainnn(NET,[NFACEV FACEV], [NFACER FACER], .10, 10);
figure(1); plot(PERF(:,1),PERF(:,2),'b-',PERF(:,1),PERF(:,3),'r-'),title('Training Performance'),xlabel('No of iterations'),ylabel('Performance Amp');
figure(2); plot(ERR (:,1),ERR (:,2),'b-',ERR (:,1),ERR (:,3),'r-'),title('Training Error'),xlabel('No of iterations'),ylabel('Error Amp');
save NET;
% load NET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          Performance Testing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Test performance - for now just test on original images; extend to
% an image pyramid and return upper left corner of all 27x18 face 
% bounding boxes
NUM_FACES  = size(FACES,2);
NUM_NFACES = size(NFACES,2);

t0 = clock; ferr = 0;
for i=1:NUM_FACES,
  TEST = classifynn(NET, FACES{i}, MASK,1,1);
  fprintf(1, '(Target, Test, Match): (%f,%f,%d)\n', FACE_T, TEST, TEST > 0);   
  ferr = ferr + (TEST < 0);
end

nferr = 0;
for i=1:NUM_NFACES,
  TEST = classifynn(NET, NFACES{i}, MASK,1,1);
  fprintf(1, '(Target, Test, Match): (%f,%f,%d)\n', FACE_F, TEST, TEST < 0);   
  nferr = nferr + (TEST > 0);
end

fprintf(1, '\n(Face Err, Nonface Err, Total Err): (%1.3f,%1.3f,%1.3f)\n', ...
	ferr./NUM_FACES, nferr./NUM_NFACES, (ferr + nferr)./(NUM_FACES + NUM_NFACES));
fprintf(1, 'Total no %d images: \n', NUM_FACES+NUM_NFACES);
fprintf(1, 'Time to classify %5.3f\n', etime(clock,t0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


