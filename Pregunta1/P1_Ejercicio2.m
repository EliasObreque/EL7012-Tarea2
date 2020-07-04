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
[x,fval_1] = fmincon(@fun_min,x0,[],[],[],[],lb,ub)
t1_ejecucion=toc% ó t1_computo=0.7070 seg
%fval_1=-0.6972 para [x*,y*]=[0.5228, 0.5228]
%Puedo evaluar fun(x) con x como vector fila o columna
f_max1=fun_max([0.5228;0.5228])


x0=[0.1 0.1];
tic
[x,fval_2] = fmincon(@fun_min,x0,[],[],[],[],lb,ub)
t2_ejecucion=toc% ó t2_computo=0.5648 seg
%fval_2=-0.9947 para [x*,y*]=[0.3873e-5, 0.3873e-5]


x0=[0.2 0.2];
tic
[x,fval_3] = fmincon(@fun_min,x0,[],[],[],[],lb,ub)
t3_ejecucion=toc% ó t1_computo=0.3619 seg
%fval_1=-0.9628 para [x*,y*]=[0.2079, 0.2079]


x0=[0.3 0.1];%Son puntos iniciales No simétricos
tic
[x,fval_4] = fmincon(@fun_min,x0,[],[],[],[],lb,ub)
t4_ejecucion=toc% ó t1_computo=0.2641 seg
%fval_1=-0.9628 para [x*,y*]=[0.2166, 0.1988]

x0=[0.1 0.1];%Son puntos iniciales No simétricos
tic
[x,fval_5] = fmincon(@fun_min,x0,[],[],[],[],lb,ub)
t5_ejecucion=toc

%Conclusion: Dependiendo del punto de busqueda inicial X0 vector
%se obtienen diferentes optimos ya que f(x,y) tiene 
%muchos máximos locales

%***PSO***
%Por defecto, el numero de particulas del enjambre es el minimo
%de 100 y 2*nvar, es decir: SwarmSize =min(100, 2*nvars)
lb=[0,0];ub=[1,1];%**Vectores fila
nvars = 2;
tic
x = particleswarm(@fun_min,nvars,lb,ub)
%**En una corrida me dio [x* y*]=[0 0] !!!
t_pso=toc

%Lo mismo anterior pero con mas informacion de la salida
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub)

%Otra con opciones
%options = optimoptions('particleswarm','SwarmSize',100,'HybridFcn',@fmincon);
options1 = optimoptions('particleswarm','SwarmSize',100);
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub,options1)

%Otra con maximo numero de iteraciones (apenas 10): default es 200*nvars
options2 = optimoptions('particleswarm','SwarmSize',100,'MaxIterations',50);
[x,fval,exitflag,output]=particleswarm(@fun_min,nvars,lb,ub,options2)

%****GA***
nvars = 2;

tic
[x,fval,exitflag,output,population,scores] = ga(@fun_min,nvars);
t_ga1=toc
%**Otra con cotas inferiores y superiores
lb=[0,0];ub=[1,1];%**Vectores fila
tic
[x,fval,exitflag,output,population,scores] = ga(@fun_min,nvars,[],[],[],[],lb,ub);
t_ga2=toc
