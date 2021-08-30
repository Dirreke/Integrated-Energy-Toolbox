function [load,sourse] = myH_bustypes(bus)


%% constants
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;


%% form index lists for slack, PV, and PQ buses
load = find(bus(:, BUS_TYPE) == LOAD);   %% reference bus index
sourse  = find(bus(:, BUS_TYPE) == SOURSE );   %% PQ bus indices

%% pick a new reference bus if for some reason there is none (may have been shut down)
if isempty(sourse)
        sourse = load(1);    %% use the first PV bus
        load(1) = [];     %% delete it from PV list
end
