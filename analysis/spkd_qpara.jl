function victorD(tli, tlj, cost)

# d = victorD(tli, tlj, cost) calculates the "spike time" distance
# (Victor & Purpura 1996) for a single cost
#
# tli: vector of spike times for first spike train
# tlj: vector of spike times for second spike train
# cost: cost per unit time to move a spike
#
# Spike time in seconds
#
# Translated to Julia by Allen Yin from MATLAB code by Daniel Reich

    
    nspi = length(tli);
    nspj = length(tlj);
    
    if cost == 0
        d = abs(nspi-nspj);
        return
    elseif cost==Inf
        d = nspi+nspj;
        return
    end

    scr = zeros(nspi+1, nspj+1);
    scr[:,1] = (0:nspi)';
    scr[1,:] = (0:nspj);
    if nspi>0 && nspj>0
        for i=2:nspi+1
            for j=2:nspj+1
                scr[i,j] = min(scr[i-1,j]+1,
                                 scr[i,j-1]+1,
                                 scr[i-1,j-1]+cost*abs(tli[i-1]-tlj[j-1]));
            end
        end
    end
    d = scr[nspi+1,nspj+1];
    return d;
end

