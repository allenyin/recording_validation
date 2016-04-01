using MAT
using JLD

# Read in the julia signal file
A = load("spikes_2neuron.jld");


#=
  A["fv"] contains the voltage values, ranging from [-145, 61]
  A["time_stamps"] contains the spike times, in terms of array index
=#

file = matopen("spikes_2neuron.mat", "w");
write(file, "signal", A["fv"]);
write(file, "timestamps1", A["time_stamps"][1]);
write(file, "timestamps2", A["time_stamps"][2]);
close(file);
