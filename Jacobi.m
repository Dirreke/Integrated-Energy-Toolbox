% filename:Jacobi.m
% author:ɽ���Ƽ���ѧ �޽�
% function: �����ſɱȾ���
function [ J ] = Jacobi( n,m,U,cita,B,G,Pi,Qi )
%�ſɱȾ���ļ���
%�ֿ� H N K L
%i!=jʱ
for i=1:n-1
	for j=1:n-1
		H(i,j)=-U(i)*U(j)*(G(i,j)*sin(cita(i)-cita(j))-B(i,j)*cos(cita(i)-cita(j)));
	end
end
for i=1:n-1
	for j=1:m
		N(i,j)=-U(i)*U(j)*(G(i,j)*cos(cita(i)-cita(j))+B(i,j)*sin(cita(i)-cita(j)));
	end
end
for i=1:m
	for j=1:n-1
		K(i,j)=U(i)*U(j)*(G(i,j)*cos(cita(i)-cita(j))+B(i,j)*sin(cita(i)-cita(j)));
	end
end
for i=1:m
	for j=1:m
		L(i,j)=-U(i)*U(j)*(G(i,j)*sin(cita(i)-cita(j))-B(i,j)*cos(cita(i)-cita(j)));
	end
end
%i==jʱ
for i=1:n-1
	H(i,i)=U(i).^2*B(i,i)+Qi(i);
end
for i=1:m
	N(i,i)=-U(i).^2*G(i,i)-Pi(i);
end
for i=1:m
	K(i,i)=U(i).^2*G(i,i)-Pi(i);
end
for i=1:m
	L(i,i)=U(i).^2*B(i,i)-Qi(i);
end

%�ϳ��ſɱȾ���
J=[H N;K L];
end

