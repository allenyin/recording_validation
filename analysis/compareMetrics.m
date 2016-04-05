% Test script on test signal

reference_data = '../audioSignals/reference_signal_100dB.mat';
RHD_data = '../wirelessRecordings/slowSpikes/RHD_fixedgain=-18_1spike2msRP_100dB';
RHA_data = '../wirelessRecordings/slowSpikes/RHA_1p4_AGC4000_noLMS_1spike2msRP_100dB';
plexon_data = '../plexonRecordings/validation_test1_plexon_100dB';

SNR = [100, 30, 10, 5, 1];      % SNR in dB 
binSize = [10, 25, 50, 100];    % in ms



fprintf('\n---------------RHD against reference----------\n');
[signals, RHD.waveformData, RHD.refSpikeTimes, RHD.dataSpikeTimes, RHD.binnedXCorr, RHD.VPDist, ...
 RHD.VRDist, RHD.SchreiberDist] = wirelessMetric(RHD_data, reference_data, binSize, 0.7);
close all;
 
fprintf('\n---------------RHA against reference----------\n');
[signals, RHA.waveformData, RHA.refSpikeTimes, RHA.dataSpikeTimes, RHA.binnedXCorr, RHA.VPDist, ...
 RHA.VRDist, RHA.SchreiberDist] = wirelessMetric(RHA_data, reference_data, binSize, 0.7);
close all;

fprintf('\n---------------Plexon against reference----------\n');
[signals, plexon.waveformData, plexon.refSpikeTimes, plexon.dataSpikeTimes, plexon.binnedXCorr, ...
 plexon.VPDist, plexon.VRDist, plexon.SchreiberDist] = plexonMetric(plexon_data, reference_data, binSize, 0.7, 'AD12');
close all;

% Plot comparison values

figure;
plot(binSize, RHD.binnedXCorr.d_B, 'b-*');
hold on;
plot(binSize, RHA.binnedXCorr.d_B, 'r-*');
plot(binSize, plexon.binnedXCorr.d_B, 'g-*');
xlim([0, 120]); xlabel('Bin size (ms)');
ylabel('Dissimilarity');
title('Binned distance');
legend('RHD', 'RHA', 'plexon');

figure;
plot(binSize, RHD.VPDist, 'b-*');
hold on;
plot(binSize, RHA.VPDist, 'r-*');
plot(binSize, plexon.VPDist, 'g-*');
xlim([0, 120]); xlabel('Acceptable spike shift (ms)');
title('Victor-Purpura distance');
legend('RHD', 'RHA', 'plexon');

figure;
plot(binSize, RHD.VRDist, 'b-*');
hold on;
plot(binSize, RHA.VRDist, 'r-*');
plot(binSize, plexon.VRDist, 'g-*');
xlim([0, 120]); xlabel('Kernel decay time(ms)');
title('Van Rossum distance');
legend('RHD', 'RHA', 'plexon');

figure;
plot(binSize, RHD.SchreiberDist, 'b-*');
hold on;
plot(binSize, RHA.SchreiberDist, 'r-*');
plot(binSize, plexon.SchreiberDist, 'g-*');
xlim([0, 120]); xlabel('Gaussian \sigma (ms)');
ylim([0, 1]); ylabel('Schreiber dissimilarity');
title('Schreiber dissimilarity');
legend('RHD', 'RHA', 'plexon');

