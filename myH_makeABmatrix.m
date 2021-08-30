function [As1,Bh] = myH_makeABmatrix(mpc,full)
if nargin < 2
    full = 0;
end
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
%%%???未考虑孤岛，孤路
bus = mpc.bus;
branch = mpc.branch;
nb = length(bus);
nl = length(branch);

CB(1) = branch(1,FBUS);
T = zeros(1,size(branch,1));
% temp_line = 1;
k = 1;
kkk = 1;
while 1
    flag = 0;
    temp_line = [];
    temp_line1 = [];
    while kkk<=k
        temp_line = [temp_line;find(branch(:,FBUS) == CB(kkk))];
        temp_line1 = [temp_line1;find(branch(:,TBUS) == CB(kkk))];
        kkk = kkk+1;
    end
    for kk = 1:length(temp_line)
        if isempty(find(CB == branch(temp_line(kk),TBUS),1))
            CB(k+1) = branch(temp_line(kk),TBUS);
            CL(k) = temp_line(kk);
            T(temp_line(kk)) = 1;
            flag = 1;
            k = k+1;
        end
    end
    for kk = 1:length(temp_line1)
        if isempty(find(CB == branch(temp_line1(kk),FBUS),1))
            CB(k+1) = branch(temp_line1(kk),FBUS);
            CL(k) = temp_line1(kk);
            T(temp_line1(kk)) = 1;
            flag = 1;
            k = k+1;
        end
    end
    if(flag == 0)
        break
    end
end
As = sparse(branch(1:end,1),1:nl,-1,nb,nl) + sparse(branch(1:end,2),1:nl,1,nb,nl);
As1 = As;
As1(end,:) = [];  % 删除最后一个还是删除热源？？
At = As1(:,T==1);
Al = As1;
Al(:,T==1) = [];

Bh = ones(nl-nb+1,nl);
Bh(:,T==1)=(-At^-1*Al)';
if full == 1
    As1 = As;
end

end