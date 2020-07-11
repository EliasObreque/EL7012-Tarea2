function [best_auto_reg, best_reg, best_X, best_Y] = RegressorsSelection(num_auto_reg,...
    num_reg, y_m, u_m, range_y_m, range_u_m, num_neu, normalize)

global train_prc test_prc val_prc

min_auto_reg = num_auto_reg(1);
max_auto_reg = num_auto_reg(2);

min_reg = num_reg(1);
max_reg = num_reg(2);

num_neu_min = num_neu(1);
num_neu_max = num_neu(2);
num_neu = floor((num_neu_max + num_neu_min)/2);

best_test_rmse = 100;
best_auto_reg = 0;
best_reg = 0;
RMSE_train = zeros(max_reg - min_reg, max_auto_reg - min_auto_reg);
RMSE_test = zeros(max_reg - min_reg, max_auto_reg - min_auto_reg);
RMSE_val = zeros(max_reg - min_reg, max_auto_reg - min_auto_reg);
best_X = struct('x_train', 0, 'x_test', 0, 'x_val', 0);
best_Y = struct('y_train', 0, 'y_test', 0, 'y_val', 0);
for reg_y = min_auto_reg:max_auto_reg
    for reg_u = min_reg:max_reg
        total_data = length(y_m);
        Dt = floor(total_data/reg_y);
        [X, Y] = createMatrixInput(Dt, reg_y, reg_u, y_m, u_m, range_y_m, range_u_m, normalize);
        
        [trainInd, testInd, valInd] = divideblock(Dt, train_prc, test_prc, val_prc);
        
        x_train = X(trainInd, :);
        y_train = Y(trainInd);
        x_test  = X(testInd, :);
        y_test  = Y(testInd);
        x_val   = X(valInd, :);
        y_val   = Y(valInd);
   
                % NEURALNETWORK
        [net_trained, tr] = NeuralNetwork(num_neu, x_train, y_train,...
            x_test, y_test, x_val, y_val);

        y_train_nn = net_trained(x_train');
        y_test_nn = net_trained(x_test');
        y_val_nn = net_trained(x_val');
        
        % RMSE
        rmse_train = RMSE(y_train, y_train_nn');
        rmse_test  = RMSE(y_test, y_test_nn')
        rmse_val   = RMSE(y_val, y_val_nn');
        RMSE_train(reg_u-min_reg + 1, reg_y - min_auto_reg + 1) = rmse_train;
        RMSE_test(reg_u-min_reg + 1, reg_y - min_auto_reg + 1) = rmse_test;
        RMSE_val(reg_u-min_reg + 1, reg_y - min_auto_reg + 1) = rmse_val;
        
        if rmse_test < best_test_rmse
            disp(['RMSE train: ', num2str(rmse_train), ', RMSE test: ',...
                num2str(rmse_test), ', RMSE: ', num2str(rmse_val)])
            best_test_rmse = rmse_test;
            best_auto_reg = reg_y;
            best_reg = reg_u;
            best_X.x_train = x_train;
            best_X.x_test = x_test;
            best_X.x_val = x_val;
            
            best_Y.y_train = y_train;
            best_Y.y_test = y_test;
            best_Y.y_val = y_val;
            
            disp(['Best auto-reg: ', num2str(best_auto_reg),...
                ', Best reg: ', num2str(best_reg)])
        end
    end
end

fig_1 = figure('Name', 'RMSE for Train');
hold on
grid on
xlabel('y(k - ny)')
ylabel('f(k - nf)')
zlabel('RMSE')
[X,Y] = meshgrid(min_auto_reg:max_auto_reg, min_reg:max_reg);
surf(X, Y, RMSE_train)

fig_2 = figure('Name', 'RMSE for Test');
hold on
grid on
xlabel('y(k - ny)')
ylabel('f(k - nf)')
zlabel('RMSE')
[X,Y] = meshgrid(min_auto_reg:max_auto_reg, min_reg:max_reg);
surf(X, Y, RMSE_test)

fig_3 = figure('Name', 'RMSE for Validation');
hold on
grid on
xlabel('y(k - ny)')
ylabel('f(k - nf)')
zlabel('RMSE')
[X,Y] = meshgrid(min_auto_reg:max_auto_reg, min_reg:max_reg);
surf(X, Y, RMSE_val)


best_regressor_mat = 'best_regressor.mat';
if normalize == 1
   best_regressor_mat = sprintf('%s%s%s', 'best_regressor','_normalized','.mat');
end
save(best_regressor_mat,'best_test_rmse','best_auto_reg', 'best_reg',...
    'num_neu', 'best_Y', 'best_X')
end

