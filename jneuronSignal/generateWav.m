function generateWav(matName)

% Given matName converted from jneuron output, convert signal
% into audio wav file.

    load(matName);  % signal is the voltage waveform
    dt = 0.05e-3;   % sampling interval is 0.05ms
    Fs = 1/dt;

    % check if the data format has been converted to that compatible
    % with audioWrite, i.e. uint8, in16, int32, single, double
    if strcmpi(class(signal), 'int64'),
        signal = double(signal);
        timestamps1 = double(timestamps1);
        timestamps2 = double(timestamps2);

        % normalize signal to -1 and 1
        signal = signal./max(abs(signal));
    end

    save(matName, 'signal', 'timestamps1', 'timestamps2');

    fname = strsplit(matName, '.');
    wavName = sprintf('%s.wav', fname{1});
    audiowrite(wavName, signal, Fs);
end
