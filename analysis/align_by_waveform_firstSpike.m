function [refFirstPeak, dataFirstPeak] = align_by_waveform_firstSpike(recording, reference, Fs, refSpikeTimes, threshold, tstr)
    
% Align the reference and recording waveform by the location of the first peak.
% Therefore the first spike is automatically a match.
%
% Input recording should be normalized to [-1,1].
% 'threshold' determines what is considered a 'peak' in recording.

    % Plot the original data together with reference
    figure;
    plot(reference); hold on;
    plot(recording, 'r');
    ylim([-1.3, 1.3]);
    title(tstr);

    % Find the peak of first spike in ref signal, since spike times given
    % is the time of initiation of spike, not the peak.
    tFirstSpike = refSpikeTimes(1);
    % find the peak in the 5ms after that time
    idxFirstSpike = round(tFirstSpike*Fs);
    [pks, locs] = findpeaks(reference(idxFirstSpike : idxFirstSpike+round((5e-3)*Fs)), 'MINPEAKHEIGHT', 0.65);
    refFirstPeak = idxFirstSpike+locs(1)-1;

    % Find the peak of first spike of recorded signal
    % Assume spike amplitude greater than noise by quiet a bit, the threshold
    % needs to be higer when AGC is enabled.
    %
    % Input recording should be normalized to [-1,1].
    [pks, locs] = findpeaks(recording, 'MINPEAKHEIGHT', threshold);
    dataFirstPeak = locs(1);        % units = sample number

    % want to align refFirstPeak with dataFirstPeak
    % dataFirstPeak should always be greater than refFirstPeak
    assert(dataFirstPeak >= refFirstPeak, 'dataFirstPeak is not after refFirstPeak!');
    lagDiff = dataFirstPeak - refFirstPeak;
    fprintf('\nAlign by waveform spike peak: recording lags reference by %0.5f seconds\n', lagDiff/Fs);
    fprintf('                              recording lags reference by %d samples\n', lagDiff);
    fprintf('dataFirstPeak at sample %d\n', dataFirstPeak);
    fprintf('refFirstPeak at sample  %d\n\n', refFirstPeak);

    % plot the aligned signals starting from the first peak
    figure;
    plot(reference(refFirstPeak:end)); hold on;
    plot(recording(dataFirstPeak:end), 'r');
    ylim([-1.3,1.3]);
    title(sprintf('%s aligned by firstSpike', tstr));

end



    
