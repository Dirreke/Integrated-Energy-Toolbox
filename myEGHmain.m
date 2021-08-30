% clear;
% clc;
% %% ��������
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
%%% ���û�׼ֵ
Hload_B=1;
%�����ԣ���Ҫ����
Hm_B=1;
%
T_B=1;
CP_B=1;
HK_B=1;

G_B=1;
Gpi_B=1;
Kg_B=1;

%% ������������
Elimit=1*10^-5;
Glimit=10;
Hlimit=1*10^-1;
Tmax=100;
%% CHP�������
% cm=823200;
cm=755528;
ne=0.0015;

%% ��������
% mpc_E = loadcase('case_E.m');
E_nb = length(mpc_E.bus);
E_n_PQ = sum(mpc_E.bus(:,2) == 1); % PQ �ڵ����

[E_ref, E_pv, E_pq] = bustypes(mpc_E.bus, mpc_E.gen);
E_pvpq = find(mpc_E.bus(:, 1) ~= E_ref);  
%% ������������

H_nb =  length(mpc_H.bus);
H_nl =  length(mpc_H.branch);

hkk=0.2;%�ȴ���ϵ��
Cp=4200;%��ý�ı�����

%��ʼ���ݼ��� 
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

%% ����CHP
PG = Cp*mpc_H.branch(1,5)*(HTssource-hT0source);%%%???
mpc_E.gen(mpc_E.gen(:,1)==mpc_CHP(1),2) = PG/cm*mpc_E.baseMVA; %CHP
mpc_G.bus(mpc_G.bus(:,1)==mpc_CHP(2),3) = PG/(cm*ne);
%% ���㲻ƽ����
% ���������ƽ����
[dP,dQ]=myEUnbalanced(mpc_E);%%%???˳��

%����������ƽ����
[mpc_G,dG] = myGUnbalanced(mpc_G);

% ����������ƽ����
[Cs,bs,Cr,br,hk,hT0source] = myHUnbalanced(mh,lh,sh,hkk,HTssource,hT0,HTrload,Cp,mpc_H);
[dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc_H);
%����Ϊһ������ƽ����
dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];


%% ţ������ѭ����ʼ
for round=1:Tmax
%     fprintf('��%d�ε���\n',round);
    %% temp CHP 
    %%%%%%%%%%%����豸ת��
    hT0source=40/T_B;
    PG=Cp*mpc_H.branch(1,5)*(HTssource-hT0source);
    mpc_E.gen(mpc_E.gen(:,1)==mpc_CHP(1),2) = PG/cm*mpc_E.baseMVA; %CHP
    mpc_G.bus(mpc_G.bus(:,1)==mpc_CHP(2),3)=PG/(cm*ne);
    % �����ſ˱Ⱦ���
    %     ���Jee
    Jee = -mymakeJac(mpc_E);%PQ ˳��ͬ%$%
    
    %     ���Jhh
    Jhh = HJacobi(nh,mh,lh,Cp,hT0,Cs,Cr,hk,mpc_H);
    
    %     ���Jgg
    Jgg = myG_makeJac(mpc_G);
    
    % ���Jeh
    huilugeshu = size(Bh,1);
    temp = mpc_E.bus(:,1)==mpc_CHP(1);
    Jeh=zeros(E_n_PQ+E_nb-1,nh+2*lh+huilugeshu);
    Jeh(temp,1)=-Cp*(HTssource-hT0source)/cm;

    [G_load,~,~] = myG_bustypes(mpc_G.bus);
     G_test = length(G_load);
     %%%%???
    
    % ���Jgh
    G_nb = size(mpc_G.bus,1);
    temp2 = (1:G_nb)';
    temp2 = temp2(G_load,:);
    temp2 = temp2 == mpc_CHP(2);
    Jgh=zeros(G_test,nh+2*lh+huilugeshu);
    Jgh(temp2,1)=Cp*(HTssource-hT0source)/(cm*ne);
    
    % ���Jeg
    Jeg=zeros(E_n_PQ+E_nb-1,G_test);   
    % ���Jge
    Jge=zeros(G_test,E_n_PQ+E_nb-1);

    % ���Jhe
    Jhe=zeros(mh+2*lh,E_n_PQ+E_nb-1);

    % ���Jhg
    Jhg=zeros(mh+2*lh,G_test);
    
    % �ϳ��������ſ˱Ⱦ���
    JEGH=[Jee,Jeh,Jeg;
          Jhe,Jhh,Jhg;
          Jge,Jgh,Jgg];
    
    % ���������
    [dtheta,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(E_nb,E_n_PQ,mh,lh,mpc_E.bus(E_pq,8)',dEGH,JEGH,G_test);
    
%%     ����״̬��
%     ��������״̬��
    % U
    mpc_E.bus(E_pq,8) = mpc_E.bus(E_pq,8)+dU;
  	% theta
    mpc_E.bus(E_pvpq,9) = mpc_E.bus(E_pvpq,9)+dtheta/pi*180;

    % ��������״̬��
    mpc_H.branch(:,5) = mpc_H.branch(:,5)+dHm;
    mpc_H.bus(H_load,5) = mpc_H.bus(H_load,5)+ dHTsload;
    HTrload=HTrload+dHTrload';
    % ��������״̬��
    temp = mpc_G.bus(G_load,4).^2 + dppp;
    if temp < 0
        error('����������');
    end
    mpc_G.bus(G_load,4) = real(sqrt(temp));
        
    % ��ⲻƽ����
    % ���������ƽ����
    [dP,dQ]=myEUnbalanced(mpc_E);

    %����������ƽ����
    [mpc_G,dG] = myGUnbalanced(mpc_G);
    % ����������ƽ����
    [Cs,bs,Cr,br,hk,hT0source] = myHUnbalanced(mh,lh,sh,hkk,HTssource,hT0,HTrload,Cp,mpc_H);
    [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,hT0,Cs,bs,Cr,HTrload,br,mpc_H);
    %����Ϊһ������ƽ����
    dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
    shouji(:,round)=dEGH;
    % �ж�����
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        break;
    end
end
%% �����������ж�������������

mpc_E = myupdate_mpc_E(mpc_E);

timeall = toc;

%% print
if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
else
    disp('���㲻����');
end
if shuchu == 1
    fprintf('��ʱ %f ��\n',timeall);
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        disp('��������');
    else
        disp('���㲻����');
    end
    disp('************���ս��*************');
    fprintf('�����ܴ�����%d\n', round);
    disp('***������������')
    disp('�ڵ��ѹ��ֵ��');
    disp(mpc_E.bus(:,8)');
    disp('�ڵ��ѹ��ǣ�');
    disp(mpc_E.bus(:,9)');
%     disp('�й���������');
%     disp(Pi);
%     disp('�޹���������');
%     disp(Qi);
    disp('***������������');
    disp('���ɽڵ㹩���¶�:');
    disp(mpc_H.bus(H_load,5)');
    disp('���ɽڵ�����¶�:');
    disp(HTrload);
    disp('��Դ�����¶�:');
    disp(hT0source);
    disp('�����ܵ�������');
    disp(mpc_H.branch(:,5)');
    disp('***������������');
    disp('��Ȼ��������ڵ�ѹ����');
    Gpi=mpc_G.bus(:,4);
    disp(Gpi);
    As1*mpc_H.branch(:,5)
    % disp('��Ȼ��������ܵ�������');
    % disp(dGQ);
    % disp('��Ȼ�����縺�ɣ�');
    % disp(Gload);
end
%% plot 
figure
hold on
for k =  1:60
    plot(1:10,shouji(k,1:10))
end
xlabel('��������');
ylabel('ƫ����')
title('�������ݵ���ƫ����');
grid on;
