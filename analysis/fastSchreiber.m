function d = fastSchreiber(train1, train2, sigma)

% Calculates the Schreiber similarity measure between two spike trains in O(N1*N2).
%
% train1, train2: are column vector of spike times, with N1 and N2 spikes. Time in seconds.
% sigma: the variance of the Gaussian kernel. 
%
% Both spike time and sigma are in seconds.
%
% For a detailed description refer to equation(11) in:
% Paiva, Park and Principe:
% "A comparison of binless spike train measures"
% Neural computing and applications (2010).
%
%
% -Allen Yin

    num = 0;
    den1 = 0;
    den2 = 0;

    % calculate numerator
    for m=1:numel(train1),
        for n=1:numel(train2),
            num = num + exp(-(train1(m)-train2(n))^2/(2*sigma^2));
        end
    end

    % calculate first denominator term
    for m=1:numel(train1),
        for n=1:numel(train1),
            den1 = den1 + exp(-(train1(m)-train1(n))^2/(2*sigma^2));
        end
    end

    % calculate second denominator term
    for m=1:numel(train2),
        for n=1:numel(train2),
            den2 = den2 + exp(-(train2(m)-train2(n))^2/(2*sigma^2));
        end
    end

    d = num/sqrt(den1*den2);
end


