function [channels] = plot_raw_channels(fd_samp, varargin)
% fd_samp: name of the .nlg file output from convert.
% 
% varargin:
%   'plot' :  If false, nothing will be plotted.
%              Otherwise, if only fd_samp is given, assume the channels present
%              do not change plot all four channels. Default to false.
%   'fd_ch' :  name of the .chn file from extracting the .chn.gz from
%              the output of running convert. This contains the channel numbers
%              corresponding to the analog waveforms received. Default is empty.
%
%              If given, the channels output will be a struct, with fields
%              'chn', and 'samp'. Both will be have dimension 4xM, where M is
%              total number of samples. 'chn' corresponds to channel number
%              for each entry in 'samp'.
%
%              Otherwise, will simply be same as 'samp'.
%
% Data description:
%   fd_ch is length 4*N, where N is the number of received packets.
%         each block of 4 contains the channel number corresponding to the
%         analog waveform value being transmitted in each packet.
%
%   fd_samp is length N*(4*6), where N is the number of received packets.
%           each block of 24 contains the analog waveform values, in the order
%           [samp1_ch1, samp1_ch2, samp1_ch3, samp1_ch4, ...
%            samp2_ch1, samp2_ch2, samp2_ch3, sampe2_ch4...]
%           The waveform values are in char (ranges from 0 to 255), it is
%           converted into signed char values.
% 
% Only works for small amount of data...limited by RAM

    funcInputs = parseInputs(fd_samp, varargin{:});

    % parse the sample values
    fileID = fopen(fd_samp);
    data = fread(fileID);   % may overflow if data too big
    fclose(fileID);
    for i=1:numel(data),
        if data(i) > 127,
            data(i) = (256-data(i))*(-1);
        end
    end

    if ~isempty(funcInputs.fd_ch)
        % parse the channel numbers
        fileID = fopen(funcInputs.fd_ch);
        chs = fread(fileID);
        fclose(fileID);

        channels.chn = reshape(chs, 4, []);
        channels.chn = kron(channels.chn, ones(1,6));
        channels.samp = separateCh(data);
    else
        channels = separateCh(data);
        if funcInputs.plot
            figure;
            for i = 1:4
                subplot(4,1,i);
                plot(channels(i,:));
            end
        end
    end
end

function channels = separateCh(data)
    vectorLen = numel(data)/4;
    channels = zeros(4, vectorLen);

    % The data array is written according to the format:
    %       ch# | sample#
    %       1   | 1
    %       2   | 1
    %       3   | 1
    %       4   | 1
    %       1   | 2
    %       2   | 2
    %       3   | 2
    %       4   | 2
    %       ... | ...  
    %       1   | 6
    %       2   | 6
    %       3   | 6
    %       4   | 6
    %       ... | ...

    for i=1:4
        channels(i,:) = data(i:4:numel(data));
    end
end

function funcInputs = parseInputs(fd_samp, varargin)
    funcInputs = inputParser;
    addRequired(funcInputs, 'fd_samp', @isstr);
    addParameter(funcInputs, 'plot', false, @islogical);
    addParameter(funcInputs, 'fd_ch', [], @isstr);

    parse(funcInputs, fd_samp, varargin{:});
    funcInputs = funcInputs.Results;
end
