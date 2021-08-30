function [Gload,Gpi2,dpi2,Ag,Gpipe,Ag2,dGQ,dG] = GUnbalanced(Kr,Gpi2,Ag,Gpipe,nl,zg,Kr1,Gload,ggc)
nl = length(ggc.branch);
Kg_B = 1;
Kr = 70840/Kg_B./sqrt(Gpipe(:,3))';

%����������ƽ����
%��������ѹ���������� ��������Ϊ�ڵ㸺��
Tgas=50;
qgas=35590;
a=-0.2;
glimit=0.001;
gT=100;
fon=Kr(2)*sqrt(Gpi2(2)-Gpi2(6));
% disp('fon');
% disp(fon);
fmi=fon;
%fon qcom
%fcp qcp
%fmi qma
% pi pA
% Kr Kgma  
% tic
for i=1:gT
% fprintf('ѹ������%d�ε���\n',i);    
    fff=fmi;
    pi=sqrt(Gpi2(3)-fmi*fmi/(Kr(7)^2));
    kcp=sqrt(Gpi2(2))/pi;
%     disp('kcp');
%     disp(kcp);
    fcp=kcp*fon*Tgas*(kcp^((a-1)/a)-1)/qgas;
%     disp('fcp');
%     disp(fcp);
    fmi=fon+fcp;
%     disp('fmi');
%     disp(fmi);
    dfmi=fmi-fff;
%     disp('dfmi');
%     disp(dfmi);
    if abs(dfmi)<glimit
        break;
    end
end
if abs(dfmi)<glimit
%     disp('��������');
    Gload(1)=fmi;
%     disp('Gload');
%     disp(Gload);
else
%     disp('���㲻����');
end
% disp('��Ȼ������ڵ���ѹ״̬��')
% disp(Gpi2);
% toc
% tic
%% ����������ƽ����
dpi2=-Ag'*Gpi2';
% disp('dpi2');
% disp(dpi2);
% temp = find(dpi2>0);
% temptemp = Gpipe(temp,1);
% Gpipe(temp,1)=Gpipe(temp,2);
% Gpipe(temp,2)=temptemp;
for i=1:nl-zg%%zg? 
    if dpi2(i)<0
        dpi2(i)=-dpi2(i);
        b=Gpipe(i,1);
        Gpipe(i,1)=Gpipe(i,2);
        Gpipe(i,2)=b;
        a=Ag(Gpipe(i,1),i);
        Ag(Gpipe(i,1),i)=Ag(Gpipe(i,2),i);
        Ag(Gpipe(i,2),i)=a;
    end
end
% disp('���������Ȼ���ܵ�����');
% disp(Gpipe);
% disp('���������Ȼ���ڵ�-֧·����');
% disp(Ag);
% disp('���������Ȼ���ڵ���ѹ��');
% disp(dpi2);
Ag2=Ag(3:7,:);
% disp(Ag2);

dGQ=Kr(1:6).*sqrt(dpi2');
% disp('��Ȼ���ܵ�������');
% disp(dGQ);
dG=Ag2*dGQ'-Gload';
% disp('��Ȼ�����ɽڵ㲻ƽ������');
% disp(dG);
% toc
end

