function [tree,connect, compressor,after_compressor] = myG_branchtypes(branch)


%% constants
[TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch;



%% form index lists for slack, PV, and PQ buses
tree = find(branch(:, BRANCH_TYPE) == TREE );   %% reference bus index
connect  = find(branch(:, BRANCH_TYPE) == CONNECT );   %% PV bus indices
compressor  = find(branch(:, BRANCH_TYPE) == COMPRESSOR);   %% PQ bus indices

len = length(compressor);
after_compressor = zeros(len,2);

for k = 1:len
     temp = find(branch(:,FBUS) == branch(compressor(k),TBUS));
     temp2 = find(branch(:,TBUS) == branch(compressor(k),TBUS) & branch(:,FBUS) ~= branch(compressor(k),FBUS));
     if (length(temp)+length(temp2)~=1 )
         error('压缩机后支路不唯一或缺少')
     end
     if(isempty(temp))
         after_compressor(k,:) = [temp2,1];
     else
         after_compressor(k,:) = [temp,2];%%%???;
     end
end

%% after compressor
end