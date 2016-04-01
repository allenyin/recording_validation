function d = naiveVanRossum(train1, train2, tau, Fs)

% Calculates the Van Rossum distance between two spike trains the naive way
% by convolving the spike trains (treating them as impluse trains) with one-sided
% exponential decay kernel with time parameter tau. The distance then is the
% Euclidean distance of the resulting waveform.
%
% train1, train2: column vectors of spike times.
% tau: the time decay parameter of the exponential.
%
% Both spike time and sigma are in seconds.
% 
% For a detailed description refer to:
%   Paiva, Park and Principe:
%   "A comparison of binless spike train measures"
%   Neural computing and applications (2010).
%
% -Allen Yin

    tol = 1e-4;
    t = min([train1;train2]):1/Fs:max([train1;train2]); % time vector
    spikes1 = zeros(numel(t),1);
    spikes2 = zeros(numel(t),1);

    % Convert spike train times to binary time vector, where
    % a 1 indexes a spike at that point in the time vector.
    for i=1:numel(train1),
        spike_idx = find(abs(t - train1(i)) <= tol);
        spikes1(spike_idx) = 1;
    end

    for i=1:numel(train2),
        spike_idx = find(abs(t - train2(i)) <= tol);
        spikes2(spike_idx) = 1;
    end

    t_exp = 0:1/Fs:5*tau;
    y_exp = exp(-t_exp/tau);

    spikes1 = conv(spikes1, y_exp);
    spikes2 = conv(spikes2, y_exp);

    t = min(t):1/Fs:max(t)+5*tau;   % convolved time
    % plot the filtered spike train
    figure;
    plot(t, spikes1);
    hold on;
    plot(t, spikes2, 'r');

    % Calculates Euclidean distance between the filtered spike trains
    % Use 1/Fs as dt of the continuous integral.
    % Note that the dt used has impact on what the resulting distance.
    % Recommend using the estimator in fastVanRossum.
    d = 0;
    for i=1:numel(t),
        d = d + ((spikes1(i) - spikes2(i))^2)/Fs;
    end
    d = d/tau;

end


