function [u] = ControladorOptDifuso(r,h,f)
A=2;
B=0.001;
N=5;
M=5; %Se debe cumplir M<=N

%Modelo Difuso
% modeloDifuso=load('ModeloDifuso.mat');
modeloDifuso.a=[1.65523845354286,1.61738179188616,1.55480463705407,...
    1.40275369008744;1.01918659608978,0.964329553932022,0.893795537563110,...
    0.523094342231218;1.12985326052852,1.05260861206745,0.916901526906175,...
    0.258641456754172;0.757624405979565,0.700978704522245,0.641672662821370,...
    0.131570567725774;0.877256392536296,0.821245314084571,0.754376578175274,...
    0.272478106404203;1.18325057643551,1.09728968532681,0.916433384679272,...
    0.128787995560508;1.08534660991113,1.01477715480756,0.905453607053500,...
    0.385176232033549;0.980139206432995,0.779421073781875,0.614188531939691,...
    0.0659253673250653;1.33786985192020,1.28473922057710,1.17305146389867,...
    0.230145311377505;0.973374788158436,0.907476185205101,0.804027494737238,...
    0.359506593351749;0.462871296692932,0.351118886715029,0.302370651519114,...
    0.0447758009169110;1.09543208542924,0.910833344192901,0.775904836015932,...
    0.109644556938424];
modeloDifuso.b=[15.2880129125859,15.2969419269846,15.3093683533975,...
    0.109657279978960;18.9198341538184,18.9645250725202,19.0137386870847,...
    1.15999245291869;32.1745684168247,32.1813776737781,32.1853053209584,...
    6.45547879354643;28.8127697649067,28.8149784903104,28.8137464372300,...
    5.45930385185996;35.4409911262157,35.4494460747892,35.4529552707414,...
    7.34771397498624;41.0285966705623,41.0292781557254,41.0244503701959,...
    9.66767866225886;25.7434882845968,25.7730303227053,25.8019204871733,...
    3.43799118939123;48.6459589540824,48.6491380754217,48.6460638976717,...
    11.3507900716607;43.3266373287903,43.3304554237794,43.3282303593642,...
    9.92074570730534;22.4641355648421,22.4854346273507,22.5068138950213,...
    2.75539664931320;37.6550303472464,37.6527330657577,37.6445397080925,...
    9.36373280415364;45.9549973521332,45.9574307680130,45.9556611225075,...
    10.6818287862635];
modeloDifuso.g=[0.844784985997041,1.28855141731743,-0.507870919118721,...
    0.163193608341007,0.153102767760164;0.598790673022443,1.08266586798618,...
    -0.0933487390978863,-0.0292227323526615,0.110215699089912;...
    1.69747547847447,1.53254803133914,-0.661601307161430,0.0696585965405350,...
    0.0297731437896873;0.581040816081478,0.807332474398230,0.190967692045937,...
    -0.0318803343156632,0.0701686449529222;-0.318834094977574,3.81656638401542,...
    -2.68744774605777,-0.128657305413926,0.0127943015282194;4.40258687691199,...
    1.59227461742009,-0.538635175906080,-0.159172286377318,0.00196724723847814;...
    0.233822791250381,1.24635153001187,0.213533017414194,-0.471812264791561,...
    0.0164363563643807;0.192120976335142,0.714970020618935,0.292878895891530,...
    -0.0175524917668358,0.0235193262639762;1.12828756393668,0.962365492152996,...
    0.0182656082256434,-0.0135852170425138,0.0305139211357976;0.150540079682740,...
    1.02265143144053,-0.0154942633203380,-0.0249077192510789,0.0837174039433440;...
    5.09036290116323,0.768988723193212,0.0439037847756623,0.0429284506271254,...
    0.0411212339073790;0.112161508490776,0.724737791915295,0.265710368046338,...
    -0.00161867151572366,0.0370896031674175];

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

%Optimización
lb=zeros(1,M+1);
ub=100 * ones(1, M+1);%**Vectores fila
nvars = M+1;
fun = @(x)myfunMD(x,r,A,B,N,M,modeloDifuso,Xdatos,ny,nu);

% % %Algoritmo de Optimización Convencional
% x0=zeros(1,nvars);
% options = optimoptions(@fmincon,'Display','off','MaxIterations',100,'StepTolerance',1e-3,'OptimalityTolerance',1e-3);
% F= fmincon(fun,x0,[],[],[],[],lb,ub,[],options);


% %PSO
options = optimoptions('particleswarm','SwarmSize',20,'MaxIterations',100);
[F,fval,exitflag,output]= particleswarm(fun, nvars, lb, ub,options);

% % GA
% options = optimoptions('ga','PopulationSize',40,'MaxGenerations',100);
% [F,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],lb,ub,[],[],options);

u=F(1);
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
