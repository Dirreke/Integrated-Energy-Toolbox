% filename:Jacobi.m
% author:山东科技大学 罗江
% function: 计算雅可比矩阵
function [ J ] = Jacobi( n,m,U,cita,B,G,Pi,Qi )
%雅可比矩阵的计算
%分块 H N K L
%i!=j时
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
%i==j时
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

%合成雅可比矩阵
J=[H N;K L];
end

