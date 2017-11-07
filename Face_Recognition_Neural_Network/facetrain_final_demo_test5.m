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
FACES = loadimages('./Row-400/orl-s1-', { '2' '3' '4' '5' '6'   '12' '13' '14' '15' '16'  '22' '23' '24'...
'25' '26'  '32' '33' '34' '35' '36'  '42' '43' '44' '45' '46'  '52' '53' '54' ...
'55' '56'  '62' '63' '64' '65' '66' '72' '73' '74' '75' '76'  '82' '83' '84' ...
'85' '86'  '92' '93' '94' '95' '96' '102' '103' '104' '105' '106'  '112'...
'113' '114' '115' '116'  '122' '123' '124' '125'...
'126' '132' '133' '134' '135' '136'  '142' '143' '144' '145' '146' ...
'152' '153' '154' '155' '156'  '162' '163' '164'...
'165' '166'  '172' '173' '174' '175' '176'  '182' '183' '184' '185' '186' ...
'192' '193' '194' '195' '196'  '202' '203'...
'204' '205' '206' '212'...
'213' '214' '215' '216'  '222' '223' '224' '225'...
'226'  '232' '233' '234' '235' '236' '242' '243' '244' '245' '246' ...
'252' '253' '254' '255' '256'  '262' '263' '264'...
'265' '266' '272' '273' '274' '275' '276'  '282' '283' '284' '285' '286' ...
'292' '293' '294' '295' '296'  '302' '303'...
'304' '305' '306'  '312'...
'313' '314' '315' '316' '322' '323' '324' '325'...
'326'  '332' '333' '334' '335' '336' '342' '343' '344' '345' '346' ...
'352' '353' '354' '355' '356' '362' '363' '364'...
'365' '366' '372' '373' '374' '375' '376'  '382' '383' '384' '385' '386' ...
'392' '393' '394' '395' '396'  ...
  },{'x'},'JPG', 1);
%FACES = augmentlr(FACES);
[NORM_FACES, SHADING] = normalize(FACES, MASK);
% Expand image set here
FACEV = buildimvector(NORM_FACES, MASK);
FACER = buildresvector(NORM_FACES, FACE_T);

% Load the non-face images, normalize, and set training vectors
NFACES = loadimages('./Test5/n', ...
	{'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12' '13'...
    '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24' '25' '26'...
    '27' '28' '29' '30' '31' '32' '33' '34' '35' '36' '37' '38' '39' '40'}, ...
       	{'x'}, 'PNG', 1);
%NFACES = augmentlr(NFACES);
%NFACES = augmentud(NFACES);
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
%save NET;
save train_10 NET

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
fprintf(1, 'Time to classify %d images: %5.3f\n', NUM_FACES+NUM_NFACES, etime(clock,t0));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


