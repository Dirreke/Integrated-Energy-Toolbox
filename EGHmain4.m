clear;
clc;
%% 参数输入
% mpc_G=case_G();
mpc_G = case_G();
mpc_E = case_E();
%% 
% function [mpc_E,mpc_G] = EGHmain3(mpc_E,mpc_G)

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

%% 热网参数输入
mpc_test=case_H();
H_nb =  length(mpc_test.bus);
H_nl =  length(mpc_test.branch);


hkk=0.2;%热传导系数
Cp=4200;%热媒的比热容
Cp1=4200;

% 原始算例
% hload=[50000,50000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,1000000];
% 增加热功率
% hload=[50000,100000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,1000000];

hload=[50000,50000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,2000000];
hT0=[40 40 40 40 40 40 40 40 40 40 40 40 40];
HTssource=[100];
Hpipe = mpc_test.branch(:,1:4);
Hpipe(:,4) = Hpipe(:,4)*1e3;% 换算为mm
 
 
As1 = sparse(Hpipe(1:end,1),1:H_nl,-1,H_nb,H_nl) + sparse(Hpipe(1:end,2),1:H_nl,1,H_nb,H_nl);
As1(end,:) = [];  % 删除最后一个还是删除热源？？
%  As1=[1 -1 0 0 0 0 0 0 0 0 0 0 0 0;
%      0 1 -1 -1 0 0 0 0 0 0 0 0 0 0;
%      0 0 1 0 0 0 0 0 0 0 0 0 0 0;
%      0 0 0 1 -1 0 0 0 0 0 0 0 0 -1;
%      0 0 0 0 1 -1 -1 0 0 0 0 0 0 0;
%      0 0 0 0 0 1 0 0 0 0 0 0 0 0;
%      0 0 0 0 0 0 1 -1 -1 0 0 0 0 0;
%      0 0 0 0 0 0 0 1 0 0 0 0 0 0;
%      0 0 0 0 0 0 0 0 1 -1 0 0 0 0;
%      0 0 0 0 0 0 0 0 0 1 -1 -1 0 0;
%      0 0 0 0 0 0 0 0 0 0 1 0 0 0;
%      0 0 0 0 0 0 0 0 0 0 0 1 -1 0;
%      0 0 0 0 0 0 0 0 0 0 0 0 1 1];
  Bh=[0 0 0 0 1 0 1 0 1 1 0 1 1 -1];
[nh,mh]=size(As1);
sh=size(HTssource,2);
lh=size(hload,2);
for i=1:mh
     HK(i)=1.222*10^-9*Hpipe(i,3)/((Hpipe(i,4)/1000)^4);
end
disp('管道摩擦系数矩阵：')
disp(HK);
%初始数据假设 
% Hm=[2 2 2 2 2 2 2 2 2 2 2 2 2 2];
Hm=mpc_test.branch(:,5)';
disp('假设初始管道流量：');
disp(Hm);
HTsload=[100 100 100 100 100 100 100 100 100 100 100 100 100];
disp('假设初始负荷节点供热温度：');
disp(HTsload);
HTrload=[40 40 40 40 40 40 40 40 40 40 40 40 40];
disp('假设初始负荷节点回热温度：');
disp(HTrload);
HTs=[HTsload,HTssource];
HT0=hT0;
Hload=hload;



% hkk=0.2;%热传导系数
% Cp=4200/CP_B;%热媒的比热容
% Cp1=4200;
% 
% % hload=[498120,498120,734617.8]/Xh;
% hload=[498120,498120,734617.8]/Hload_B;
% % hload=[498120,498120,1000000];
% % hload=[498.120,498.120 100];
% hT0=[40 40 40]/T_B;
% HTssource=[100]/T_B;
% Hpipe=[4 1 400 150;
%        1 2 400 150;
%        2 3 400 150;
%        4 3 1000 150];
% As=[1 -1 0 0;
%     0 1 -1 0;
%     0 0 1 1;
%     -1 0 0 -1];
% As1=As(1:3,:);
% Bh=[1 1 1 -1];
% [nh,mh]=size(As);
% sh=size(HTssource,2);
% lh=size(hload,2);
% for i=1:mh
%      HK(i)=1.222*10^-9*Hpipe(i,3)/((Hpipe(i,4)/1000)^4)*HK_B;
% end
% disp('管道摩擦系数矩阵：')
% disp(HK);
% 
% %初始数据假设
% % Hm=[2.716 0.716 2.284];
% % Hm=[2.5 1 2.5];
% Hm=[2 2 2 2]/Hm_B;
% % Hm=[1 1 1 1]/Hm_B;
% disp('假设初始管道流量：');
% disp(Hm);
% HTsload=[100 100 100]/T_B;
% disp('假设初始负荷节点供热温度：');
% disp(HTsload);
% HTrload=[40 40 40]/T_B;
% disp('假设初始负荷节点回热温度：');
% disp(HTrload);
% HTs=[HTsload,HTssource];
% HT0=hT0;
% Hload=hload;

%%%%%%%%%%%耦合设备转换
hT0source=40/T_B;
% PG=Cp*(Hm(1)+Hm(4))*(HTssource-hT0source);
PG=Cp*Hm(1)*(HTssource-hT0source);




%% 计算不平衡量
% P(30)=PG/cm;
mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm*mpc_E.baseMVA; %CHP
% mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm/10; %CHP

% Gload(3)=PG/(cm*ne);
mpc_G.bus(5,3)=PG/(cm*ne);

% 计算电网不平衡量
%$%PQ%
[dP,dQ]=myEUnbalanced(mpc_E);

%计算气网不平衡量
[mpc_G,dG] = myGUnbalanced(mpc_G);

% 计算热网不平衡量
[Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
[dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
%整合为一整个不平衡量
dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
disp('整个的不平衡量：');
disp(dEGH);

%% 牛拉法大循环开始
for round=1:Tmax
    fprintf('第%d次迭代\n',round);
    
    %%%%%%%%%%%耦合设备转换
    hT0source=40/T_B;
%     PG=Cp*(Hm(1)+Hm(4))*(HTssource-hT0source);
    PG=Cp*Hm(1)*(HTssource-hT0source);
%     P(30)=(PG/cm);
    mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm*mpc_E.baseMVA; %CHP
%     mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm/10; %CHP
%     Gload(3)=PG/(cm*ne);
    mpc_G.bus(5,3)=PG/(cm*ne);

    % 计算雅克比矩阵
    %     求解Jee
    Jee = -mymakeJac(mpc_E);%PQ 顺序不同%$%
    
    %     求解Jhh
    Jhh = HJacobi(nh,mh,lh,Cp,HTsload,HTs,hT0,As1,Bh,HK,Hm,Cs,Cr,Hpipe,hk);
    
    %     求解Jgg
    Jgg = myG_makeJac(mpc_G);
    
    % 求解Jeh
    Jeh=zeros(E_n_PQ+E_nb-1,nh+2*lh+1);
%     Jeh(30,1)=-Cp*Hm(4)*(HTssource-hT0source)/cm;
%     Jeh(30,4)=-Cp*Hm(1)*(HTssource-hT0source)/cm;
    Jeh(30,1)=-Cp*(HTssource-hT0source)/cm;
    disp('Jeh:');
    disp(Jeh);
    [load,~,~] = myG_bustypes(mpc_G.bus);
     G_test = length(load);
     %%%%???
    % 求解Jeg
    Jeg=zeros(E_n_PQ+E_nb-1,G_test);

    % 求解Jgh
    Jgh=zeros(G_test,nh+2*lh+1);
%     Jgh(3,1)=Cp*Hm(4)*(HTssource-hT0source)/(cm*ne);
%     Jgh(3,4)=Cp*Hm(1)*(HTssource-hT0source)/(cm*ne);
    Jgh(3,1)=Cp*(HTssource-hT0source)/(cm*ne);
    disp('Jgh');
    disp(Jgh);
   
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
    disp('JEGH');
    disp(JEGH);
    %%%???
%     con(round) = cond(JEGH);
%     con1=max(con);
    
    % 求解修正量
    [dtheta,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(E_nb,E_n_PQ,mh,lh,mpc_E.bus(:,8)',dEGH,JEGH,G_test);
    
%     修正状态量
%     修正电网状态量
%     U
    mpc_E.bus(:,8) = mpc_E.bus(:,8)+dU';
% 	theta
    mpc_E.bus(:,9) = mpc_E.bus(:,9)+dtheta'/pi*180;
% 	disp('节点电压幅值：');
% 	disp(U);
% 	disp('节点电压相角：');
% 	disp(rad2deg(theta));
    % 修正热网状态量
    Hm=Hm+dHm;
    HTsload=HTsload+dHTsload;
    HTrload=HTrload+dHTrload;
    disp('修正后的管道流量：');
    disp(Hm);
    disp('修正后的节点供热温度：');
    disp(HTsload);
    disp('修正后的节点回热温度：');
    disp(HTrload);
    % 修正气网状态量
    temp = mpc_G.bus(:,4).^2 + dppp';
    if temp < 0
        error('气网不收敛');
    end
    mpc_G.bus(:,4) = real(sqrt(temp));
%     Gpi2=Gpi2+dppp;
%     disp('修正后的节点气压值');
%     disp(Gpi2);
    
    % 判断方向
%     [As1,Hpipe,Hm] = panduan(mh,Hpipe,As1,Hm);
        
    % 求解不平衡量
    % 计算电网不平衡量
    [dP,dQ]=myEUnbalanced(mpc_E );

    %计算气网不平衡量
%     [Gload,Gpi2,dpi2,Ag,Gpipe,Ag2,dGQ,dG] = GUnbalanced(0,Gpi2,Ag,Gpipe,G_nl,zg,0,Gload,gas);
    [mpc_G,dG] = myGUnbalanced(mpc_G);
    % 计算热网不平衡量
    [Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
    [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
    %整合为一整个不平衡量
    dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
    disp('整个的不平衡量：');
    disp(dEGH);

    % 判断收敛
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        break;
    end
end
%% 迭代结束，判断收敛，输出结果

 mpc_E = myupdate_mpc_E(mpc_E);
%% test
% PQout(1) = mpc_E.gen(10,2);
% PQout(2) = mpc_E.gen(10,3);

PQout(1) = mpc_E.gen(1,2);
PQout(2) = mpc_E.gen(1,3);

if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
    disp('计算收敛');
else
    disp('计算不收敛');
end
disp('************最终结果*************');
fprintf('迭代总次数：%d\n', round);
disp('***电网计算结果：')
% disp('节点电压幅值：');
% disp(U);
% disp('节点电压相角：');
% disp(rad2deg(theta));
% disp('有功计算结果：');
% disp(Pi);
% disp('无功计算结果：');
% disp(Qi);
disp('***热网计算结果：');
disp('负荷节点供热温度:');
disp(HTsload);
disp('负荷节点回热温度:');
disp(HTrload);
disp('热源回热温度:');
disp(hT0source);
disp('热网管道流量：');
disp(Hm);
disp('***气网计算结果：');
disp('天然气网络各节点压力：');
Gpi=mpc_G.bus(:,4);
disp(Gpi);
% disp('天然气网络各管道流量：');
% disp(dGQ);
% disp('天然气网络负荷：');
% disp(Gload);

toc;

