% Elias Obreque
% els.obrq@gmail.com
clc
clear all
close all
global best_auto_reg best_reg net_trained time_prom counter_time
time_prom = 0;
counter_time = 1;
best_regressor_mat = 'best_regressor.mat';
best_hidden_neurons_mat = 'best_hidden_neurons.mat';
NN_model_mat = 'NN_model.mat';
%% Regressors Selection

load(best_regressor_mat)

clear best_X best_Y num_neu best_train_rmse
%% Optimal hidden neurons

load(best_hidden_neurons_mat)
%% NEURALNETWORK

load(NN_model_mat)

tescalon=180;
tsim=tescalon*5;
t1 = cputime;
sim('SimEstanqueNN',tsim)
t2 = cputime;
fprintf('Tiempo de simulación: %f0.1 \n', t2-t1)
fprintf('Tiempo de cálculo promedio: %f0.1 \n', time_prom/counter_time)
%%

e = RMSE(h(:,1),h(:,2))

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


