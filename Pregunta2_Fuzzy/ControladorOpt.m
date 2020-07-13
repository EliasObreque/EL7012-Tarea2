function [u] = ControladorOpt(r,h,f)
tm=10;
A=2;
B=0.01;
N=5;
M=5; %Se debe cumplir M<=N

%Optimización
lb=zeros(1,M);
ub=100 * ones(1, M);%**Vectores fila
nvars = N;

%Aproximación de Euler
% fun = @(x)myfunEuler(x,r,h,f,tm,A,B,N,M);
% options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
% [F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);
% u=F(1);

%Modelo Difuso
modeloDifuso=load('ModeloDifuso.mat');
ny=3;
nu=1;

%Construcción del vector de regresores para el Modelo Difuso
if exist('Xdatos.mat')
    load('Xdatos');
    for i=ny:-1:2
        Xdatos(i)=Xdatos(i-1);
    end
    Xdatos(1)=h;
    for i=ny+nu:-1:ny+1
        Xdatos(i)=Xdatos(i-1);
    end
    Xdatos(ny+1)=f;
else
    Xdatos(1,1:ny)=h;
    Xdatos(1,ny+1:ny+nu)=f;
end

save('Xdatos','Xdatos');

fun = @(x)myfunMD(x,r,h,f,tm,A,B,N,M,modeloDifuso,Xdatos,ny,nu);

options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
[F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);
u=F(1);
end

function [J] = myfunEuler(F,r,h,f,tm,A,B,N,M)

H(1)=(5.43*f+78.23-20.21*sqrt(h))/(0.63*h^2+11.4*h+17.1)*tm + h;

J=0;
for i=1:N
    if i<=M
        J = J + A*(H(i)-r)^2+ B*F(i)^2;
        H(i+1)=(5.43*F(i)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm + H(i);
    else %Se maniene la ultima accion de control estimada
        J = J + A*(H(i)-r)^2+ B*F(M)^2;
        H(i+1)=(5.43*F(M)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm + H(i);
    end
    if H(i+1)<15 
        H(i+1)=15;
    elseif H(i+1)>50
        H(i+1)=50;
    end
end

end

function [J] = myfunMD(F,r,h,f,tm,A,B,N,M,modeloDifuso,X,ny,nu)

J=0;
for i=1:N
    H(i)=ysim(X,modeloDifuso.a,modeloDifuso.b,modeloDifuso.g);
    if H(i)<15 %Restricción física del nivel en el tanque
        H(i)=15;
    elseif H(i)>50
        H(i)=50;
    end
    if i<=M
        J = J + A*(H(i)-r)^2+ B*F(i)^2;        
    else %Se maniene la ultima accion de control estimada
        J = J + A*(H(i)-r)^2+ B*F(M)^2;        
    end
    %Actualizar el valor Estimado
    for j=ny:-1:2
        X(j)=X(j-1);
    end
    X(1)=H(i);
    if nu>1
    for j=ny+nu:-1:ny+1
        X(j)=X(j-1);
    end
    end
    if i<=M
        X(ny+1)=F(i);
    else %Se maniene la ultima accion de control estimada
        X(ny+1)=F(M);      
    end    
end
end
