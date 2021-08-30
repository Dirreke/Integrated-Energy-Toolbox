function [HJhh] = HJacobi(nh,mh,lh,Cp,hT0,Cs,Cr,hk,mpc)
bus = mpc.bus;
branch = mpc.branch;
[FBUS, TBUS, LENGTH, DIAMETER, FBRANCH] = myH_idx_branch;
[LOAD, SOURSE, NONE, BUS_I, BUS_TYPE, PHID, TO, TS, TR] = myH_idx_bus;
[load,sourse] = myH_bustypes(bus);

%计算热网
Hm = mpc.branch(:,5)';
HK = myH_makeHK(mpc);
[As1,Bh] = myH_makeABmatrix(mpc);
HTsload = mpc.bus(load,5)';
HTs = mpc.bus(:,5)';

huilugeshu = size(Bh,1);
Jh11=[Cp.*diag(HTsload-hT0)*As1;2.*Bh.*HK.*(Hm)];
% disp('Jh11');
% disp(Jh11);
Jh12=[Cp.*diag(As1*Hm') zeros(lh,lh);
      zeros(huilugeshu,lh)  zeros(huilugeshu,lh)];
%   disp('Jh12');
% disp(Jh12);
Jh21=zeros(2*lh,nh);
for x=1:lh
    a=0;
    sss=zeros(1,mh);
    rrr=zeros(1,mh); 
    b=1;
    t=1;
    for i=1:mh
        if branch(i,TBUS)==x
            a=a+1;
            sss(b)=branch(i,FBUS);%把与i相连的j存入sss
            rrr(b)=i;%把与i相连的支路序号存入rrr
            t=b;
            b=b+1;
        end
    end
    if a==1
        Jh21(x,1:nh)=0;
    end
    if a>1
        Jh21(x,rrr(t))=-hk(rrr(t))*HTs(sss(t));
    end
end

for x=1:lh
    a=0;
    b=1;
    t=1;
    sss=zeros(1,mh);
    rrr=zeros(1,mh);
    ppp=zeros(1,mh);
    qqq=zeros(1,mh);
    for i=1:mh
        if branch(i,FBUS)==x
            a=a+1;
            rrr(b)=i;%把流入i的支路序号存入rrr
            ppp(b)=branch(i,TBUS);
            t=b;
            b=b+1;
        end
    end
    c=1;
    w=1;
    for i=1:mh
        if branch(i,TBUS)==x
            sss(c)=i;%把流出i的支路序号存入sss
            qqq(c)=branch(i,FBUS);
            w=c;
            c=c+1;
        end
    end
    
    if a==0
        Jh21(lh+x,1:nh)=0;
    end
    if a>0
        for p=1:t
            Jh21(lh+x,rrr(p))=hT0(x);
        end
        for q=1:w
            Jh21(lh+x,sss(q))=-hT0(x);
        end
    end
end
% disp('Jh21');    
% disp(Jh21);  

Jh22=[Cs zeros(lh,lh);
      zeros(lh,lh)  Cr];

% disp('Jh22');    
% disp(Jh22);  
HJhh=[Jh11 Jh12;
      Jh21 Jh22];
% disp('热网雅克比矩阵Jhh:');
% disp(HJhh);
end
                                                                