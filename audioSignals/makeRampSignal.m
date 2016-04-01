function y = makeRampSignal(T)

% Given time length T, in seconds, make a ramp signal in the form:
% 
%        /|       
%  -----/ |----| /---- ...
%              |/
%              
% where the signal ranges from [-1,1]. 
% The flat part is 0.05ms * 111 = 5.55ms, 
% The ramp part is 0.05ms * 111 = 5.55ms

dt = 0.05e-3; % ms

snippet = zeros(1, 111*2+111*2);    % snippet length=444
tflat = 1:111;
tramp = 1:111;
snippet(112:112+111-1) = tramp./111;
snippet(334:334+111-1) = tramp./111-1;

n = round(T/dt);    % number of time points
n_snippet = round(n/444);
y = repmat(snippet, [1, n_snippet]);

end


