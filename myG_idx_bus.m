function [LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = myG_idx_bus
%IDX_BUS   Defines constants for named column indices to bus matrix.
%   Example:
%
%   [LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = idx_bus;
%
%   The index, name and meaning of each column of the bus matrix is given
%   below:
%
%   columns 1-13 must be included in input matrix (in case file)
%    1  BUS_I       bus number (positive integer)
%    2  BUS_TYPE    bus type (1 = Load,2 = constant pressure, 3 = sourse,4 = isolated)
%    3  Fd          Fd, real gas flow demand (m^3/h)
%    4  PR          PR, pressure (kPa)
%    5  PRMAX       
%    6  PRMIN      


%   additional constants, used to assign/compare values in the BUS_TYPE column
%    1  LOAD    Load bus
%    2  CONPR      constant Pressure bus
%    3  SOURSE   Sourse bus
%    4  NONE  isolated bus
%

%% define bus types
LOAD      = 1;
CONPR      = 2;
SOURSE     = 3;
NONE    = 4;

%% define the indices
BUS_I       = 1;    %% bus number (1 to 29997)
BUS_TYPE    = 2;    %% bus type (1 = Load,2 = constant pressure, 3 = sourse,4 = isolated)
FD          = 3;    %% Fd, real gas flow demand (m^3/h)
PR          = 4;    %% PR, pressure (kPa)
PRMAX       = 5;    
PRMIN       = 6;   


