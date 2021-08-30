function [FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch
%IDX_BUS   Defines constants for named column indices to bus matrix.
%   Example:
%
%   [FBUS, TBUS, LENGTH, DIAMETER, Fbranch] = myH_idx_branch
%
%   The index, name and meaning of each column of the bus matrix is given
%   below:
%
%   columns 1-5 must be included in input matrix (in case file)
%    1  FBUS       
%    2  TBUS       
%    3  LENGTH     m    
%    4  DIAMETER      m
%    5  F    流量 kg/s

% 1 TREE
% 2 CONNECT
% 3 COMPRESSOR


%% define the indices
FBUS         = 1;       
TBUS         = 2;
LENGTH       = 3; 
DIAMETER     = 4;
FBRANCH      = 5;
%% 
% TREE        = 1;
% CONNECT     = 2;
% COMPRESSOR  = 3;
