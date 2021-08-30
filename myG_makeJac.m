function Jgg = myG_makeJac(mpc)

[LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = myG_idx_bus;
[TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch;
% gen = mpc.gen;
branch = mpc.branch;
bus = mpc.bus;

%% contents
nb = size(bus, 1);
nl = size(branch,1);
%% PSquare
PSquare = zeros(max(bus(:,BUS_I)),1);
temp = bus(:,PR).^2;
for k = 1:length(PSquare)
    PSquare(k) = temp(bus(:,BUS_I) == k);
end
%% initial

Kg_B = 1;%%%???

[~,~, compressor,~] = myG_branchtypes(branch);
[load,~,~] = myG_bustypes(bus);
Kr = 70840/Kg_B./sqrt(branch(:,LENGTH));
Kr1 = Kr;
Kr1(compressor) = [];


%% 重新计算气网不平衡量
Ag1 = sparse(branch(1:end,1),1:nl,-1,nb,nl) + ...
        sparse(branch(1:end,2),1:nl,1,nb,nl);
Ag1(:,compressor) = [];
dPSquare1 = -Ag1' * PSquare;
% dPSquare1
temp = dPSquare1 == 0;
dPSquare1(temp) = 0.1*rand(sum(temp),1);%%%???
Fbranch1 = Kr1 .* sqrt(dPSquare1);

%     求解Jgg
% for i=1:G_nl - zg
%     D(i,i)=Fbranch1(i)/(2*dPSquare1(i));
% end
D = diag(Fbranch1./(2.*dPSquare1));
% disp(D);
Ag2 = Ag1(load,:);%% 恒压不参与运算
Jgg=-Ag2*D*Ag2';




end