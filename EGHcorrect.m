function [dcita,dU,dHm,dHTsload,dHTrload,dppp] = EGHcorrect(n,m,mh,lh,U,dEGH,JEGH,G_test)
%求解状态变量修正量
du=-(JEGH)\dEGH;

dcita=du(1:n-1);

Ud2=diag(U);
dU=(Ud2*du(n:n+m-1));

dHm=du(n+m:n+m-1+mh);

dHTsload=du(n+m+mh:n+m-1+mh+lh);

dHTrload=du(n+m+mh+lh:n+m-1+mh+2*lh);

dppp=du(n+m+mh+2*lh:n+m-1+mh+2*lh+G_test);

end

