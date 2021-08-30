function HK = myH_makeHK(mpc)
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
% [LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
bus = mpc.bus;
branch = mpc.branch;

tempK=0.0001;
rho =1000;
g=9.8;
mu = 0.2838*10^-3;
Re_QM = 4./(branch(:,DIAMETER).*pi.*mu).*branch(:,FBRANCH);
HK_f = 0.11.*(tempK./branch(:,DIAMETER)+68./Re_QM);
% HK_f = 64./Re_QM;
HK = 8*HK_f.*branch(:,LENGTH)./branch(:,DIAMETER).^5./(g.*pi^2.*rho^2);
HK = HK';
end