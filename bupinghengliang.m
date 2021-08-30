function [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc)

bus = mpc.bus;
branch = mpc.branch;
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
[load,sourse] = myH_bustypes(bus);
HTsload = bus(load,TS)';
Hm = branch(:,FBRANCH);
[As1,Bh] = myH_makeABmatrix(mpc);
%% ���㲻ƽ����
% ����ȹ��ʲ�ƽ����
dP_H=((Cp.*As1*Hm)'*diag(HTsload-hT0))'-mpc.bus(load,PHID);
% ���ѹͷ��ʧ��ƽ����
HK = myH_makeHK(mpc);
dp_H=Bh.*HK*(Hm).^2;

% ��⹩���¶Ȳ�ƽ����
dTs=Cs*HTsload'-bs;

% �������¶Ȳ�ƽ����
dTr=Cr*HTrload'-br;

end

