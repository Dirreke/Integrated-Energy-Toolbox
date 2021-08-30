function mpc = case_H

%% Created Date：2020-10-03
%% Author：Dirreck_3170105814_葛明阳

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
mpc.baseMVA = 100;

%% bus data
% % bus_i  type  Pd  Qd  Gs  Bs  area  Vm  Va  baseKV  zone  Vmax  Vmin
% mpc.bus = [
%   1  1  160  80   0  0   1  1     0  1  1  1.1  0.9
%   2  1  200  100  0  0   1  1     0  1  1  1.1  0.9
%   3  1  370  130  0  0   1  1     0  1  1  1.1  0.9
%   4  2  0.0  0.0  0  0   1  1.05  0  1  1  1.1  0.9
%   5  3  0.0  0.0  0  0   1  1.05  0  1  1  1.1  0.9
% ];
% 1 用户节点
% 2 热源节点
% Ph 热功率
% To 输出温度
% bus_i  type  Phid  To  Ts  Tr
mpc.bus = [
  1  1  50000   40  100 40
  2  1  50000   40  100 40
  3  1  50000   40  100 40
  4  1  50000   40  100 40
  5  1  100000  40  100 40
  6  1  50000   40  100 40
  7  1  10000   40  100 40
  8  1  50000   40  100 40
  9  1  80000   40  100 40
  10 1  100000  40  100 40
  11 1  50000   40  100 40
  12 1  50000   40  100 40
  13 1  2000000 40  100 40
%   14 1  50000   40  100  40
  14 2  0       40  100 40
];

%% generator data
% bus  Ts
mpc.gen = [
  14  100
];

%% branch data
% m 流量 kg/s?
% fbus  tbus  L  D  m
mpc.branch=[
    14 1 1000 0.150 7
    1 2 800 0.150   7
    2 3 500 0.150   0.23
    2 4 600 0.150   6.51
    4 5 500 0.150   3.37
    5 6 700 0.150   0.25
    5 7 500 0.150   2.72
    7 8 300 0.150   0.22
    7 9 500 0.150   2.45
    9 10 600 0.150  2.16
    10 11 500 0.150 0.23
    10 12 600 0.150 1.5
    12 13 700 0.150 1.3
    4 13 2500 0.150 3.0
%     13 14 500  0.150 2.9
%     7 13 500  0.150  2.5
    ];