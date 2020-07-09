function [best_hidden_neurons] = Identification(best_auto_reg, best_reg, x_train, y_train, x_test,...
        y_test, x_val, y_val, num_neu)
% Elias Obreque
% els.obrq@gmail.com

num_neu_min = num_neu(1);
num_neu_max = num_neu(2);

max_row = 5; max_col = 4;

I = zeros(num_neu_max - num_neu_min, best_auto_reg + best_reg);

rmse_train = zeros(1, num_neu_max - num_neu_min);
rmse_test  = zeros(1, num_neu_max - num_neu_min);
rmse_val   = zeros(1, num_neu_max - num_neu_min);

for num_neu = num_neu_min: 1: num_neu_max
    % NEURALNETWORK
    [net_trained, tr] = NeuralNetwork(num_neu, x_train, y_train, x_test,...
        y_test, x_val, y_val);

    y_train_nn = net_trained(x_train');
    y_test_nn = net_trained(x_test');
    y_val_nn = net_trained(x_val');
    
    % Sensitivity analysis
    % Datos de entrenamiento
    I(num_neu, :) = SensitivityCalc('tanh', best_auto_reg + best_reg, x_train, net_trained);

    % RMSE
    rmse_train(num_neu - num_neu_min + 1) = RMSE(y_train, y_train_nn');
    rmse_test(num_neu - num_neu_min + 1)  = RMSE(y_test, y_test_nn');
    rmse_val(num_neu - num_neu_min + 1)   = RMSE(y_val, y_val_nn');
end
%%
fig1 = figure('Name', 'Indicator by number of neurons', 'Position', [100 50 600 600]);
if (num_neu_max > max_row*max_col + 1)
    fig2 = figure('Name', 'Indicator by number of neurons');
end
for num_neu = num_neu_min: num_neu_max
    if num_neu <=21
        figure(fig1)
        if (num_neu - num_neu_min + 1) == max_col
            ax11 = subplot(max_row, max_col, num_neu - num_neu_min + 1);
        elseif (num_neu - num_neu_min + 1) == (1 + max_col*(max_row - 1))
            ax12 = subplot(max_row, max_col, num_neu - num_neu_min + 1);
        end  
        subplot(max_row, max_col, num_neu - num_neu_min + 1)          
    else
        figure(fig2)
        if (num_neu - num_neu_min + 1) == max_col + max_col*max_row
            ax21 = subplot(max_row, max_col,  num_neu - max_row*max_col - 1);
        elseif (num_neu - num_neu_min + 1) == (1 + max_col*(max_row - 1)) + max_col*max_row
            ax22 = subplot(max_row, max_col, num_neu - max_row*max_col - 1);
        end  
        subplot(max_row, max_col, num_neu - max_row*max_col - 1)
    end
    hold on
    grid on
    xlabel('Regresors')
    bar(I(num_neu, :))
    ylabel(join(['I-', num2str(num_neu), 'N_h']))
end
%%
fig_rmse = figure('Renderer', 'painters', 'Units', 'centimeters', 'Position', [4 4 18 10])
axes_rmse = axes('Parent', fig_rmse);
hold on
grid on
%set(gca, 'YScale', 'log')
ylabel('RMSE')
xlabel('Número de neuronas')
[n1, m1] = min(rmse_train);
plot(m1 + num_neu_min - 1, n1, '*b', 'DisplayName', 'min-Train')
[n2, m2] = min(rmse_test);
best_hidden_neurons = m2 + num_neu_min - 1;
plot(best_hidden_neurons, n2, '*r', 'DisplayName', 'min-Test')
[n3, m3] = min(rmse_val);
plot(m3 + num_neu_min - 1, n3, '*k', 'DisplayName', 'min-Validation')
plot(num_neu_min:num_neu_max, rmse_train, 'b','DisplayName','Train')
plot(num_neu_min:num_neu_max, rmse_test, 'r','DisplayName','Test')
plot(num_neu_min:num_neu_max, rmse_val, 'k','DisplayName','Validation')
legend()
%InSet_rmse = get(axes_rmse, 'TightInset');
% set(gca(fig_rmse), 'Position', [InSet_rmse(1:2), 1-InSet_rmse(1)-InSet_rmse(3), 1-InSet_rmse(2)-InSet_rmse(4)]);
% create a new pair of axes inside current figure
% axes('position',[.23 .5 .5 .42])
%box on % put box around new pair of axes
%plot(num_neu_min:num_neu_max, rmse_test, 'r')
%hold on 
%grid on
%plot(m2 + num_neu_min - 1, n2, '*r')
%ylim([2.5e-3, 3e-3])
%xlim([2, 41])
%% PLOT

% plots error vs. epoch for the training, validation, and test performances of the training record TR 
figure()
plotperform(tr)
% Plot training state values
figure()
plottrainstate(tr)
save('best_hidden_neurons.mat', 'best_hidden_neurons')
return
