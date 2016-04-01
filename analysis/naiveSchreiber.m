function d = naiveSchreiber(train1, train2, sigma, Fs)

% Calculates the Schreiber similarity measure between two spike trains
% train1 and train2 are matrices column vector of spike times. 
% sigma: the variance of the Gaussian kernel. 
%
% Both spike time and sigma are in seconds.
%
% For a detailed description refer to:
% Paiva, Park and Principe:
% "A comparison of binless spike train measures"
% Neural computing and applications (2010).
%
% -Allen Yin

    tol = 1e-4;
    t = min([train1;train2]):1/Fs:max([train1;train2]);       % time vector
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

    t_gauss = -3*sigma:1/Fs:3*sigma;            % length of gaussian kernel
    y_gauss = exp(-t_gauss.^2/sigma^2);

   spikes1 = conv(spikes1, y_gauss);
   spikes2 = conv(spikes2, y_gauss);

   t = min(t)-3*sigma:1/Fs:max(t)+3*sigma;           % convolved time
   % plot the filtered spike train
   figure;
   plot(t, spikes1);
   hold on;
   plot(t, spikes2, 'r');

   % similarity measure -- cos of angle between spikes1 and spikes2
   d = dot(spikes1, spikes2)/(norm(spikes1)*norm(spikes2));

end
    
