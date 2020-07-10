% Elias Obreque
% els.obrq@gmail.com

clc
clear all
close all

%------------Generar Datos del modelo------------
global train_prc test_prc val_prc
loaded_data = load('DataEstanque.mat');

y_m = loaded_data.Salida;
u_m = loaded_data.Entrada;
ref_m = loaded_data.Ref;
time_m = loaded_data.Tiempo;

normalize = 1;
best_regressor_mat = 'best_regressor.mat';
best_hidden_neurons_mat = 'best_hidden_neurons.mat';

if normalize == 1
   best_regressor_mat = sprintf('%s%s%s', 'best_regressor','_normalized','.mat');
   best_hidden_neurons_mat = sprintf('%s%s%s', 'best_hidden_neurons','_normalized','.mat');
end


[y_m, u_m, ref_m, time_m] = MuestreoConstante(y_m, u_m, ref_m, time_m);

figure ()
hold on
plot(y_m)
plot(u_m)
grid on
xlim([0 2000])
xlabel('Número de muestras')
ylabel('Salida del modelo')
legend('h(k)', 'u(k)')

% minimum and maximum value of auto-regresors
num_auto_reg = [3 12];
% minimum and maximum value of regresors
num_reg = [1, 6];
% range of hidden neurons
num_neurons = [2, 21];
% range of amplitude of y_model
range_y_m = [15, 50];
% range of amplitude of u_model
range_u_m = [0, 100];

train_prc = 0.6;
test_prc = 0.2;
val_prc = 0.2;

%% Regressors Selection

if exist(best_regressor_mat, 'file') == 0
    [best_auto_reg, best_reg, best_X, best_Y] = RegressorsSelection(num_auto_reg,...
        num_reg, y_m, u_m, range_y_m, range_u_m, num_neurons, normalize);
else
    load(best_regressor_mat)
end

x_train = best_X.x_train;
x_test = best_X.x_test;
x_val = best_X.x_val;

y_train = best_Y.y_train;
y_test = best_Y.y_test;
y_val = best_Y.y_val;

clear best_X best_Y num_neu best_train_rmse

%% Optimal hidden neurons
if exist(best_hidden_neurons_mat, 'file')==0
    [best_hidden_neurons] = Identification(best_auto_reg, best_reg, x_train, y_train, x_test,...
        y_test, x_val, y_val, num_neurons, normalize);
else
    load(best_hidden_neurons_mat)
end
NUM_OPT_NEU = best_hidden_neurons;

%% NEURALNETWORK
[net_trained, tr] = NeuralNetwork(NUM_OPT_NEU, x_train, y_train, x_test, y_test, x_val, y_val);


%% Sensitivity analysis
I = SensitivityCalc('tanh', best_auto_reg + best_reg, x_test, net_trained);
regressors_name = cell(1, best_auto_reg + best_reg);
y_k = 'y(k-';
y_fi = ')';
for i=1:best_auto_reg
    regressors_name{i} =  sprintf('%s%d%s',y_k, i, y_fi);
end
u_k = 'u(k-';
u_fi = ')';
for i=1:best_reg
    regressors_name{i + best_auto_reg} =  sprintf('%s%d%s',u_k, i, u_fi);
end
fig_i = figure('Name', 'Indicator by number of neurons');
hold on
grid on
xlabel('Regresors')
bar(I)
ylabel(join(['I - ', num2str(NUM_OPT_NEU), ' nn']))
set(gca(fig_i), 'XTick', [1:best_auto_reg + best_reg], 'xticklabel', regressors_name);

%%
y_train_nn = net_trained(x_train');
y_test_nn = net_trained(x_test');
y_val_nn = net_trained(x_val');

error_train = y_train - y_train_nn';
error_test  = y_test - y_test_nn';
error_val   = y_val- y_val_nn';


figure()
grid on
hold on
plot(error_train)
plot(error_test)
plot(error_val)
legend('train','test','val')

%%
rmse_train = RMSE(y_train, y_train_nn')
rmse_test = RMSE(y_test, y_test_nn')
rmse_val = RMSE(y_val, y_val_nn')

mse_train = MSE(y_train, y_train_nn')
mse_test = MSE(y_test, y_test_nn')
mse_val = MSE(y_val, y_val_nn')

mae_train = MAE(y_train, y_train_nn')
mae_test = MAE(y_test, y_test_nn')
mae_val = MAE(y_val, y_val_nn')

mape_train = MAPE(y_train, y_train_nn')
mape_test = MAPE(y_test, y_test_nn')
mape_val = MAPE(y_val, y_val_nn')

%%
% Plot Histogram of Error Values
figure()
ploterrhist(error_train,'Train', error_test, 'Test', error_val, 'Validation')

% plots error vs. epoch for the training, validation, and test performances of the training record TR 
figure()
plotperform(tr)

figure()
stairs(y_val_nn)
hold on
grid on
ylabel('y(k)')
xlabel('Número de muestras')
stairs(y_val)
legend('NN-Validación', 'Dato Real')

figure()
stairs(y_test_nn)
hold on
grid on
ylabel('y(k)')
xlabel('Número de muestras')
stairs(y_test)
legend('NN-Prueba', 'Dato Real')

figure()
stairs(y_train_nn)
hold on
grid on
ylabel('y(k)')
xlabel('Número de muestras')
stairs(y_train)
legend('NN-Entrenamiento', 'Dato Real')

