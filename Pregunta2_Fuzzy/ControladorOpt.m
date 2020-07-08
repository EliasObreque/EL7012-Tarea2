function [u] = ControladorOpt(r,h,f)
tm=10;
A=1;
B=1;
N=8;
M=2; %Se debe cumplir M<=N

%Optimización
lb=[0,0];ub=[100,100];%**Vectores fila
nvars = N;
fun = @(x)myfun(x,r,h,f,tm,A,B,N,M);
options = optimoptions('particleswarm','SwarmSize',200,'MaxIterations',1000);
[F,fval,exitflag,output]=particleswarm(fun,nvars,lb,ub,options);
u=F(1);
end

function [J] = myfun(F,r,h,f,tm,A,B,N,M)

H(1)=(5.43*f+78.23-20.21*sqrt(h))/(0.63*h^2+11.4*h+17.1)*tm+h;

J=0;
for i=1:N    
    J=J+A*(H(i)-r)^2+B*F(i)^2;
    H(i+1)=(5.43*F(i)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm+H(i);

%     if i < M
%         J=J+B*u^2;
%         F(j+1)=u;
%     end
end

end
