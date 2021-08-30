function mpc = gas_test

%% Created Date：2020-10-03
%% Author：Dirreck_3170105814_葛明阳

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
% mpc.baseMVA = 100;

%% bus data
% bus_i  type  Pd  Qd  Gs  Bs  area  Vm  Va  baseKV  zone  Vmax  Vmin
% % % % mpc.bus = [
% % % %   1  1  160  80   0  0   1  1     0  1  1  1.1  0.9
% % % %   2  1  200  100  0  0   1  1     0  1  1  1.1  0.9
% % % %   3  1  370  130  0  0   1  1     0  1  1  1.1  0.9
% % % %   4  2  0.0  0.0  0  0   1  1.05  0  1  1  1.1  0.9
% % % %   5  3  0.0  0.0  0  0   1  1.05  0  1  1  1.1  0.9
% % % % ];

% bus_i  type  Fd   Pr  Prmax  Prmin
mpc.bus = [
  1  3  0        5.0000 10  0 
  2  3  0        5.0000 10  0
  3  1  0        4.4973 10  0
  4  1  1100     4.4839 10  0
  5  1  1647.12  4.4397 10  0
  6  1  1871.35  4.4394 10  0
  7  1  2000     4.4323 10  0
%   8  1 500       4.4000 10  0
];
% Gload=[0 1100 1647.12 1871.35 2000]/G_B;
%% generator data
% % % % bus  Pg  Qg  Qmax  Qmin Vg  mBase  status  Pmax  Pmin  Pc1  Pc2  Qc1min  Qc1max  Qc2min  Qc2max  ramp_agc  ramp_10  ramp_30  ramp_q  apf
% % % mpc.gen = [
% % %   4  500  0  300  -300  1.05  10000  1   800  100  0  0  0  0  0  0  0  0  0  0  0
% % %   5  0    0  500  -210  1.05  10000  1   800  100  0  0  0  0  0  0  0  0  0  0  0
% % % ];



% bus  Gg Vg    Gmax  Gmin
mpc.gen = [
  1  0  5.0000  5000  0
  2  0  5.0000	5000  0
];
%% branch data
% % % % % fbus  tbus  r  x  b  rateA  rateB  rateC  ratio  angle  status  angmin  angmax
% % % % mpc.branch = [
% % % %    1   2  0.04  0.25   0.5  200 0   0  0     0  1  -360  360
% % % %    1   3  0.10  0.35   0.0  65  0   0  0     0  1  -360  360
% % % %    2   3  0.08  0.30   0.5  200 0   0  0     0  1  -360  360
% % % %    2   4  0.00  0.015  0.0  600 0   0  1.05  0  1  -360  360
% % % %    3   5  0.00  0.03   0.0  500 0   0  1.05  0  1  -360  360
% % % % ];
% fbus  tbus  length  diameter  Type
% Type: 树枝1/连枝2/压缩机3
mpc.branch=[
    1 3 500 0.150 1;
   2 6 2500 0.150 1;
   3 4 500 0.150 1;
   3 5 400 0.150 1;
   5 7 600 0.150 1;
   6 7 200 0.150 2;
   3 2 2500 0.150 3;
%    7 8 300  0.150 1
   ];

% diameter mm->m
%% 
% mpc.gencost=[
%     2   0   0   3   0.00504395 2.004335  1200.6485
%     2   0   0   3   0.020055   5.00746   1857.201
% ];