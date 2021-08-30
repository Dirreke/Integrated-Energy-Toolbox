clear;
clc;
%% ��������
% mpc_G=case_G();
mpc_G = case_G();
mpc_E = case_E();
%% 
% function [mpc_E,mpc_G] = EGHmain3(mpc_E,mpc_G)

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

%% ������������
mpc_test=case_H();
H_nb =  length(mpc_test.bus);
H_nl =  length(mpc_test.branch);


hkk=0.2;%�ȴ���ϵ��
Cp=4200;%��ý�ı�����
Cp1=4200;

% ԭʼ����
% hload=[50000,50000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,1000000];
% �����ȹ���
% hload=[50000,100000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,1000000];

hload=[50000,50000,50000,50000,100000,50000,10000,50000,80000,100000,50000,50000,2000000];
hT0=[40 40 40 40 40 40 40 40 40 40 40 40 40];
HTssource=[100];
Hpipe = mpc_test.branch(:,1:4);
Hpipe(:,4) = Hpipe(:,4)*1e3;% ����Ϊmm
 
 
As1 = sparse(Hpipe(1:end,1),1:H_nl,-1,H_nb,H_nl) + sparse(Hpipe(1:end,2),1:H_nl,1,H_nb,H_nl);
As1(end,:) = [];  % ɾ�����һ������ɾ����Դ����
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
disp('�ܵ�Ħ��ϵ������')
disp(HK);
%��ʼ���ݼ��� 
% Hm=[2 2 2 2 2 2 2 2 2 2 2 2 2 2];
Hm=mpc_test.branch(:,5)';
disp('�����ʼ�ܵ�������');
disp(Hm);
HTsload=[100 100 100 100 100 100 100 100 100 100 100 100 100];
disp('�����ʼ���ɽڵ㹩���¶ȣ�');
disp(HTsload);
HTrload=[40 40 40 40 40 40 40 40 40 40 40 40 40];
disp('�����ʼ���ɽڵ�����¶ȣ�');
disp(HTrload);
HTs=[HTsload,HTssource];
HT0=hT0;
Hload=hload;



% hkk=0.2;%�ȴ���ϵ��
% Cp=4200/CP_B;%��ý�ı�����
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
% disp('�ܵ�Ħ��ϵ������')
% disp(HK);
% 
% %��ʼ���ݼ���
% % Hm=[2.716 0.716 2.284];
% % Hm=[2.5 1 2.5];
% Hm=[2 2 2 2]/Hm_B;
% % Hm=[1 1 1 1]/Hm_B;
% disp('�����ʼ�ܵ�������');
% disp(Hm);
% HTsload=[100 100 100]/T_B;
% disp('�����ʼ���ɽڵ㹩���¶ȣ�');
% disp(HTsload);
% HTrload=[40 40 40]/T_B;
% disp('�����ʼ���ɽڵ�����¶ȣ�');
% disp(HTrload);
% HTs=[HTsload,HTssource];
% HT0=hT0;
% Hload=hload;

%%%%%%%%%%%����豸ת��
hT0source=40/T_B;
% PG=Cp*(Hm(1)+Hm(4))*(HTssource-hT0source);
PG=Cp*Hm(1)*(HTssource-hT0source);




%% ���㲻ƽ����
% P(30)=PG/cm;
mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm*mpc_E.baseMVA; %CHP
% mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm/10; %CHP

% Gload(3)=PG/(cm*ne);
mpc_G.bus(5,3)=PG/(cm*ne);

% ���������ƽ����
%$%PQ%
[dP,dQ]=myEUnbalanced(mpc_E);

%����������ƽ����
[mpc_G,dG] = myGUnbalanced(mpc_G);

% ����������ƽ����
[Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
[dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
%����Ϊһ������ƽ����
dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
disp('�����Ĳ�ƽ������');
disp(dEGH);

%% ţ������ѭ����ʼ
for round=1:Tmax
    fprintf('��%d�ε���\n',round);
    
    %%%%%%%%%%%����豸ת��
    hT0source=40/T_B;
%     PG=Cp*(Hm(1)+Hm(4))*(HTssource-hT0source);
    PG=Cp*Hm(1)*(HTssource-hT0source);
%     P(30)=(PG/cm);
    mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm*mpc_E.baseMVA; %CHP
%     mpc_E.gen(mpc_E.gen(:,1)==30,2) = PG/cm/10; %CHP
%     Gload(3)=PG/(cm*ne);
    mpc_G.bus(5,3)=PG/(cm*ne);

    % �����ſ˱Ⱦ���
    %     ���Jee
    Jee = -mymakeJac(mpc_E);%PQ ˳��ͬ%$%
    
    %     ���Jhh
    Jhh = HJacobi(nh,mh,lh,Cp,HTsload,HTs,hT0,As1,Bh,HK,Hm,Cs,Cr,Hpipe,hk);
    
    %     ���Jgg
    Jgg = myG_makeJac(mpc_G);
    
    % ���Jeh
    Jeh=zeros(E_n_PQ+E_nb-1,nh+2*lh+1);
%     Jeh(30,1)=-Cp*Hm(4)*(HTssource-hT0source)/cm;
%     Jeh(30,4)=-Cp*Hm(1)*(HTssource-hT0source)/cm;
    Jeh(30,1)=-Cp*(HTssource-hT0source)/cm;
    disp('Jeh:');
    disp(Jeh);
    [load,~,~] = myG_bustypes(mpc_G.bus);
     G_test = length(load);
     %%%%???
    % ���Jeg
    Jeg=zeros(E_n_PQ+E_nb-1,G_test);

    % ���Jgh
    Jgh=zeros(G_test,nh+2*lh+1);
%     Jgh(3,1)=Cp*Hm(4)*(HTssource-hT0source)/(cm*ne);
%     Jgh(3,4)=Cp*Hm(1)*(HTssource-hT0source)/(cm*ne);
    Jgh(3,1)=Cp*(HTssource-hT0source)/(cm*ne);
    disp('Jgh');
    disp(Jgh);
   
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
    disp('JEGH');
    disp(JEGH);
    %%%???
%     con(round) = cond(JEGH);
%     con1=max(con);
    
    % ���������
    [dtheta,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(E_nb,E_n_PQ,mh,lh,mpc_E.bus(:,8)',dEGH,JEGH,G_test);
    
%     ����״̬��
%     ��������״̬��
%     U
    mpc_E.bus(:,8) = mpc_E.bus(:,8)+dU';
% 	theta
    mpc_E.bus(:,9) = mpc_E.bus(:,9)+dtheta'/pi*180;
% 	disp('�ڵ��ѹ��ֵ��');
% 	disp(U);
% 	disp('�ڵ��ѹ��ǣ�');
% 	disp(rad2deg(theta));
    % ��������״̬��
    Hm=Hm+dHm;
    HTsload=HTsload+dHTsload;
    HTrload=HTrload+dHTrload;
    disp('������Ĺܵ�������');
    disp(Hm);
    disp('������Ľڵ㹩���¶ȣ�');
    disp(HTsload);
    disp('������Ľڵ�����¶ȣ�');
    disp(HTrload);
    % ��������״̬��
    temp = mpc_G.bus(:,4).^2 + dppp';
    if temp < 0
        error('����������');
    end
    mpc_G.bus(:,4) = real(sqrt(temp));
%     Gpi2=Gpi2+dppp;
%     disp('������Ľڵ���ѹֵ');
%     disp(Gpi2);
    
    % �жϷ���
%     [As1,Hpipe,Hm] = panduan(mh,Hpipe,As1,Hm);
        
    % ��ⲻƽ����
    % ���������ƽ����
    [dP,dQ]=myEUnbalanced(mpc_E );

    %����������ƽ����
%     [Gload,Gpi2,dpi2,Ag,Gpipe,Ag2,dGQ,dG] = GUnbalanced(0,Gpi2,Ag,Gpipe,G_nl,zg,0,Gload,gas);
    [mpc_G,dG] = myGUnbalanced(mpc_G);
    % ����������ƽ����
    [Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
    [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
    %����Ϊһ������ƽ����
    dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
    disp('�����Ĳ�ƽ������');
    disp(dEGH);

    % �ж�����
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        break;
    end
end
%% �����������ж�������������

 mpc_E = myupdate_mpc_E(mpc_E);
%% test
% PQout(1) = mpc_E.gen(10,2);
% PQout(2) = mpc_E.gen(10,3);

PQout(1) = mpc_E.gen(1,2);
PQout(2) = mpc_E.gen(1,3);

if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
    disp('��������');
else
    disp('���㲻����');
end
disp('************���ս��*************');
fprintf('�����ܴ�����%d\n', round);
disp('***������������')
% disp('�ڵ��ѹ��ֵ��');
% disp(U);
% disp('�ڵ��ѹ��ǣ�');
% disp(rad2deg(theta));
% disp('�й���������');
% disp(Pi);
% disp('�޹���������');
% disp(Qi);
disp('***������������');
disp('���ɽڵ㹩���¶�:');
disp(HTsload);
disp('���ɽڵ�����¶�:');
disp(HTrload);
disp('��Դ�����¶�:');
disp(hT0source);
disp('�����ܵ�������');
disp(Hm);
disp('***������������');
disp('��Ȼ��������ڵ�ѹ����');
Gpi=mpc_G.bus(:,4);
disp(Gpi);
% disp('��Ȼ��������ܵ�������');
% disp(dGQ);
% disp('��Ȼ�����縺�ɣ�');
% disp(Gload);

toc;

