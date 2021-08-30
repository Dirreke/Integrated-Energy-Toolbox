% filename:Unbalanced.m
% author: 山东科技大学 罗江
% function: 计算功率不平衡量
function [ dP,dQ,Pi,Qi ] = EUnbalanced( n,m,P,Q,U,G,B,cita,mpc )
%计算ΔPi有功的不平衡量
for i=1:n
	for j=1:n
		Pn(j)=U(i)*U(j)*(G(i,j)*cos(cita(i)-cita(j))+B(i,j)*sin(cita(i)-cita(j)));
	end
	Pi(i)=sum(Pn);
end
dP=P(1:n-1)-Pi(1:n-1); %dP有n-1个

%计算ΔQi无功的不平衡量
for i=1:n
	for j=1:n
		Qn(j)=U(i)*U(j)*(G(i,j)*sin(cita(i)-cita(j))-B(i,j)*cos(cita(i)-cita(j)));
	end
	Qi(i)=sum(Qn);
end
dQ=Q(1:m)-Qi(1:m); %dQ有m个

% disp('有功不平衡量：');
% disp(dP);
% disp('无功不平衡量：');
% disp(dQ);




end%func

