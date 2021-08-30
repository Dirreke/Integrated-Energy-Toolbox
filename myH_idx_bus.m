function [LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus
%IDX_BUS   Defines constants for named column indices to bus matrix.
%   Example:
%
%   [LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus
%
%   The index, name and meaning of each column of the bus matrix is given
%   below:
%
%   columns 1-13 must be included in input matrix (in case file)
%    1  BUS_I       bus number (positive integer)
%    2  BUS_TYPE    bus type (1 = Load,2 = constant pressure, 3 = sourse,4 = isolated)
%    3  Phid        Phid, 热功率W
%    4  To          热媒流出用户时的温度
%    5  Ts          供热温度
%    6  Tr          回热温度


%   additional constants, used to assign/compare values in the BUS_TYPE column
%    1  LOAD     Load bus
%    2  SOURSE   Sourse bus
%    3  NONE     isolated bus
%

%% define bus types
LOAD      = 1;
SOURSE     = 2;
NONE    = 3;

%% define the indices
BUS_I       = 1;    %% bus number (1 to 29997)
BUS_TYPE    = 2;    %% bus type (1 = Load,2 = constant pressure, 3 = sourse,4 = isolated)
PHID          = 3;    %% Fd, real gas flow demand (m^3/h)
TO          = 4;    %% PR, pressure (kPa)
TS       = 5;    
TR       = 6;   


