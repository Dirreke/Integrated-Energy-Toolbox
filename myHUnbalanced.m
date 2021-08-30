function [Cs,bs,Cr,br,H,hT0source] = myHUnbalanced(mh,lh,sh,KT,HTssourse,hT0,HTrload,Cp,mpc)
% function [Cs,bs] = myHUnbalanced(mpc,KT,Cp,Tssourse)
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
bus = mpc.bus;
branch = mpc.branch;
nb = length(bus);
nl = length(branch);
[load,sourse] = myH_bustypes(bus);

%计算hk
H = exp(-KT*branch(:,LENGTH)./(branch(:,FBRANCH)*Cp));

%% 计算Cs,bs
f = branch(:, FBUS);                           %% list of "from" buses
t = branch(:, TBUS);                           %% list of "to" buses
Cs = sparse(t,f,-H.*branch(:,FBRANCH),nb,nb);
Cs(sourse,:) = [];
bs = -sum(Cs(:,sourse),2).*HTssourse;
Cs(:,sourse) = [];
Csdiag = sum(sparse(t,f,branch(:,FBRANCH),nb,nb),2);
Csdiag(sourse,:) = [];
Cs = Cs + diag(Csdiag);





%% 计算负荷节点Cr,br   
Cr=zeros(lh,lh);
for x=1:lh
%     disp('节点号');
%     disp(x);
    a=0;
    b=1;
    t=1;
    sss=zeros(1,mh);
    rrr=zeros(1,mh);
    for i=1:mh
        if branch(i,FBUS)==x
            a=a+1;
            rrr(b)=i;%把流入i的支路序号存入rrr
            ppp(b)=branch(i,2);
%             disp('a');
%             disp(a);
%             disp(rrr);
            t=b;
            b=b+1;
        end
    end
    c=1;
    w=1;
    for i=1:mh
        if branch(i,2)==x
            sss(c)=i;%把流出i的支路序号存入sss
%             disp(sss);
            w=c;
            c=c+1;
        end
    end
        
    %%类型一：只有一个负荷流回节点x
    if a==0
        br(x,1)=hT0(x);
        Cr(x,x)=1;
    end
    %%类型二：负荷+多条管道流回该节点x
    if a>0
        bt=0;
        cr=0;
        for i=1:t
            bt=bt-branch(rrr(i),FBRANCH);
            Cr(x,ppp(i))=-branch(rrr(i),FBRANCH)*H(rrr(i));
        end
        for i=1:w
            cr=cr+branch(sss(i),FBRANCH);
        end
        br(x,1)=(cr+bt)*hT0(x);
        Cr(x,x)= cr;
    end        
end
% disp('Cr:');
% disp(Cr);
% disp('br:');
% disp(br);

%%计算源处回热温度
for x=1:sh
    a=0;
    b=1;
    t=1;
    for i=1:mh
        if branch(i,FBUS)==(lh+x)
            a=a+1;
            mmm(b)=i;%把与源相连的支路号存入mmm
            nnn(b)=branch(i,TBUS);%把与源相连的节点号存入mmm
            t=b;
            b=b+1;
        end
    end
    if a==1
        hT0source(x)=H(mmm(1))*HTrload(nnn(1));
    end
    if a>1
        fenzi=0;
        fenmu=0;
        for i=1:t
            fenzi=fenzi+H(mmm(i))*branch(mmm(i),FBRANCH)*HTrload(nnn(i));
            fenmu=fenmu+branch(mmm(i),FBRANCH);
        end
        hT0source(x)=fenzi/fenmu;
    end
end




    
    
    
    
    
end

