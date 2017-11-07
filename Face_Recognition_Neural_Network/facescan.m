% Desc:   Build an image resolution pyramid and scan the pyramid for
%         faces given the neural net, image, mask, and threshold -1<THR<1
%
% [RECT, IMR] = facescan(NET, IM, MASK, THR, LEVELS, START, SCALEFACT, STEP)
function [RECT, IMR,TEST] = facescan(NET, IM, MASK, THR, LEVELS, START, SCALEFACT, STEP)

% START can be 1, but use to ignore smaller rectangles (level to start at)
% THR is good around .4 - .6
% STEP is good at 2
% LEVELS is good at 6 (number of pyramid levels with 1 being initial image)
% SCALEFACT is good at 1.2

% Setup
    PYR_MAX = LEVELS; % A good choice is 6
MROWS = size(MASK,1);
MCOLS = size(MASK,2);
IROWS = size(IM, 1);
ICOLS = size(IM, 2);
RECT = [];

% Build the image pyramid
SCALE = SCALEFACT; % A good choice is 1.2
PYR{1} = IM;
XRANGE{1} = 1:1:ICOLS;
YRANGE{1} = 1:1:IROWS;
[MX{1},MY{1}] = meshgrid(XRANGE{1}, YRANGE{1});
for i=2:PYR_MAX,
	XRANGE{i} = 1:SCALE.^(i-1):ICOLS;
	YRANGE{i} = 1:SCALE.^(i-1):IROWS;
	[MX{i},MY{i}] = meshgrid(XRANGE{i}, YRANGE{i});
	PYR{i} = interp2(MX{1}, MY{1}, PYR{1}, MX{i}, MY{i});
end

% View pyramid
% figure(1);
% colormap(gray);
% showimages(PYR, 2, 3, 1, 6, 1);
% drawnow;
% pause;

% Scan the pyramid
for im_num = START:PYR_MAX,
  fprintf(1, '\n\nImage: %d\n', im_num);
  for im_row = 1:STEP:size(PYR{im_num},1)-MROWS+1,
    fprintf(1, ' R:%d', im_row);
    for im_col = 1:STEP:size(PYR{im_num},2)-MCOLS+1,
	TEST = classifynn(NET, PYR{im_num}, MASK, im_row, im_col);
        if (TEST > THR)
	   fprintf(1, '\n  -(INUM,R,C,TEST): [%d] (%d,%d) => %5.3f   ',im_num, im_row, im_col, TEST);
	   RECT = [RECT; (im_row/size(YRANGE{im_num},2))*size(YRANGE{1},2), ...
                         (im_col/size(XRANGE{im_num},2))*size(XRANGE{1},2), ...
                         ((im_row+MROWS-1)/size(YRANGE{im_num},2))*size(YRANGE{1},2), ...
                         ((im_col+MCOLS-1)/size(XRANGE{im_num},2))*size(XRANGE{1},2), ... 
                         TEST];
	end
    end
  end
end

% Plot the bounding boxes in an image to return
IMR = IM;
for i=1:size(RECT,1),
  SR = ceil(RECT(i,1)); 
  ER = ceil(RECT(i,3)); 
  SC = ceil(RECT(i,2)); 
  EC = ceil(RECT(i,4));
  IMR(SR,SC:EC) = 0; 
  IMR(ER,SC:EC) = 0; 
  IMR(SR:ER,SC) = 0;
  IMR(SR:ER,EC) = 0;
end

% Plot the image
figure(2);
colormap(gray);
imagesc(IMR);
drawnow;

