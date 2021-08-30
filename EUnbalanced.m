% filename:Unbalanced.m
% author: ɽ���Ƽ���ѧ �޽�
% function: ���㹦�ʲ�ƽ����
function [ dP,dQ,Pi,Qi ] = EUnbalanced( n,m,P,Q,U,G,B,cita,mpc )
%���㦤Pi�й��Ĳ�ƽ����
for i=1:n
	for j=1:n
		Pn(j)=U(i)*U(j)*(G(i,j)*cos(cita(i)-cita(j))+B(i,j)*sin(cita(i)-cita(j)));
	end
	Pi(i)=sum(Pn);
end
dP=P(1:n-1)-Pi(1:n-1); %dP��n-1��

%���㦤Qi�޹��Ĳ�ƽ����
for i=1:n
	for j=1:n
		Qn(j)=U(i)*U(j)*(G(i,j)*sin(cita(i)-cita(j))-B(i,j)*cos(cita(i)-cita(j)));
	end
	Qi(i)=sum(Qn);
end
dQ=Q(1:m)-Qi(1:m); %dQ��m��

% disp('�й���ƽ������');
% disp(dP);
% disp('�޹���ƽ������');
% disp(dQ);




end%func

