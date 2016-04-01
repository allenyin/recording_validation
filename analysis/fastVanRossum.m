function d = fastVanRossum(train1, train2, tau)

% Calculates the van Rossum distance between the two spike trains in O(N1*N2).
%
% train1, train2: are column vector of spike times, with N1 and N2 spikes. Time in seconds.
% tau: the time decay parameter controlling the exponential function.
%
% In short, van Rossum distance filters spike trains with one-sided exponential decay
% kernel with time constant tau. The distance is measured as the Euclidean distance 
% between the filtered spike trains.
%
% The fast implementation computes the distance directly using summations of the spike 
% trains applied with Laplacian kernels of the same tau. This is because Laplacian kernels
% arises from the autocorrelation function (with integration oveer time) of the smoothing
% exponential filter.
%
% For a detailed description of van Rossum's distance and the fast implementation:
%   Paiva, Park and Principe:
%   "A comparison of binless spike train measures"
%   Neural computing and applications (2010).
%
% -Allen Yin

    sum1 = 0;
    sum2 = 0;
    sum3 = 0;

    % calculate first summation
    for m=1:numel(train1),
        for n=1:numel(train1),
            sum1 = sum1 + exp(-abs(train1(m)-train1(n))/tau);
        end
    end

    % calculat second summation
    for m=1:numel(train2),
        for n=1:numel(train2),
            sum2 = sum2 + exp(-abs(train2(m)-train2(n))/tau);
        end
    end

    % third summation
    for m=1:numel(train1),
        for n=1:numel(train2),
            sum3 = sum3 + exp(-abs(train1(m)-train2(n))/tau);
        end
    end

    d = (sum1+sum2)/2 + sum3;
end

