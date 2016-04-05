function [acor_lag, d_B] = binned_xcorr(train1, train2, binSize)

% Given the spike times in train1 and train2 in seconds, use values in binSize for binning.
% Plot the cross-correlation of the binned firing rates and print out the maximum cross-correlation
% value and the time lag.
%
% Also calculates the binned distance, which is the absolute value of different of binned firing rates,
% defined as D_B in (Chicharro et al., 2011)
%
% train1, train2: column vectors, spike times in seconds
% binSize: vector with the bin size in ms.
% acor_lag: cell of arrays, number of elements equalt to that in binSize.
%           Each cell contains the [acor,lag] for each cross-correlation. 
% d_B: binned distance for each binsize.
%
% -Allen Yin

    % Plot the binned firing rates, use binning.m, from monkeyCar scripts
    % Assign train1 spike times as unit 1, train2 spike times as unit 2.
    allSpikes = [train1, ones(numel(train1),1)];
    allSpikes = [allSpikes; train2, 2*ones(numel(train2),1)];

    fprintf('\n----------Binned cross-correlation metrics----------\n');
    acor_lag = cell(numel(binSize),1);
    d_B = zeros(numel(binSize),1);
    for t=1:numel(binSize),
        [binned, bins, ~] = binning(allSpikes, binSize(t)); % binned has units of spike/binsize(t)
        binned = binned./(binSize(t)*1e-3);
        figure;
        plot(bins, binned(1,:));
        hold on;
        plot(bins, binned(2,:), 'r');
        xlabel('Bin times (s)'); ylabel('Firing rate (Hz)');
        title(sprintf('Firing rates with %dms bin size', binSize(t)));
        hold off;

        % print and plot xcorrelation
        [acor, lag] = xcorr(binned(1,:), binned(2,:));
        [~, I] = max(abs(acor));
        lagDiff = lag(I);
        fprintf('Bin size=%dms: Recording lags reference by %0.3f ms, max correlation=%5.2e\n',...
                binSize(t), -lagDiff*binSize(t), acor(I));
        acor_lag{t} = [acor,lag];

        % calculate binned distance
        d_B(t) = sum(abs(binned(1,:) - binned(2,:)));
    end
end

