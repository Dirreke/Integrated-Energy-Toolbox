function dG = test_fun(mpc,X)

mpc.bus(3:end,4) = X;
%% contents
[~,dG] = myGUnbalanced(mpc);

dG = sum(dG.^2);
end

