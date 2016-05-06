% Run in /analysis directory
% script to plot all the raw waveforms and the aligned waveforms (aginst the reference)
% Used to manually check for alignment, to find appropriate minPeakHeight for peak finding
% spikes to align the signals.

SNR = [100,30,10,5,1];  % SNR in dB
binSize = 10;           % doesn't matter since we are not doing metric analysis
minPeakHeight = 0.7;    % default minPeakHeight...doesn't matter here
reference_data = '../audioSignals/referenceSignal_100s_1Spike_2msRP.mat';
RHD_prefix = '../wirelessRecordings/slowSpikes/RHD_1spike2msRP';
RHA_prefix = '../wirelessRecordings/slowSpikes/RHA_1spike2msRP';
plexon_prefix = '../plexonRecordings/plexon_1spike2msRP';

load(reference_data);
fprintf('\n------------ RHD against reference ---------\n');
for i=2:2%numel(SNR),
    RHD_str = sprintf('%s_%ddB', RHD_prefix, SNR(i));
    [~,~,~,~,~,~,~,~] = wirelessMetric(RHD_str, referenceSignals{i}, binSize, 0.7, 'plotAnalog');
end

fprintf('\n------------ RHA against reference ---------\n');
for i=2:2%numel(SNR),
    RHA_str = sprintf('%s_%ddB', RHA_prefix, SNR(i));
    [~,~,~,~,~,~,~,~] = wirelessMetric(RHA_str, referenceSignals{i}, binSize, 0.75, 'plotAnalog');
end

fprintf('\n------------ plexon against reference ---------\n');
for i=2:2%numel(SNR),
    plexon_str = sprintf('%s_%ddB', plexon_prefix, SNR(i));
    [~,~,~,~,~,~,~,~] = plexonMetric(plexon_str, referenceSignals{i}, binSize, 'AD17', 0.3,  'plotAnalog');
end
