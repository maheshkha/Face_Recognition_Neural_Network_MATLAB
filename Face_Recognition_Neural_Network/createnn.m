% Desc:   Creates a neural net with the given parameters
%
% NET = createnn(input, hidden, output, min, max)
function NET = createnn(input, hidden, output, min, max)

PR = repmat([min,max],input,1);
S = [hidden output];
T = {'tansig' 'tansig'};
NET = newff(PR,S,T,'traingdm');
