%Script para el preprocesamiento de los datos y creación de los conjuntos
%de Entrenamiento, Prueba y Validación

clear all, clc
load('DataEstanque.mat')
% 
% % % % %------------Contrucción del vector de datos-------------------
[Ref,Entrada,Salida,Tiempo] = MuestreoConstante(Ref,Entrada,Salida,Tiempo);
%60% para entrenamiento
%20% test y 20% validación
Dt=69990;         %Tamaño del vector
% y=normalizar(Salida,[15 50],[0 1]);  %Normalizar la altura de [15 55] a [0 1]
% u=normalizar(Entrada,[0 100],[0 1]); %Normalizar le frecuencia de [0 100] a [0 1]
y=Salida;  
u=Entrada; 
ry=8;       %Numero de regresores en y
ru=2;       %Numero de regresores en u
[X, Y] = createMatrixInput(Dt, ry, ru, y, u);

le=Dt*0.6;      %Limites de los conjuntos de entrenamiento y prueba
lp=Dt*(0.6+0.2);

Xent = X(1:le,:);
Yent = Y(1:le,:);
Xtest = X(le+1:lp, :);
Ytest = Y(le+1:lp, :); 
Xval = X(lp+1:Dt, :);
Yval = Y(lp+1:Dt, :);

savefile = 'DatosProblema2_r10.mat';
save(savefile, 'Xent', 'Xtest','Xval', 'Yent', 'Ytest', 'Yval');