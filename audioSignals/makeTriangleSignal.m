function y = makeTriangleSignal(T)

% Given time length T, in seconds, make a triangle signal in the form:
% 
%  /\    /\         
% /  \  /  \  ... 
%     \/    \/
%              
% where the signal ranges from [-1,1]. 
% 
% Each triangle (up and down) period is 10ms

dt = 0.05e-3;   % 0.05ms interval.
Fs = 1/dt;      % 20kHz

nsnippet = 10e-3 / dt;
snippet = zeros(1, nsnippet);

nseg = nsnippet/4;  % 50 samples per ramp part
tramp = 1:nseg;

snippet(1:nseg) = tramp./nseg;
snippet(nseg+1:2*nseg) = -tramp./nseg+1;
snippet(2*nseg+1:3*nseg) = -tramp./nseg;
snippet(3*nseg+1:4*nseg) = tramp./nseg-1;

n = round(T/dt/nsnippet);
y = repmat(snippet, [1,n]);
