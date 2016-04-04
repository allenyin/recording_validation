function [binnedXcorr, VPDist, VRDist, SchreiberDist] = compareSpikeTimes(refSpikeTimes, dataSpikeTimes, binSize, tstr)

% Inputs:    
%   refSpikeTimes, dataSpikeTimes: spike times in seconds. Column vector
%   binSize: row vector of comparison metric time parameters, in ms. 
%   tstr: String to modify plot titles.
%
% Outputs:
%   binnedXcorr: struct contains two arrays, d_CC and acor_lag. d_CC is the binned cross-correlation
%                 based similarity measure. acor_lag is a cell-array of the cross-correlation of the
%                 binned firing rates. Number of elements equalt to that of binSize.
%   VPDist: Victor-Purpura distances
%   VRDist: Van Rossum distances
%   SchreiberDist: Schreiber distances

    % The first spike time in both dataSpikeTimes and refSpikeTimes are negative, since we aligned
    % the spike times by them. Ignore those
    % Plot regression of the subsequent spike times. Ideally should be y=x
    numSpikes = min(numel(dataSpikeTimes), numel(refSpikeTimes));
    plotLinearRegression(refSpikeTimes(2:numSpikes), dataSpikeTimes(2:numSpikes), ...
                         'reference spike times (s)', sprintf('%s recorded spike times (s)',tstr));

    % Plot the raster plot for comparison, function in the monkeyCar scripts directory
    rasterplot({refSpikeTimes(2:end), dataSpikeTimes(2:end)});
    title(sprintf('%s rasters: refSpikeTimes, dataSpikeTimes', tstr));
    xlabel('time (s)');

    % Plot binned firing rates, analyze cross-correlation.
    [binnedXcorr.acor_lag, binnedXcorr.d_CC] = binned_xcorr(refSpikeTimes(2:end), dataSpikeTimes(2:end), binSize);    

    % Victor-Purpura distance
    q = 2./(binSize.*1e-3);         % cost of shifting a spike is 1 if moved by 10ms, 25ms, etc..
    Jl.include('spkd_qpara.jl');    % This program must be run in the same directory as the julia file.
    VPDist = zeros(size(q));
    fprintf('\n-----------Victor-Purpura distance---------\n');
    for i=1:numel(q),
        VPDist(i) = Jl.call('victorD', refSpikeTimes, dataSpikeTimes, q(i));
        fprintf('Shift within %dms, cost=%5.2e\n', binSize(i), VPDist(i));
    end

    % Van Rossum distance
    VRDist = zeros(size(binSize));
    fprintf('\n-----------Van Rossum distance------------\n');
    for i=1:numel(binSize),
        VRDist(i) = fastVanRossum(refSpikeTimes, dataSpikeTimes, binSize(i)*1e-3);
        fprintf('tau=%dms, distance=%5.2e\n', binSize(i), VRDist(i));
    end

    % Schreiber distance
    SchreiberDist = zeros(size(binSize));
    fprintf('\n------------Schreiber distance------------\n');
    for i=1:numel(binSize),
        SchreiberDist(i) = 1 - fastSchreiber(refSpikeTimes, dataSpikeTimes, binSize(i)*1e-3);
        fprintf('sigma=%dms, dissimilarity=%0.4f\n', binSize(i), SchreiberDist(i));
    end
end

