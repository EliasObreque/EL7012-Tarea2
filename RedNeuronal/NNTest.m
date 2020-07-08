clc
clear all
close all

%------------Generar Datos del modelo------------
Nd = 6000;         %N�mero de datos

fmin = 0.2;        %frecuencia m�nima
fmax = 1;         %frecuencia m�xima
Ts   = 0.01;      %Tiempo de muestreo
a    = -1;        %[a b] Amplitud de la se�al
b    = 1;
gain_aprbs = 4;

num_regresor_y = 2;
num_regresor_u = 1;
num_regresor = num_regresor_y  + num_regresor_u;

loaded_data = load('P_DatosProblema1.mat');

y_model = loaded_data.y;
aprbs = loaded_data.u;

figure ()
stairs(y_model)
hold on
stairs(aprbs)
% stairs(e)
xlim([1 90])
xlabel('N�mero de muestras')
ylabel('Amplitud')
legend('y(k)', 'u(k)')
title('Serie no lineal din�mica')

% Contrucci�n del vector de datos con Nd datos ajustable
% X: y(k-1), ..., y(k-ry), u(k - 1), ..., u(k - ru)
ry = num_regresor_y;
ru = num_regresor_u;

x_train = loaded_data.Xent;
y_train = loaded_data.Yent;
x_test = loaded_data.Xtest;
y_test = loaded_data.Ytest;
x_val = loaded_data.Xval;
y_val = loaded_data.Yval;

%Elimina el ultima regresor
x_train(:, 4) = [];
x_test(:, 4) = [];
x_val(:, 4) = [];

% Porcentaje de cada set
train_prc = 0.5;
test_prc = 0.25;
val_prc = 0.25;

ntrain = Nd * train_prc;
ntest = Nd * test_prc;
nval = Nd * val_prc;

% Numero optimo de neuronas calculadas en Identification.m
NUM_OPT_NEU = 10;


%% NEURALNETWORK
[net_trained, tr] = NeuralNetwork(NUM_OPT_NEU, x_train, y_train, x_test, y_test, x_val, y_val);%, test_prc, val_prc);

%% Sensitivity analysis
I = SensitivityCalc('tanh', num_regresor, x_test, net_trained);

fig_i = figure('Name', 'Indicator by number of neurons');
hold on
grid on
xlabel('Regresors')
bar(I)
ylabel(join(['I - ', num2str(NUM_OPT_NEU), ' nn']))
regresors_name = {'y(k-1)','y(k-2)','u(k-1)'}%,'u(k-2)'};
set(gca(fig_i), 'XTick', [1:3], 'xticklabel', regresors_name);

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
xlabel('N�mero de muestras')
stairs(y_val)
xlim([1 200])
legend('NN-Validaci�n', 'Dato Real')




