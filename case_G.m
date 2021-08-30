function mpc = case_G

%% Created Date：2020-10-03
%% Author：Dirreck_3170105814_葛明阳

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%% system MVA base
% mpc.baseMVA = 100;

%% bus data
% bus_i  type  Fd   Pr  Prmax  Prmin
% mpc.bus = [
%   1  3  0        5.0000 10  0 
%   2  3  0        5.0000 10  0
%   3  1  0        4.4973 10  0
%   4  1  1100     4.4839 10  0
%   5  1  1647.12  4.4397 10  0
%   6  1  1871.35  4.4394 10  0
%   7  1  2000     4.4323 10  0
% %   8  1 500       4.4000 10  0
% ];
mpc.bus = [
  1  3  0        5.0000 10  0 
  2  3  0        5.0000 10  0
  3  1  0        5 10  0
  4  1  1100     5 10  0
  5  1  1647.12  5 10  0
  6  1  1871.35  5 10  0
  7  1  2000     5 10  0
%   8  1 500      5 10  0
];

% Gload=[0 1100 1647.12 1871.35 2000]/G_B;
%% generator data
% bus  Gg Vg    Gmax  Gmin
mpc.gen = [
  1  0  5.0000  5000  0
  2  0  5.0000	5000  0
];
%% branch data
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
