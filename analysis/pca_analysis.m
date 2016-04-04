function [m_window, coeffs, scores] = pca_analysis(signal, minpeak, Fs, duration)

% Do pca analysis on time series.
% Inputs:
%   signal: Time series with sampling frequency = Fs
%   minpeak: Spike voltage crossing threshold.
%   Fs: Sampling frequency in Hz.
%   duration: Time window around each spike that we analyze, in seconds.

    % Detect location of peaks - spikes
    [pks, locs] = findpeaks(signal, 'MinPeakHeight', minpeak);

    % Take windows around each peak
    nsamps = round(duration*Fs);   
    if mod(nsamps,2) == 0,
        nsamps = nsamps+1;
    end
    window = -floor(nsamps/2):floor(nsamps/2);

    % N x nsamps matrix to hold all the snippets around spikes
    m_window = zeros(numel(pks), nsamps);
    for i = 1:numel(pks),
        if locs(i) < floor(nsamps/2)+1,
            continue;
        end
        m_window(i,:) = signal(locs(i)+window);
    end
    m_window(~any(m_window,2), :) = [];

    % plot the snippets
    figure; plot(m_window.');

    % plot projections
    [coeffs, scores]= pca(m_window);
    figure; scatter(scores(:,1), scores(:,2));  % project into first two components

    % plot first four PC
    figure; plot(coeffs(:,1));
    hold on; plot(coeffs(:,2),'r');
    plot(coeffs(:,3),'g'); plot(coeffs(:,4),'k');
end
