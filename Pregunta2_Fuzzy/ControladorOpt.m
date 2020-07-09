function [u] = ControladorOpt(r,h,f)
tm=10;
A=2;
B=0.01;
N=6;
M=2; %Se debe cumplir M<=N

%Optimización
lb=zeros(1,M);
ub=100*ones(1,M);
nvars = N;
fun = @(x)myfun(x,r,h,f,tm,A,B,N,M);
options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
F= particleswarm(fun, nvars, lb,ub,options);
u=F(1);
end

function [J] = myfun(F,r,h,f,tm,A,B,N,M)

H(1)=(5.43*f+78.23-20.21*sqrt(h))/(0.63*h^2+11.4*h+17.1)*tm + h;

J=0;
for i=1:N
    if i<=M
        J = J + A*(H(i)-r)^2+ B*F(i)^2;
        H(i+1)=(5.43*F(i)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm + H(i);
    else %Se maniene la ultima aciion de control estimada
        J = J + A*(H(i)-r)^2+ B*F(M)^2;
        H(i+1)=(5.43*F(M)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm + H(i);
    end
    if H(i+1)<15 
        H(i+1)=15;
    elseif H(i+1)>50
        H(i+1)=15;
    end
end
end
