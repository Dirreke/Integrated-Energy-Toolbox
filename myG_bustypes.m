function [load,conpr,sourse] = myG_bustypes(bus)


%% constants
[LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = myG_idx_bus;


%% form index lists for slack, PV, and PQ buses
load = find(bus(:, BUS_TYPE) == LOAD);   %% reference bus index
conpr  = find(bus(:, BUS_TYPE) == CONPR );   %% PV bus indices
sourse  = find(bus(:, BUS_TYPE) == SOURSE );   %% PQ bus indices

%% pick a new reference bus if for some reason there is none (may have been shut down)
if isempty(sourse)
        sourse = conpr(1);    %% use the first PV bus
        conpr(1) = [];     %% delete it from PV list
end
