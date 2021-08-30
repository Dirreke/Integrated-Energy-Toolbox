function [TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch
%IDX_BUS   Defines constants for named column indices to bus matrix.
%   Example:
%
%   [TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch
%
%   The index, name and meaning of each column of the bus matrix is given
%   below:
%
%   columns 1-5 must be included in input matrix (in case file)
%    1  FBUS       
%    2  TBUS       
%    3  LENGTH     m    
%    4  DIAMETER      m
%    5  BRANCH_TYPE    树枝1/连枝2/压缩机3 compressor

% 1 TREE
% 2 CONNECT
% 3 COMPRESSOR


%% define the indices
FBUS         = 1;       
TBUS         = 2;
LENGTH       = 3; 
DIAMETER     = 4;
BRANCH_TYPE  = 5;
%% 
TREE        = 1;
CONNECT     = 2;
COMPRESSOR  = 3;
