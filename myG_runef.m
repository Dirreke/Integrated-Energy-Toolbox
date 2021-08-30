function mpc = myG_runef(mpc)
% [LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = myG_idx_bus;
% [TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch;
% gen = mpc.gen;
% branch = mpc.branch;
% bus = mpc.bus;
% [~,~, compressor,after_compressor] = myG_branchtypes(branch);
[load,~,~] = myG_bustypes(mpc.bus);
% qitachuzhi = 1;
% if(qitachuzhi)
%     result = fmincon(@(X)test_fun(mpc,X),[4.3113;4.2973;4.2229;4.2347;4.2177;4.2160],[],[],[],[],[0;0;0;0;0;0],[5;5;5;5;5;5]);
%     mpc.bus(3:end,4) = result;
% end

for k = 1:1000
    
[mpc,dG] = myGUnbalanced(mpc);
Jgg = myG_makeJac(mpc);
dppp = -(Jgg)\dG;
temp = mpc.bus(load,4).^2 + dppp;
if temp < 0
    error('气网不收敛');
end
mpc.bus(load,4) = real(sqrt(temp));
if(abs(dppp)<0.001)
    break
    
end
end
mpc.bus(:,4)
end
