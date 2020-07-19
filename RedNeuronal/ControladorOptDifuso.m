function [u] = ControladorOptDifuso(r,h,f)
global reg_count best_auto_reg best_reg net_trained counter_time time_prom
tm=10;
A=2;
B=0.001;
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
    tinit = cputime; 
    fun = @(x)myfunMNN(x,r,h,f,tm,A,B,N,M, modelo, Xdatos,ny,nu);

    %% Algoritmo de Optimización Convencional
    %x0=zeros(1,nvars);
    %options = optimoptions(@fmincon,'Display','off','MaxIterations',100,'StepTolerance',1e-3,'OptimalityTolerance',1e-3);
    %F = fmincon(fun,x0,[],[],[],[],lb,ub,[],options);
    %% PSO
    %options = optimoptions('particleswarm','SwarmSize',20,'MaxIterations', 10);
    %options = optimoptions('particleswarm','SwarmSize',20,'MaxIterations', 30);
    %[F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);
     %% GA
    options = optimoptions('ga','PopulationSize',20,'MaxGenerations', 10);
    %options = optimoptions('ga','PopulationSize',40,'MaxGenerations', 30);
    [F,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],lb,ub,[],[],options);

    u=F(1);
    tout = cputime;
    time_prom = time_prom + tout-tinit;
    fprintf('Tiempo de cálculo %f1.2 \n', tout-tinit)
    counter_time = counter_time + 1;
end
end

function [J] = myfunMNN(F,r,h,f,tm,A,B,N,M,modelo,X,ny,nu)
H(1) = modelo(X'); 

if H(1)<15 %Restricción física del nivel en el tanque
    H(1)=15;
elseif H(1)>50
    H(1)=50;
end
    
J=0;
%itera = itera + 1

for i=1:N
    X=ActualizarRegresores(X,ny,nu,H(i),0); %Actualizar el valor estimado
    
    if i<=M+1 %En caso contrario se maniene la ultima acción de control estimada
        X=ActualizarRegresores(X,ny,nu,F(i),1);
    end
    
    H(i+1) = modelo(X');
    if H(i+1)<15 %Restricción física del nivel en el tanque
        H(i+1)=15;
    elseif H(i+1)>50
        H(i+1)=50;
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