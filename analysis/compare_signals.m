% Run in /analysis directory
SNR = [100, 30, 10, 5, 1];   % SNR in dB
binSize = [10, 25, 50, 100]; % time parameters in ms

% First compare 1 spike signal
reference_data = '../audioSignals/referenceSignal_100s_1Spike_2msRP.mat';
RHD_prefix = '../wirelessRecordings/slowSpikes/RHD_1spike2msRP';
RHA_prefix = '../wirelessRecordings/slowSpikes/RHA_1spike2msRP';
plex_prefix = '../plexonRecordings/plexon_1spike2msRP';

% minPeakHeight needed to (reasonably) align waveform by first spike, not always possible due to high noise
% RHD can align perfectly
RHD_minPeakHeight = [0.7, 0.7, 0.7, 0.7, 0.7];
% RHA, cant align with peakfinding for SNR=30dB and 1dB. 5dB signal shorter than ref b/c premature stop
RHA_minPeakHeight = [0.75, 0.9, 0.9, 0.95, 0.9];
% Plexon, can't align for 1dB
plex_minPeakHeight = [0.5, 0.6, 0.5, 0.4, 0.3];

% Loading reference data -- referenceSignals into workspace
load(reference_data);
fprintf('\n-------------- Plexon against reference ---------\n');
plex_results = cell(numel(SNR),1);
parfor i=1:numel(SNR),
    plex_str = sprintf('%s_%ddB', plex_prefix, SNR(i));
    [~, plex_results{i}.waveformData, plex_results{i}.refSpikeTimes, plex_results{i}.dataSpikeTimes, ...
     plex_results{i}.binnedXCorr, plex_results{i}.VPDist, plex_results{i}.VRDist, plex_results{i}.SchreiberDist] = ...
    plexonMetric(plex_str, referenceSignals{i}, binSize, 'AD17', plex_minPeakHeight(i));
    close all;
end

fprintf('\n--------------- RHD against reference ---------\n');
RHD_results = cell(numel(SNR),1);
parfor i=1:numel(SNR),
    RHD_str = sprintf('%s_%ddB', RHD_prefix, SNR(i));
    [~, RHD_results{i}.waveformData, RHD_results{i}.refSpikeTimes, RHD_results{i}.dataSpikeTimes, ...
     RHD_results{i}.binnedXCorr, RHD_results{i}.VPDist, RHD_results{i}.VRDist, RHD_results{i}.SchreiberDist] = ...
    wirelessMetric(RHD_str, referenceSignals{i}, binSize, RHD_minPeakHeight(i));
    close all;
end

fprintf('\n-------------- RHA against reference ------------\n');
RHA_results = cell(numel(SNR),1);
parfor i=1:numel(SNR),
    RHA_str = sprintf('%s_%ddB', RHA_prefix, SNR(i));
    [~, RHA_results{i}.waveformData, RHA_results{i}.refSpikeTimes, RHA_results{i}.dataSpikeTimes, ...
     RHA_results{i}.binnedXCorr, RHA_results{i}.VPDist, RHA_results{i}.VRDist, RHA_results{i}.SchreiberDist] = ...
    wirelessMetric(RHA_str, referenceSignals{i}, binSize, RHA_minPeakHeight(i));
    close all;
end


% Plot metric results.
RHDlines = {'k-*', 'b-*', 'r-*', 'g-*', 'c-*'}; % RHD is *
RHAlines = {'k-o', 'b-o', 'r-o', 'g-o', 'c-o'}; % RHA is o
plexlines= {'k-x', 'b-x', 'r-x', 'g-x', 'c-x'}; % plexon is x

% d_B
figure; hold on;
l = {};
for i=1:numel(SNR)
    plot(binSize, RHD_results{i}.binnedXCorr.d_B, RHDlines{i});
    plot(binSize, RHA_results{i}.binnedXCorr.d_B, RHAlines{i});
    plot(binSize, plex_results{i}.binnedXCorr.d_B, plexlines{i});
    l = [l, sprintf('RHD %ddB', SNR(i)), sprintf('RHA %ddB', SNR(i)), sprintf('Plex %ddB', SNR(i))];
end
xlim([0, 120]); xlabel('Bin size (ms)');
ylabel('Distance');
title('Binned distance');
legend(l);

% Victor-Purpura distance
figure; hold on;
l = {};
for i=1:numel(SNR)
    plot(binSize, RHD_results{i}.VPDist, RHDlines{i}); 
    plot(binSize, RHA_results{i}.VPDist, RHAlines{i});
    plot(binSize, plex_results{i}.VPDist, plexlines{i});
    l = [l, sprintf('RHD %ddB', SNR(i)), sprintf('RHA %ddB', SNR(i)), sprintf('Plex %ddB', SNR(i))];
end
xlim([0,120]); xlabel('Acceptable spike shift (ms)');
title('VP Distance');
legend(l);

% Van Rossum distance
figure; hold on;
l = {};
for i=1:numel(SNR),
    plot(binSize, RHD_results{i}.VRDist, RHDlines{i});
    plot(binSize, RHA_results{i}.VRDist, RHAlines{i});
    plot(binSize, plex_results{i}.VRDist, plexlines{i});
    l = [l, sprintf('RHD %ddB', SNR(i)), sprintf('RHA %ddB', SNR(i)), sprintf('Plex %ddB', SNR(i))];
end
xlim([0, 120]); xlabel('Kernel decay time(ms)');
title('Van Rossum distance');
legend(l);

% Schreiber dist
figure; hold on;
l = {};
for i=1:numel(SNR),
    plot(binSize, RHD_results{i}.SchreiberDist, RHDlines{i});
    plot(binSize, RHA_results{i}.SchreiberDist, RHAlines{i});
    plot(binSize, plex_results{i}.SchreiberDist, plexlines{i});
    l = [l, sprintf('RHD %ddB', SNR(i)), sprintf('RHA %ddB', SNR(i)), sprintf('Plex %ddB', SNR(i))];
end
xlim([0, 120]); xlabel('Gaussian \sigma (ms)');
ylim([0, 1]); ylabel('Schreiber dissimilarity');
title('Schreiber dissimilarity');
legend(l);

%--------- Plot mean+/-std of metric over different noise level---------------
RHD_d_B = cell2mat(cellfun(@(x) x.binnedXCorr.d_B.', RHD_results, 'UniformOutput', false));
RHA_d_B = cell2mat(cellfun(@(x) x.binnedXCorr.d_B.', RHA_results, 'UniformOutput', false));
plex_d_B = cell2mat(cellfun(@(x) x.binnedXCorr.d_B.', plex_results, 'UniformOutput', false));
figure; hold on;
errorbar(binSize, mean(RHD_d_B,1), std(RHD_d_B,1), 'b');
errorbar(binSize, mean(RHA_d_B,1), std(RHA_d_B,1), 'r');
errorbar(binSize, mean(plex_d_B,1), std(plex_d_B,1), 'g');
legend('RHD', 'RHA', 'plexon');
xlim([0, 120]); xlabel('Bin size (ms)');
ylabel('Distance');
title('Binned distance');

RHD_VP = cell2mat(cellfun(@(x) x.VPDist, RHD_results, 'UniformOutput', false));
RHA_VP = cell2mat(cellfun(@(x) x.VPDist, RHA_results, 'UniformOutput', false));
plex_VP = cell2mat(cellfun(@(x) x.VPDist, plex_results, 'UniformOutput', false));
figure; hold on;
errorbar(binSize, mean(RHD_VP,1), std(RHD_VP,1), 'b');
errorbar(binSize, mean(RHA_VP,1), std(RHA_VP,1), 'r');
errorbar(binSize, mean(plex_VP,1), std(plex_VP,1), 'g');
legend('plex', 'RHA', 'RHD');
xlim([0, 120]); xlabel('Acceptable spike shift (ms)');
title('Victor-Purpura Distance');

RHD_VR = cell2mat(cellfun(@(x) x.VRDist, RHD_results, 'UniformOutput', false));
RHA_VR = cell2mat(cellfun(@(x) x.VRDist, RHA_results, 'UniformOutput', false));
plex_VR = cell2mat(cellfun(@(x) x.VRDist, plex_results, 'UniformOutput', false));
figure; hold on;
errorbar(binSize, mean(RHD_VR,1), std(RHD_VR,1), 'b');
errorbar(binSize, mean(RHA_VR,1), std(RHA_VR,1), 'r');
errorbar(binSize, mean(plex_VR,1), std(plex_VR,1), 'g');
legend('RHD', 'RHA', 'plexon');
xlim([0, 120]); xlabel('Kernel decay constant(ms)');
title('Van-Rossum Distance');

RHD_Schreiber = cell2mat(cellfun(@(x) x.SchreiberDist, RHD_results, 'UniformOutput', false));
RHA_Schreiber = cell2mat(cellfun(@(x) x.SchreiberDist, RHA_results, 'UniformOutput', false));
plex_Schreiber = cell2mat(cellfun(@(x) x.SchreiberDist, plex_results, 'UniformOutput', false));
figure; hold on;
errorbar(binSize, mean(RHD_Schreiber,1), std(RHD_Schreiber,1), 'b');
errorbar(binSize, mean(RHA_Schreiber,1), std(RHA_Schreiber,1), 'r');
errorbar(binSize, mean(plex_Schreiber,1), std(plex_Schreiber,1), 'g');
legend('RHD', 'RHA', 'plexon');
xlim([0, 120]); xlabel('Gaussian kernel \sigma (ms)');
ylim([0, 1]);   ylabel('Schreiber Dissimilarity');
title('Schreiber Dissimilarity');

