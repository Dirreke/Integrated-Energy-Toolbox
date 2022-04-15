function [mpc,dG] = myGUnbalanced(mpc)

[LOAD, CONPR, SOURSE, NONE, BUS_I, BUS_TYPE, FD, PR, PRMAX, PRMIN] = myG_idx_bus;
[TREE,CONNECT, COMPRESSOR, FBUS, TBUS, LENGTH, DIAMETER, BRANCH_TYPE] = myG_idx_branch;
% gen = mpc.gen;
branch = mpc.branch;
bus = mpc.bus;

%% contents
nb = size(bus, 1);
nl = size(branch,1);
%% para

Kg_B = 1;%%%???
%计算气网不平衡量
%计算流过压缩机的流量 将其折算为节点负荷
Tgas=50;
qgas=35590;
a=-0.2;
glimit=0.001;
gT=1000;


%% initial
[~,~, compressor,after_compressor] = myG_branchtypes(branch);
[load,~,~] = myG_bustypes(bus);
Kr = 70840/Kg_B./sqrt(branch(:,LENGTH));
Kr1 = Kr;
Kr1(compressor) = [];
%% original compressor

% fmi=fon;
% %fcom qcom
% %fcp qcp
% %fm qm
% % pi pA
% % Kr Kg

%% PSquare
PSquare = zeros(max(bus(:,BUS_I)),1);
temp = bus(:,PR).^2;%%？？
for k = 1:length(PSquare)
    PSquare(k) = temp(bus(:,BUS_I) == k);
end

%% compressor 
Fm = zeros(length(compressor),1);
%% for methods
dfmi_last = Inf;
flag = 1;
for k = 1:length(compressor)
    
    pm2 = PSquare(branch(compressor(k),FBUS));
    pb2 = PSquare(branch(compressor(k),TBUS));
    pn2 = PSquare(branch(after_compressor(k,1),after_compressor(k,2)));%%%%???
    fcom=Kr(after_compressor(k)) * sqrt(pb2-pn2);
    fm = fcom;
    for kk = 1:gT
    %     branch(compressor(k),FBUS:TBUS)
        fm_last = fm;
        if pm2-fm^2./Kr(compressor(k)).^2 < 0
            pa = 5;
        else
            pa = sqrt(pm2-fm.^2./(Kr(compressor(k)).^2));
            flag = 1;
        end
        kcp = sqrt(pb2)./pa;
        fcp = kcp.*fcom.*Tgas.*(kcp.^((a-1)/a)-1)./qgas;
        fm = fcom + fcp;
        dfmi = fm - fm_last;
        if abs(dfmi) < dfmi_last
            Fm(k)  = fm;
            dfmi_last = abs(dfmi);
        end
        if abs(dfmi)<glimit && flag
%             bus(branch(compressor(k),FBUS),FD) = fm;%%???????fcp?
            Fm(k)  = fm;
            break;
        end
        if kk == gT
            warning('气网计算可能不收敛');
        end
    end
end

%% matrix compressor
% % pm = bus(branch(compressor,FBUS),PR);
% % pb = bus(branch(compressor,TBUS),PR);
% % pn = bus(branch(after_compressor,TBUS),PR);
% 
% pm2 = PSquare(branch(compressor,FBUS));
% pb2 = PSquare(branch(compressor,TBUS));
% pn2 = PSquare(branch(after_compressor(:,1),after_compressor(:,2)));
%     
% Fcom=Kr(after_compressor) .* sqrt(pb2-pn2);
% Fm = Fcom;
% for kk = 1:gT
% %         branch(compressor(k),FBUS:TBUS)
%     Fm_last = Fm;
% 
%     pa = sqrt(pm2-Fm.^2./(Kr(compressor).^2));
%     kcp = sqrt(pb2)./pa;
%     Fcp = kcp.*fcom.*Tgas.*(kcp.^((a-1)/a)-1)./qgas;
%     Fm = Fcom + Fcp;
%     dfmi = Fm - fm_last;
%     if abs(dfmi)<glimit
% %         bus(branch(compressor,FBUS),FD) = Fm;%%???????fcp?
%         break;
%     end
%     if kk == gT
%         warning('计算不收敛');
%     end
% end
%% 计算气网不平衡量

Ag = sparse(branch(1:end,1),1:nl,-1,nb,nl) + ...
        sparse(branch(1:end,2),1:nl,1,nb,nl);
% Ag1 = Ag;
% Ag1(:,compressor) = [];% 压缩机支路公式无效，已其他方法处理
dPSquare=-Ag'*PSquare;

%% 换序
temp = dPSquare < 0;
temp(compressor) = 0;
temp2 = branch(temp,1);
branch(temp,1) = branch(temp,2);
branch(temp,2) = temp2;

%% 重新计算气网不平衡量
Ag1 = sparse(branch(1:end,1),1:nl,-1,nb,nl) + ...
        sparse(branch(1:end,2),1:nl,1,nb,nl);
Ag1(:,compressor) = [];
dPSquare1=-Ag1' * PSquare;
Fbranch1=Kr1 .* sqrt(dPSquare1);
Fnode=Ag1 * Fbranch1;
Fnode(branch(compressor,FBUS)) = Fnode(branch(compressor,FBUS)) - Fm;
Fnode(branch(compressor,TBUS)) = 0;%%%%%??? 多种模式时或许需要修改
Fnode_paixu = Fnode(bus(:,BUS_I));

dG = Fnode_paixu - bus(:,FD);
% dG(load)
dG = dG(load,:);
%%
% gen = mpc.gen;
mpc.branch = branch;
mpc.bus = bus;
end

