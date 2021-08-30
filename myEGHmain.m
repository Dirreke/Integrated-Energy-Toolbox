% clear;
% clc;
% %% 参数输入
% % mpc_G=case_G();
% mpc_G = case_G9();
% mpc_E = case_E();
% mpc_H = case_H();
% mpc_CHP = [30,5];
% shuchu = 1;
% mpc_G = case_G9();
% mpc_E = case_E();
% mpc_H = case_H();
%% 
function [mpc_E,mpc_G,mpc_H] = myEGHmain(mpc_E,mpc_G,mpc_H,mpc_CHP,shuchu)
if nargin < 5
    shuchu = 0;
end
%% start
% mpc_CHP = [30,5];
tic;
%%% 设置基准值
Hload_B=1;
%非线性，不要动了
Hm_B=1;
%
T_B=1;
CP_B=1;
HK_B=1;

G_B=1;
Gpi_B=1;
Kg_B=1;

%% 迭代参数设置
Elimit=1*10^-5;
Glimit=10;
Hlimit=1*10^-1;
Tmax=100;
%% CHP机组参数
% cm=823200;
cm=755528;
ne=0.0015;

%% 电网常数
% mpc_E = loadcase('case_E.m');
E_nb = length(mpc_E.bus);
E_n_PQ = sum(mpc_E.bus(:,2) == 1); % PQ 节点个数

[E_ref, E_pv, E_pq] = bustypes(mpc_E.bus, mpc_E.gen);
E_pvpq = find(mpc_E.bus(:, 1) ~= E_ref);  
%% 热网参数输入

H_nb =  length(mpc_H.bus);
H_nl =  length(mpc_H.branch);

hkk=0.2;%热传导系数
Cp=4200;%热媒的比热容

%初始数据假设 
[H_load,H_sourse] = myH_bustypes(mpc_H.bus);
Hm=mpc_H.branch(:,5)';
hT0=mpc_H.bus(H_load,4)';
HTssource=[100];
HTrload=mpc_H.bus(H_load,6)';
HT0=hT0;

sh=size(HTssource,2);
[As1,Bh] = myH_makeABmatrix(mpc_H);
lh=length(H_load);
[nh,mh]=size(As1);

hT0source=40/T_B;

%% 更新CHP
PG = Cp*mpc_H.branch(1,5)*(HTssource-hT0source);%%%???
mpc_E.gen(mpc_E.gen(:,1)==mpc_CHP(1),2) = PG/cm*mpc_E.baseMVA; %CHP
mpc_G.bus(mpc_G.bus(:,1)==mpc_CHP(2),3) = PG/(cm*ne);
%% 计算不平衡量
% 计算电网不平衡量
[dP,dQ]=myEUnbalanced(mpc_E);%%%???顺序

%计算气网不平衡量
[mpc_G,dG] = myGUnbalanced(mpc_G);

% 计算热网不平衡量
[Cs,bs,Cr,br,hk,hT0source] = myHUnbalanced(mh,lh,sh,hkk,HTssource,hT0,HTrload,Cp,mpc_H);
[dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc_H);
%整合为一整个不平衡量
dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];


%% 牛拉法大循环开始
for round=1:Tmax
%     fprintf('第%d次迭代\n',round);
    %% temp CHP 
    %%%%%%%%%%%耦合设备转换
    hT0source=40/T_B;
    PG=Cp*mpc_H.branch(1,5)*(HTssource-hT0source);
    mpc_E.gen(mpc_E.gen(:,1)==mpc_CHP(1),2) = PG/cm*mpc_E.baseMVA; %CHP
    mpc_G.bus(mpc_G.bus(:,1)==mpc_CHP(2),3)=PG/(cm*ne);
    % 计算雅克比矩阵
    %     求解Jee
    Jee = -mymakeJac(mpc_E);%PQ 顺序不同%$%
    
    %     求解Jhh
    Jhh = HJacobi(nh,mh,lh,Cp,hT0,Cs,Cr,hk,mpc_H);
    
    %     求解Jgg
    Jgg = myG_makeJac(mpc_G);
    
    % 求解Jeh
    huilugeshu = size(Bh,1);
    temp = mpc_E.bus(:,1)==mpc_CHP(1);
    Jeh=zeros(E_n_PQ+E_nb-1,nh+2*lh+huilugeshu);
    Jeh(temp,1)=-Cp*(HTssource-hT0source)/cm;

    [G_load,~,~] = myG_bustypes(mpc_G.bus);
     G_test = length(G_load);
     %%%%???
    
    % 求解Jgh
    G_nb = size(mpc_G.bus,1);
    temp2 = (1:G_nb)';
    temp2 = temp2(G_load,:);
    temp2 = temp2 == mpc_CHP(2);
    Jgh=zeros(G_test,nh+2*lh+huilugeshu);
    Jgh(temp2,1)=Cp*(HTssource-hT0source)/(cm*ne);
    
    % 求解Jeg
    Jeg=zeros(E_n_PQ+E_nb-1,G_test);   
    % 求解Jge
    Jge=zeros(G_test,E_n_PQ+E_nb-1);

    % 求解Jhe
    Jhe=zeros(mh+2*lh,E_n_PQ+E_nb-1);

    % 求解Jhg
    Jhg=zeros(mh+2*lh,G_test);
    
    % 合成整个的雅克比矩阵
    JEGH=[Jee,Jeh,Jeg;
          Jhe,Jhh,Jhg;
          Jge,Jgh,Jgg];
    
    % 求解修正量
    [dtheta,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(E_nb,E_n_PQ,mh,lh,mpc_E.bus(E_pq,8)',dEGH,JEGH,G_test);
    
%%     修正状态量
%     修正电网状态量
    % U
    mpc_E.bus(E_pq,8) = mpc_E.bus(E_pq,8)+dU;
  	% theta
    mpc_E.bus(E_pvpq,9) = mpc_E.bus(E_pvpq,9)+dtheta/pi*180;

    % 修正热网状态量
    mpc_H.branch(:,5) = mpc_H.branch(:,5)+dHm;
    mpc_H.bus(H_load,5) = mpc_H.bus(H_load,5)+ dHTsload;
    HTrload=HTrload+dHTrload';
    % 修正气网状态量
    temp = mpc_G.bus(G_load,4).^2 + dppp;
    if temp < 0
        error('气网不收敛');
    end
    mpc_G.bus(G_load,4) = real(sqrt(temp));
        
    % 求解不平衡量
    % 计算电网不平衡量
    [dP,dQ]=myEUnbalanced(mpc_E);

    %计算气网不平衡量
    [mpc_G,dG] = myGUnbalanced(mpc_G);
    % 计算热网不平衡量
    [Cs,bs,Cr,br,hk,hT0source] = myHUnbalanced(mh,lh,sh,hkk,HTssource,hT0,HTrload,Cp,mpc_H);
    [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc_H);
    %整合为一整个不平衡量
    dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
    shouji(:,round)=dEGH;
    % 判断收敛
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        break;
    end
end
%% 迭代结束，判断收敛，输出结果

mpc_E = myupdate_mpc_E(mpc_E);

timeall = toc;

%% print
if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
else
    disp('计算不收敛');
end
if shuchu == 1
    fprintf('历时 %f 秒\n',timeall);
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        disp('计算收敛');
    else
        disp('计算不收敛');
    end
    disp('************最终结果*************');
    fprintf('迭代总次数：%d\n', round);
    disp('***电网计算结果：')
    disp('节点电压幅值：');
    disp(mpc_E.bus(:,8)');
    disp('节点电压相角：');
    disp(mpc_E.bus(:,9)');
%     disp('有功计算结果：');
%     disp(Pi);
%     disp('无功计算结果：');
%     disp(Qi);
    disp('***热网计算结果：');
    disp('负荷节点供热温度:');
    disp(mpc_H.bus(H_load,5)');
    disp('负荷节点回热温度:');
    disp(HTrload);
    disp('热源回热温度:');
    disp(hT0source);
    disp('热网管道流量：');
    disp(mpc_H.branch(:,5)');
    disp('***气网计算结果：');
    disp('天然气网络各节点压力：');
    Gpi=mpc_G.bus(:,4);
    disp(Gpi);
    As1*mpc_H.branch(:,5)
    % disp('天然气网络各管道流量：');
    % disp(dGQ);
    % disp('天然气网络负荷：');
    % disp(Gload);
end
%% plot 
figure
hold on
for k =  1:60
    plot(1:10,shouji(k,1:10))
end
xlabel('迭代次数');
ylabel('偏差量')
title('部分数据迭代偏差量');
grid on;
