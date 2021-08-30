function mpc = case_E
% Cap Trans x   Line b     BUs  bs
%% Created Date：2020-10-03
%% Author：Dirreck_3170105814_葛明阳

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
mpc.baseMVA = 100;

%% bus data
% bus_i  type  Pd  Qd  Gs  Bs  area  Vm  Va  baseKV  zone  Vmax  Vmin
mpc.bus=[
    1	3	0	  0   0  0   1  1     0  1  1  1.1  0.9
    2   1   0     0   0  0   1  1     0  1  1  1.1  0.9
	3	1	0     0   0  0   1  1     0  1  1  1.1  0.9
];
%% generator data
% bus  Pg  Qg  Qmax  Qmin Vg  mBase  status  Pmax  Pmin  Pc1  Pc2  Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc  ramp_10  ramp_30  ramp_q  apf
mpc.gen = [
    1  0     0   0   0   1    100  1   0  0  0  0  0  0  0  0  0  0  0  0  0
];
%% branch data
% fbus  tbus  r  x  b  rateA  rateB  rateC  ratio  angle  status  angmin  angmax
mpc.branch=[
	1	2	0.0035	0.0411	1.3974  0   0   0   0       0   1    -360	360;
	1	3	0.0013	0.0151	0.5144  0   0   0   0       0   1    -360	360;
    ];
%% 
% mpc.gencost=[
%     2   0   0   3   0.00504395 2.004335  1200.6485
%     2   0   0   3   0.020055   5.00746   1857.201
% ];