function mpc = case_H7

%% Created Date：2020-10-03
%% Author：Dirreck_3170105814_葛明阳

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
mpc.baseMVA = 100;

%% bus data
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
  7 2  0       40  100 40
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
    7 1 1000 0.150 7
    1 2 800 0.150   7
    2 3 500 0.150   0.23
    2 4 600 0.150   6.51
    4 5 500 0.150   3.37
    5 6 700 0.150   0.25
    3 6 500 0.150   2.72
    ];
