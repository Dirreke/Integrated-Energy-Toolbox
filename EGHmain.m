clear;
clc;
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

%% ������������
mpc_E = loadcase('case_E.m');

E_nb = length(mpc_E.bus);
E_n_PQ = sum(mpc_E.bus(:,2) == 1); % PQ �ڵ����


P=zeros(1,E_nb); %P,QΪԭʼ���ݣ�Pi,QiΪ������
Q=zeros(1,E_nb);
U=ones(1,E_nb); %��ѹ��ʼֵ�ɴ�ȷ��
theta=zeros(1,E_nb); 

P(mpc_E.bus(:,1)) = - mpc_E.bus(:,3);
P(mpc_E.gen(:,1)) = mpc_E.gen(:,2);
Q(mpc_E.bus(:,1)) = - mpc_E.bus(:,4);
U(mpc_E.gen(:,1)) = mpc_E.gen(:,6);
theta(mpc_E.bus(mpc_E.bus(:,2) == 3,1)) = mpc_E.bus(mpc_E.bus(:,2) == 3,9);
% theta = mpc_E.bus(,9);
P = P/mpc_E.baseMVA;
Q = Q/mpc_E.baseMVA;


Y = makeYbus(mpc_E.baseMVA,mpc_E.bus,mpc_E.branch);
G=real(Y); %�絼����
B=imag(Y); %���ɾ���
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
% disp('�ܵ�Ħ��ϵ������')
% disp(HK);
%��ʼ���ݼ��� 
% Hm=[2 2 2 2 2 2 2 2 2 2 2 2 2 2];
Hm=mpc_test.branch(:,5)';
% disp('�����ʼ�ܵ�������');
% disp(Hm);
HTsload=[100 100 100 100 100 100 100 100 100 100 100 100 100];
% disp('�����ʼ���ɽڵ㹩���¶ȣ�');
% disp(HTsload);
HTrload=[40 40 40 40 40 40 40 40 40 40 40 40 40];
% disp('�����ʼ���ɽڵ�����¶ȣ�');
% disp(HTrload);
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

%% ������������
gas=gas_test();
G_nl = length(gas.branch);
G_nb = length(gas.bus);
%%��֪��Դѹ����ѹ��������ѹ��Ϊ5.000��
%������Ȼ���ܵ�������I��ڵ㣬J��ڵ㣬����/m,ֱ��/mm����֦1/��֦2/ѹ����3
Gpipe = gas.branch;

%������Ȼ��ϵͳ���ɽڵ����ݣ��ڵ㣬����/m3/h
Gload = [0 1100 1647.12 1871.35 2000]/G_B;
%��Ȼ���Ľڵ�-֧·��������

Ag = sparse(Gpipe(1:end-1,1),1:G_nl-1,-1,G_nb,G_nl-1) + sparse(Gpipe(1:end-1,2),1:G_nl-1,1,G_nb,G_nl-1);

% 
% index = (Gpipe(:,5)~=3);
% temp = sum(index);
% Ag = sparse(Gpipe(index,1),1:temp,-1,G_nb,temp) + sparse(Gpipe(index,2),1:temp,1,G_nb,temp);

%����ƽ��ڵ���ѹ ��λbar ���ɽڵ�Ĭ��Ϊ0
Gp1=[5.000 5.000]/Gpi_B;
%��Ȼ��ϵͳ���ݴ���
zg = sum(Gpipe(:,5) == 3);
%����ܵ�����
% Kr = 70840/Kg_B./sqrt(Gpipe(:,3))';
% disp('�ܵ�Ħ��ϵ����');
% disp(Kr);

%���������ʼֵ���ⲿ�����������ȼ����ֵΪ������    
Gpi=[4.4973 4.4839 4.4397 4.4394 4.4323]/Gpi_B;

Gpi=[Gp1,Gpi];
Gpi2=Gpi.^2;
% disp('Gpi2:');
% disp(Gpi2);

%% ���㲻ƽ����
% ���������ƽ����
P(30)=PG/cm;
Gload(3)=PG/(cm*ne);
[dP,dQ,Pi,Qi]=EUnbalanced(E_nb,E_n_PQ,P,Q,U,G,B,theta);

%$%
% [ref, pv, pq] = bustypes(mpc_E.bus, mpc_E.gen);
% V = U' .* exp(theta * i);
% Vm = U';
% mpopt = mpoption;
% mis = V .* conj(Y * V) - makeSbus(mpc_E.baseMVA, mpc_E.bus, mpc_E.gen, mpopt, Vm);
% F = [   real(mis([pq; pv]));%pv;pq;30
%         imag(mis(pq))   ];
%     
%����������ƽ����
[Gload,Gpi2,dpi2,Ag,Gpipe,Ag2,dGQ,dG] = GUnbalanced(0,Gpi2,Ag,Gpipe,G_nl,zg,0,Gload,gas);
% ����������ƽ����
[Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
[dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
%����Ϊһ������ƽ����
dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
% disp('�����Ĳ�ƽ������');
% disp(dEGH);

%% ţ������ѭ����ʼ
for round=1:Tmax
    fprintf('��%d�ε���\n',round);
    
    %%%%%%%%%%%����豸ת��
    hT0source=40/T_B;
%     PG=Cp*(Hm(1)+Hm(4))*(HTssource-hT0source);
    PG=Cp*Hm(1)*(HTssource-hT0source);
    P(30)=(PG/cm);
    Gload(3)=PG/(cm*ne);
    % �����ſ˱Ⱦ���
    %     ���Jee
    J=Jacobi( E_nb,E_n_PQ,U,theta,B,G,Pi,Qi );
%     J = -makeJac();PQ ˳��ͬ%$%
%     disp('Jee:');
%     disp(J);
    
    %     ���Jhh
    [HJhh] = HJacobi(nh,mh,lh,Cp,HTsload,HTs,hT0,As1,Bh,HK,Hm,Cs,Cr,Hpipe,hk);
    %     ���Jgg
    for i=1:G_nl - zg
        D(i,i)=dGQ(i)/(2*dpi2(i));
    end
%     disp(D);
    Jgg=-Ag2*D*Ag2';
%     disp('Jgg��');
%     disp(Jgg);
    
    % ���Jeh
    Jeh=zeros(E_n_PQ+E_nb-1,nh+2*lh+1);
%     Jeh(30,1)=-Cp*Hm(4)*(HTssource-hT0source)/cm;
%     Jeh(30,4)=-Cp*Hm(1)*(HTssource-hT0source)/cm;
    Jeh(30,1)=-Cp*(HTssource-hT0source)/cm;
%     disp('Jeh:');
%     disp(Jeh);
    
    % ���Jeg
    Jeg=zeros(E_n_PQ+E_nb-1,5);

    % ���Jgh
    Jgh=zeros(5,nh+2*lh+1);
%     Jgh(3,1)=Cp*Hm(4)*(HTssource-hT0source)/(cm*ne);
%     Jgh(3,4)=Cp*Hm(1)*(HTssource-hT0source)/(cm*ne);
    Jgh(3,1)=Cp*(HTssource-hT0source)/(cm*ne);
%     disp('Jgh');
%     disp(Jgh);
    
    % ���Jge
    Jge=zeros(5,E_n_PQ+E_nb-1);

    % ���Jhe
    Jhe=zeros(mh+2*lh,E_n_PQ+E_nb-1);

    % ���Jhg
    Jhg=zeros(mh+2*lh,5);
    
    % �ϳ��������ſ˱Ⱦ���
    JEGH=[J,Jeh,Jeg;
          Jhe,HJhh,Jhg;
          Jge,Jgh,Jgg];
%     disp('JEGH');
%     disp(JEGH);
    
    con(round) = cond(JEGH);
    con1=max(con);
    
    % ���������
    [dtheta,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(E_nb,E_n_PQ,mh,lh,U,dEGH,JEGH,5);
    
%     ����״̬��
%     ��������״̬��
    U=U+dU;
	theta=theta+dtheta;
% 	disp('�ڵ��ѹ��ֵ��');
% 	disp(U);
% 	disp('�ڵ��ѹ��ǣ�');
% 	disp(rad2deg(theta));
    % ��������״̬��
    Hm=Hm+dHm;
    HTsload=HTsload+dHTsload;
    HTrload=HTrload+dHTrload;
%     disp('������Ĺܵ�������');
%     disp(Hm);
%     disp('������Ľڵ㹩���¶ȣ�');
%     disp(HTsload);
%     disp('������Ľڵ�����¶ȣ�');
%     disp(HTrload);
    % ��������״̬��
    Gpi2=Gpi2+dppp;
%     disp('������Ľڵ���ѹֵ');
%     disp(Gpi2);
    
    % �жϷ���
%     [As1,Hpipe,Hm] = panduan(mh,Hpipe,As1,Hm);
        
    % ��ⲻƽ����
    % ���������ƽ����
    [dP,dQ,Pi,Qi]=EUnbalanced( E_nb,E_n_PQ,P,Q,U,G,B,theta );
    [ref, pv, pq] = bustypes(mpc_E.bus, mpc_E.gen);
    V = U' .* exp(theta' * j);
    Vm = U';
    mpopt = mpoption;
    mis = V .* conj(Y * V) - makeSbus(mpc_E.baseMVA, mpc_E.bus, mpc_E.gen, mpopt, Vm);
    F = [   real(mis(1:38));%pv;pq;30��
            imag(mis(pq))   ];
    %����������ƽ����
    [Gload,Gpi2,dpi2,Ag,Gpipe,Ag2,dGQ,dG] = GUnbalanced(0,Gpi2,Ag,Gpipe,G_nl,zg,0,Gload,gas);
    % ����������ƽ����
    [Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,Hpipe,HTs,Hm,hT0,HTrload,Cp1);
    [dP_H,dp_H,dTs,dTr] = bupinghengliang(Cp,As1,Hm,hT0,Bh,HK,Cs,HTsload,bs,Cr,HTrload,br,Hload);
    %����Ϊһ������ƽ����
    dEGH=[dP';dQ';dP_H;dp_H;dTs;dTr;dG];
%     disp('�����Ĳ�ƽ������');
%     disp(dEGH);

    % �ж�����
    if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
        break;
    end
end
%% �����������ж�������������
if (max(abs(dP))<Elimit && max(abs(dQ))<Elimit ) && max(abs(dP_H))<Hlimit && max(abs(dp_H))<Hlimit && max(abs(dTs))<Hlimit && max(abs(dTr))<Hlimit && max(abs(dG))<Glimit
    disp('��������');
else
    disp('���㲻����');
end
disp('************���ս��*************');
fprintf('�����ܴ�����%d\n', round);
disp('***������������')
disp('�ڵ��ѹ��ֵ��');
disp(U);
disp('�ڵ��ѹ��ǣ�');
disp(rad2deg(theta));
disp('�й���������');
disp(Pi);
disp('�޹���������');
disp(Qi);
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
Gpi=sqrt(Gpi2);
disp(Gpi);
disp('��Ȼ��������ܵ�������');
disp(dGQ);
disp('��Ȼ�����縺�ɣ�');
disp(Gload);

toc;

