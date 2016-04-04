Duration = 100;             % 100 seconds
SampleRate = 31250;         % Hz
N_Targets = 1;              % number of neurons
RefractoryPeriod = 0.002;   % in seconds, so 2ms RP

NoiseSNR = [100, 30, 10, 5, 1];     % noise snr in dB
Fs = 31250;                         % Sampling rate in Hz, of signal

% Make 1 spike reference signals

%referenceSignals = cell(numel(NoiseSNR),1);
%
%referenceSignals{1}.NoiseSNR = NoiseSNR(1);
%[referenceSignals{1}.signals, referenceSignals{1}.target, ~] = ...
%    generatenoisysamples('Duration', Duration, 'SampleRate', SampleRate, 'N_Targets', N_Targets, ...
%    'RefractoryPeriod', RefractoryPeriod,'NoiseSNR', NoiseSNR(1));
%
%target1 = referenceSignals{1}.target;
%
%for i=2:numel(NoiseSNR),
%    referenceSignals{i}.NoiseSNR = NoiseSNR(i);
%    [referenceSignals{i}.signals, referenceSignals{i}.target, ~] = ...
%        generatenoisysamples('Duration', Duration, 'SampleRate', SampleRate, 'N_Targets', N_Targets, ...
%        'RefractoryPeriod', RefractoryPeriod,'NoiseSNR', NoiseSNR(i), 'ReuseTargets', target1);
%end
%
%% Convert them to audio file
%for i=1:numel(NoiseSNR),
%    fname = sprintf('../audioSignals/reference_100s_1Spike_2msRP_%ddB.wav', NoiseSNR(i));
%    audiowrite(fname, referenceSignals{i}.signals(1:Fs*Duration), Fs);
%end
%
%% Save the cell array
%save('../audioSignals/referenceSignal_100s_1Spike_2msRP.mat','referenceSignals');

%---------------------------------------------------------------------------------
% Make 2 spike reference signals
N_Targets = 2;

referenceSignals = cell(numel(NoiseSNR),1);

referenceSignals{1}.NoiseSNR = NoiseSNR(1);
[referenceSignals{1}.signals, referenceSignals{1}.target, ~] = ...
    generatenoisysamples('Duration', Duration, 'SampleRate', SampleRate, 'N_Targets', N_Targets, ...
    'RefractoryPeriod', RefractoryPeriod,'NoiseSNR', NoiseSNR(1));

target1 = referenceSignals{1}.target;

for i=2:numel(NoiseSNR),
    referenceSignals{i}.NoiseSNR = NoiseSNR(i);
    [referenceSignals{i}.signals, referenceSignals{i}.target, ~] = ...
        generatenoisysamples('Duration', Duration, 'SampleRate', SampleRate, 'N_Targets', N_Targets, ...
        'RefractoryPeriod', RefractoryPeriod,'NoiseSNR', NoiseSNR(i), 'ReuseTargets', target1);
end

% Convert them to audio file
for i=1:numel(NoiseSNR),
    fname = sprintf('../audioSignals/reference_100s_2Spike_2msRP_%ddB.wav', NoiseSNR(i));
    audiowrite(fname, referenceSignals{i}.signals(1:Fs*Duration), Fs);
end

% Save the cell array
save('../audioSignals/referenceSignal_100s_2Spike_2msRP.mat','referenceSignals');


