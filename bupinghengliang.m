function [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc)

bus = mpc.bus;
branch = mpc.branch;
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
[load,sourse] = myH_bustypes(bus);
HTsload = bus(load,TS)';
Hm = branch(:,FBRANCH);
[As1,Bh] = myH_makeABmatrix(mpc);
%% 计算不平衡量
% 求解热功率不平衡量
dP_H=((Cp.*As1*Hm)'*diag(HTsload-hT0))'-mpc.bus(load,PHID);
% 求解压头损失不平衡量
HK = myH_makeHK(mpc);
dp_H=Bh.*HK*(Hm).^2;

% 求解供热温度不平衡量
dTs=Cs*HTsload'-bs;

% 求解回热温度不平衡量
dTr=Cr*HTrload'-br;

end

