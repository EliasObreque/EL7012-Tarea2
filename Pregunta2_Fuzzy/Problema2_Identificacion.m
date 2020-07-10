clear all, clc
% %---------------------Modelo Difuso--------------------------------------
% %-----------------Analisis de sensibilidad-------------------------------
load('DatosProblema2_r12');
% % % ---------------Seleccion del número óptimo de clusters-------------------
% % % max_clusters=15;
% % % [errtest,errent] = clusters_optimo(Ytest,Yent,Xtest,Xent,max_clusters);
reglas=12; %Clusters
%-----Obtención modelo. Parametros antecedentes y consecuentes-------------
MD=[1 2 2]; %Metodo de clusterin difuso a utilizar MD(2)=1 GK   MD(2)=2 Fuzzy C-Means
[model_r12, result_r12]=TakagiSugeno(Yent,Xent,reglas,MD);

% Comprobación del modelo difuso
y_r12_e=ysim(Xent,model_r12.a,model_r12.b,model_r12.g);
y_r12_t=ysim(Xtest,model_r12.a,model_r12.b,model_r12.g);
y_r12_v=ysim(Xval,model_r12.a,model_r12.b,model_r12.g);

e_r12(1,1)=RMSE(Yent,y_r12_e);
e_r12(2,1)=MAPE(Yent,y_r12_e);
e_r12(3,1)=MAE(Yent,y_r12_e);
e_r12(1,2)=RMSE(Ytest,y_r12_t);
e_r12(2,2)=MAPE(Ytest,y_r12_t);
e_r12(3,2)=MAE(Ytest,y_r12_t);
e_r12(1,3)=RMSE(Yval,y_r12_v);
e_r12(2,3)=MAPE(Yval,y_r12_v);
e_r12(3,3)=MAE(Yval,y_r12_v);

%----------Seleccion de Variables Relevantes---------------------------
% [~, v]=size(Xent);
% errS=zeros(v,1);
% VarDelete=zeros(v,1);
% varD=1:v;
% for i=v:-1:1
%     % Calcular el error con el numero de cluster (reglas)
%     errS(i)=errortest(Yent,Xent,Ytest,Xtest,reglas);
%     
%     % Analisis de sensibilidad
%     [p, indice]=sensibilidad(Yent,Xent,reglas);
%     VarDelete(i)=p;
%     Xent(:,p)=[];
%     Xtest(:,p)=[];
%     Xval(:,p)=[];
%     varD(p)
%     varD(p)=[];
% end
% 
% % % % %Gráfico Sensibilidad
% figure()
% c = categorical({'y(k-1)','y(k-2)','y(k-3)','u(k-1)'},{'y(k-1)','y(k-2)','y(k-3)','u(k-1)'});
% bar(c,indice,'b','LineWidth',2);
% xlabel('Variables de entrada')
% ylabel('I')

%-------------- Seleccion del número óptimo de clusters--------------------
load('DatosProblema2_r4');
% % max_clusters=15;
% [errtest,errent] = clusters_optimo(Ytest,Yent,Xtest,Xent,max_clusters);
reglas=12; %Clusters
%-----Obtención modelo. Parametros antecedentes y consecuentes-------------
[model_r4, result_r4]=TakagiSugeno(Yent,Xent,reglas,MD);

% Comprobación del modelo difuso
y_r4_e=ysim(Xent,model_r4.a,model_r4.b,model_r4.g);
y_r4_t=ysim(Xtest,model_r4.a,model_r4.b,model_r4.g);
y_r4_v=ysim(Xval,model_r4.a,model_r4.b,model_r4.g);

e_r4(1,1)=RMSE(Yent,y_r4_e);
e_r4(2,1)=MAPE(Yent,y_r4_e);
e_r4(3,1)=MAE(Yent,y_r4_e);
e_r4(1,2)=RMSE(Ytest,y_r4_t);
e_r4(2,2)=MAPE(Ytest,y_r4_t);
e_r4(3,2)=MAE(Ytest,y_r4_t);
e_r4(1,3)=RMSE(Yval,y_r4_v);
e_r4(2,3)=MAPE(Yval,y_r4_v);
e_r4(3,3)=MAE(Yval,y_r4_v);

%------------Grafica de los modelos. Conjunto de validación.---------------  
figure ()
plot(Yval)
hold on
plot(y_r4_v,'--')
legend('Modelo real','Estimación Modelo Difuso')
xlabel('t')
ylabel('Salida del modelo')% %Evaluación del modelo Original
xlim([0 1800])



