function [dP,dQ] = myEUnbalanced(baseMVA, bus, branch, gen)

if nargin < 4
    mpc     = baseMVA;
    baseMVA = mpc.baseMVA;
    bus     = mpc.bus;
    branch  = mpc.branch;
    gen     = mpc.gen;
end

%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

%% build Ybus
[Ybus, ~, ~] = makeYbus(baseMVA, bus, branch);

%% extract voltage
V = bus(:, VM) .* exp(1j * pi/180 * bus(:, VA));

%% make sure we use generator setpoint voltage for PV and slack buses
on = find(gen(:, GEN_STATUS) > 0);      %% which generators are on?
gbus = gen(on, GEN_BUS);                %% what buses are they at?
k = find(bus(gbus, BUS_TYPE) == PV | bus(gbus, BUS_TYPE) == REF);
V(gbus(k)) = gen(on(k), VG) ./ abs(V(gbus(k))).* V(gbus(k));

%% build Jacobian
   
[ref, ~, pq] = bustypes(bus, gen);
pvpq = bus(:, BUS_I) ~= ref;  

Vm = abs(V);
mpopt = mpoption;
mis = V .* conj(Ybus * V) - makeSbus(baseMVA, bus, gen, mpopt, Vm);
dP = -real(mis(pvpq))';
dQ = -imag(mis(pq))';

end
