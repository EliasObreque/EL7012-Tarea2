% Elias Obreque
% els.obrq@gmail.com
clc
clear all
close all
global best_auto_reg best_reg net_trained

best_regressor_mat = 'best_regressor.mat';
best_hidden_neurons_mat = 'best_hidden_neurons.mat';
NN_model_mat = 'NN_model.mat';
%% Regressors Selection

load(best_regressor_mat)

x_train = best_X.x_train;
x_test = best_X.x_test;
x_val = best_X.x_val;

y_train = best_Y.y_train;
y_test = best_Y.y_test;
y_val = best_Y.y_val;

clear best_X best_Y num_neu best_train_rmse
%% Optimal hidden neurons

load(best_hidden_neurons_mat)
%% NEURALNETWORK

load(NN_model_mat)


tescalon=180;
tsim=tescalon*6;
t1 = cputime;
sim('SimEstanqueNN',tsim)
t2 = cputime;
disp(t2-t1)
%%

e=RMSE(h(:,1),h(:,2))

figure ()
subplot(2,1,1), plot (tout,h(:,1))
hold on
subplot(2,1,1), plot (tout,h(:,2))
legend('Referencia','Salida','Location','northwest')
xlabel('Tiempo (s)')
ylabel('Nivel (cm)')
title('Nivel de agua en el estanque')
xlim([0 tsim])

subplot(2,1,2), plot (tout,f)
% legend('Frecuencia','Location','northwest')
xlabel('Tiempo (s)')
ylabel('Frecuencia (0-100%)')
title('Acción de control')
xlim([0 tsim])


