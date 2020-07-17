function [u] = ControladorOptDifuso(r,h,f)
A=2;
B=0.01;
N=5;
M=5; %Se debe cumplir M<=N

%Modelo Difuso
modeloDifuso=load('ModeloDifuso.mat');
ny=3;
nu=1;

%Construcción del vector de regresores para el Modelo Difuso
if exist('Xdatos.mat')
    load('Xdatos');
    cont=cont+1;
    Xdatos=ActualizarRegresores(Xdatos,ny,nu,h,0);
    Xdatos=ActualizarRegresores(Xdatos,ny,nu,f,1);
else
    Xdatos(1,1:ny)=h;
    Xdatos(1,ny+1:ny+nu)=f;
    cont=1;
end

save('Xdatos','Xdatos','cont');

% if cont >ny
%Optimización
lb=zeros(1,M+1);
ub=100 * ones(1, M+1);%**Vectores fila
nvars = M+1;
fun = @(x)myfunMD(x,r,A,B,N,M,modeloDifuso,Xdatos,ny,nu);

%Algoritmo de Optimización Convencional
% x0=zeros(1,nvars);
% [F,fval] = fmincon(fun,x0,[],[],[],[],lb,ub);

% %PSO
% options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
% [F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);

% GA
[F,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],lb,ub);

u=F(1);
% else
%     u=0;
% end
end

function [J] = myfunMD(F,r,A,B,N,M,modeloDifuso,X,ny,nu)
minH=15;
maxH=50;

H(1)=ysim(X,modeloDifuso.a,modeloDifuso.b,modeloDifuso.g);
if H(1)<minH %Restricción física del nivel en el estanque
    H(1)=minH;
elseif H(1)>maxH
    H(1)=maxH;
end

J=0;
for i=1:N
    X=ActualizarRegresores(X,ny,nu,H(i),0); %Actualizar el valor estimado
    
    if i<=M+1 %En caso contrario se maniene la ultima acción de control estimada
        X=ActualizarRegresores(X,ny,nu,F(i),1);
    end
    
    H(i+1)=ysim(X,modeloDifuso.a,modeloDifuso.b,modeloDifuso.g);
    if H(i+1)<minH %Restricción física del nivel en el estanque
        H(i+1)=minH;
    elseif H(i+1)>maxH
        H(i+1)=maxH;
    end
    if i<=M+1
        J = J + A*(H(i+1)-r)^2+ B*F(i)^2;
    else %Se maniene la ultima acción de control estimada
        J = J + A*(H(i+1)-r)^2+ B*F(M+1)^2;
    end
end
end

function[X] = ActualizarRegresores(X,ny,nu,xnew,tr)
% tr    Tipo de regresor 0 Autorregresor
%                        1 Regresor

%Actualizar el valor en el vector de regresores
switch tr
    case 0
        for j=ny:-1:2
            X(j)=X(j-1);
        end
        X(1)=xnew;
        
    case 1
        if nu>1
            for j=ny+nu:-1:ny+1
                X(j)=X(j-1);
            end
        end
        X(ny+1)=xnew;
end
end
