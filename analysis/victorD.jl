function spkd_qpara(tli, tlj, costs)
    nspi = length(tli);
    nspj = length(tlj);
    if costs == 0
        d = abs(nspi-nspj);
        return
    elseif costs==Inf
        d = nspi+nspj;
        return
    end

    scr = zeros(nspi+1, nspj+1);
    scr[:,1] = (0:nspi)';
    scr[1,:] = (0:nspj);
    scr_new = zeros(1, nspi+1, nspj+1);
    scr_new[1,:,:] = scr;
    scr = scr_new;
    scr = repeat(scr, outer=[length(costs),1,1]);
    if nspi>0 && nspj>0
        for i=2:nspi+1
            for j=2:nspj+1
                scr[:,i,j]=min(cat(3, scr[:,i-1,j]+1, scr[:,i,j-1]+1, scr[:,i-1,j-1]+costs'*abs(tli[i-1]-tlj[j-1])),[],3);
            end
        end
    end
    d = scr[:,nspi+1,nspj+1];
end

