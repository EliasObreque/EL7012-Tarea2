function [u] = ControladorOptEuler(r,h,f)
tm=10;
A=2;
B=0.001;
N=1;
M=1; %Se debe cumplir M<=N

%Optimización
lb=zeros(1,M+1);
ub=100 * ones(1, M+1);%**Vectores fila
nvars = M+1;

% Aproximación de Euler
fun = @(x)myfunEuler(x,r,h,f,tm,A,B,N,M);
options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
[F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);
u=F(1);
end

function [J] = myfunEuler(F,r,h,f,tm,A,B,N,M)
minH=15;
maxH=50;

H(1)=(5.43*f+78.23-20.21*sqrt(h))/(0.63*h^2+11.4*h+17.1)*tm + h;
if H(1)<minH %Restricción física del nivel en el estanque
    H(1)=minH;
elseif H(1)>maxH
    H(1)=maxH;
end

J=0;
for i=1:N
    if i<=M+1
        F_actual=F(i);
    else %Se maniene la ultima accion de control estimada
        F_actual=F(M+1);
    end
    
    H(i+1)=(5.43*F_actual+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm + H(i);
    if H(i+1)<minH %Restricción física del nivel en el estanque
        H(i+1)=minH;
    elseif H(i+1)>maxH
        H(i+1)=maxH;
    end
    J = J + A*(H(i+1)-r)^2+ B*F_actual^2;
end
end

