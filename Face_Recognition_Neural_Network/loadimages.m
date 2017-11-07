% Desc:   Loads a set of images into an array given
%         a prefix, suffix, and highest index filename.
%
% IM = loadimages(prefix, subject, letter, suffix, show)
function IM = loadimages(prefix, subject, letter, suffix, show)

clear IM;

% Load the image set
for i = 1:size(subject,2),
   for j = 1:size(letter,2),
      IM{(i-1)*size(letter,2)+j} = double(im2bw(imread([prefix, subject{i}, '-', letter{j}, '.', suffix])));     
      %IM{(i-1)*size(letter,2)+j} = double(imread([prefix, subject{i}, '-', letter{j}, '.', suffix]));     
   end
end

