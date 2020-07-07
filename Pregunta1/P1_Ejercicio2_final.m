clear all;clc;
x=0:0.01:1; y=0:0.01:1;
[X,Y]=meshgrid(x,y);
fxy=exp(-2*log10(2)*(((sqrt(X.^2+Y.^2)-0.08)/0.854).^2))....
    .*sin(5*pi*(sqrt(X.^2+Y.^2).^0.75-0.1)).^2;

%Determinar el máximo de f(x,y)
figure(1)
mesh(X,Y,fxy)
xlabel('x')
ylabel('y')
zlabel('f(x,y)')

%Es equivalente a determinar el mínimo de -f(x,y)
fxy_min=-fxy;
figure(2)
mesh(X,Y,fxy_min)
xlabel('x')
ylabel('y')
zlabel('-f(x,y)')

lb=[0,0];ub=[1,1];%**Vectores fila
x0 = (lb + ub)/2;%X0=[0.5 0.5]

%x = fmincon(fun_min,x0,A,b,Aeq,beq,lb,ub)
tic
[x,fval_1] = fmincon(@fun_min,x0,[],[],[],[],lb,ub);
t1_ejecucion=toc% ó t1_computo=0.7070 seg
%fval_1=-0.6972 para [x*,y*]=[0.5228, 0.5228]
%Puedo evaluar fun(x) con x como vector fila o columna
x
f_max1=fun_max([0.5228;0.5228])
fmx1=fun_max(x)
fmax1=-fval_1 %Todas estas funciones son equivalentes

x0=[0 0];
%options = optimoptions(@fmincon,'Display','iter','Algorithm','sqp');
% tic
% [x,fval_2] = fmincon(@fun_min,x0,[],[],[],[],lb,ub,[],options);
% t2_ejecucion=toc% ó t2_computo=0.5648 seg
[x,fval_2] = fmincon(@fun_min,x0,[],[],[],[],lb,ub);
x
fmax2=-fval_2

x0=[0.2 0.2];
tic
[x,fval_3] = fmincon(@fun_min,x0,[],[],[],[],lb,ub);
t3_ejecucion=toc% ó t1_computo
x
fmax3=-fval_3


x0=[0.8 0.8];%Son puntos iniciales No simétricos
tic
[x,fval_4] = fmincon(@fun_min,x0,[],[],[],[],lb,ub);
t4_ejecucion=toc% 
x
fmax4=-fval_4

%Conclusion: Dependiendo del punto de busqueda inicial X0 vector
%se obtienen diferentes optimos ya que f(x,y) tiene 
%muchos máximos locales

%***PSO***
%Por defecto, el numero de particulas del enjambre es el minimo
%de 100 y 10*nvar, es decir: SwarmSize =min(100, 10*nvars)
%y por defecto, el máximo de iteraciones es 200*nvars
lb=[0,0];ub=[1,1];%**Vectores fila
nvars = 2;
% tic
% x = particleswarm(@fun_min,nvars,lb,ub)
% %**En una corrida me dio [x* y*]=[0 0] !!!
% t_pso1=toc

%Lo mismo anterior pero con mas informacion de la salida
tic
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub);
t_pso1=toc
x
fmax_pso1=-fval

options1 = optimoptions('particleswarm','SwarmSize',100);
tic
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub,options1);
t_pso2=toc
x
fmax_pso2=-fval

%Otra con maximo numero de iteraciones (apenas 50): default es 200*nvars
tic
options2 = optimoptions('particleswarm','SwarmSize',5,'MaxIterations',23);
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub,options2);
t_pso3=toc
x
fmax_pso3=-fval
output


%****Genetic Algorithm**********************
nvars = 2;

tic
[x,fval,exitflag,output,population,scores] = ga(@fun_min,nvars);
t_ga1=toc
x
fmax_ga1=-fval

%**Otra con cotas inferiores y superiores
lb=[0,0];ub=[1,1];%**Vectores fila
tic
[x,fval,exitflag,output,population,scores] = ga(@fun_min,nvars,[],[],[],[],lb,ub);
t_ga2=toc
x
fmax_ga2=-fval

%**Otra con despliegue
%options = optimoptions('ga','PlotFcn', @gaplotbestf,'PopulationSize',50,'MaxGenerations',64);

options = optimoptions('ga','PopulationSize',20,'MaxGenerations',37);
lb=[0,0];ub=[1,1];%**Vectores fila
tic
[x,fval,exitflag,output,population,scores] = ga(@fun_min,nvars,[],[],[],[],lb,ub,[],[],options);
t_ga3=toc
x
fmax_ga3=-fval
output
