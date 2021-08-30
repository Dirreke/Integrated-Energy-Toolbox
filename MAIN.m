% V2 = [0.9820,0];
% V3 = [0.9820,0];
clear;clc;
mpc_G1 = case_G();
mpc_E1 = case39();
mpc_H1 = case_H7();
mpc_CHP1 = [30,5]; 
mpc_G2 = case_G();
mpc_E2 = case39();
mpc_H2 = case_H7();
mpc_CHP2 = [30,5]; 
mpc_G3 = case_G9();
mpc_E3 = case118();
mpc_H3 = case_H();
mpc_CHP3 = [30,5]; 
V1 = [0.9820,0];
V2 = [1,0];
k = 1;
% while 1
%     %% test
% 
%     mpc_E1.gen(1,6) = V1(1);
%     mpc_E1.bus(1,9) = V1(2);
%     mpc_E2.gen(1,6) = V2(1);
%     mpc_E2.bus(1,9) = V2(2);
%     %%
%     [mpc_E1,mpc_G1,~] = EGHmain3(mpc_E1,mpc_G1,mpc_H1);
%     [mpc_E2,mpc_G2,~] = EGHmain3(mpc_E2,mpc_G2,mpc_H2);
%     %%
%     Tcase = loadcase('case3T.m');
%     Tcase.bus(2,3:4) = mpc_E1.gen(1,2:3);
%     Tcase.bus(2,3:4) = mpc_E2.gen(1,2:3);
%     Tcase = runpf(Tcase);
%     V1 - Tcase.bus(2,8:9)
%     V2 - Tcase.bus(3,8:9)
%     V1 = 0.5*(V1 + Tcase.bus(2,8:9));
%     V2 = 0.5*(V2 + Tcase.bus(3,8:9));
%     k = k+1;
%     
% end
MAX = 1000;
e1 = zeros(MAX,2);
e2 = zeros(MAX,2);

while 1
    %% test

    mpc_E1.gen(1,6) = V1(1);
    mpc_E1.bus(1,9) = V1(2);

    mpc_E2.gen(1,6) = V2(1);
    mpc_E2.bus(1,9) = V2(2);
    
    %%
    [mpc_E1,mpc_G1,~] = myEGHmain3(mpc_E1,mpc_G1,mpc_H1,mpc_CHP1,1);
    [mpc_E2,mpc_G2,~] = myEGHmain3(mpc_E2,mpc_G2,mpc_H2,mpc_CHP2);
    %%
    Tcase = loadcase('case3T.m');
    mpc_E3.bus(28,3:4) = mpc_E1.gen(1,2:3);
    mpc_E3.bus(29,3:4) = mpc_E2.gen(1,2:3);
    [mpc_E3,mpc_G3,~] = myEGHmain3(mpc_E3,mpc_G3,mpc_H3,mpc_CHP3);
    
    e1(k,:) = V1 - mpc_E3.bus(2,8:9);
    e2(k,:) = V2 - mpc_E3.bus(3,8:9);
    if (e1(k) <1e-4) & (e2(k) <1e-4)
        disp(k);
        break
    end
    V1 = 0.5*(V1 + mpc_E3.bus(2,8:9));
    V2 = 0.5*(V2 + mpc_E3.bus(3,8:9));
    k = k+1;
    
end


figure
hold on 
grid on 
plot(1:10,e1(1:10,1))
plot(1:10,e2(1:10,1))
ylabel('电压幅值修正量(pu)');
xlabel('迭代次数');
title('电压幅值迭代修正量');
figure
hold on 
grid on
plot(1:10,e1(1:10,2))
plot(1:10,e2(1:10,2))
ylabel('电压相位修正量(deg)');
xlabel('迭代次数');
title('电压相位迭代修正量');
