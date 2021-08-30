% fmincon
% gas = case_G;
% [mpc,dG] = myGUnbalanced(mpc);
% dG = test_fun(X)
% fmincon('test_fun',[4.5;4.5;4.5;4.5;4.5;4.5],[],[],[],[],[0;0;0;0;0;0],[5;5;5;5;5;5])
% fmincon('test_fun',[4;4;4;4;4;4],[],[],[],[],[0;0;0;0;0;0],[5;5;5;5;5;5])
% fmincon('test_fun',[5;5;5;5;5;5],[],[],[],[],[0;0;0;0;0;0],[5;5;5;5;5;5])

%%% if 0 suijizhi %%%???
mpc = case_G;
% mpc.bus(3:end,4) = [4.9 ;4.8;4.7;4.6;4.5;4.4];
mpc.bus(3:end,4) = [5;5;5;5;5];
tic
result = fmincon(@(X)test_fun(mpc,X),[4.9 ;4.8;4.7;4.6;4.5],[],[],[],[],[0;0;0;0;0;0],[5;5;5;5;5;5])
toc
tic
mpc = myG_runef(mpc);
toc
mpc.bus(:,4);

