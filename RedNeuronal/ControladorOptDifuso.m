function [u] = ControladorOptDifuso(r,h,f)
global reg_count best_auto_reg best_reg net_trained
tm=10;
A=10;
B=0.01;
N=5;
M=5; %Se debe cumplir M<=N

% Modelo neuronal
ny = best_auto_reg;
nu = best_reg;
modelo = net_trained;

%Construcción del vector de regresores
if exist('XDatos.mat', 'file')
    load('XDatos.mat');
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

save('XDatos','Xdatos');

%Optimización
lb = zeros(1,M);
ub = 100 * ones(1, M);%**Vectores fila
nvars = N;
if reg_count < ny
    u = 0;
    reg_count = reg_count + 1;
else
    fun = @(x)myfunMNN(x,r,h,f,tm,A,B,N,M, modelo, Xdatos,ny,nu);

    %% Algoritmo de Optimización Convencional
%     x0=zeros(1,nvars);
%     [F,fval] = fmincon(fun,x0,[],[],[],[],lb,ub);

    %% PSO
      options = optimoptions('particleswarm','SwarmSize',40,'MaxIterations',100);
      [F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);
     %% GA
%    [F,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],lb,ub);

    u=F(1);
end
end

function [J] = myfunMNN(F,r,h,f,tm,A,B,N,M,modelo,X,ny,nu)

J=0;
for i=1:N
    % H(i)=ysim(X,modeloDifuso.a,modeloDifuso.b,modeloDifuso.g);
    H(i) = modelo(X'); 

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
