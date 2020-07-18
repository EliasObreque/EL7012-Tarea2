function [y_j_train, y_j_test, y_j_val] = predictiveNN(jpasos, net_trained, X)
%PREDICTIVENN Summary of this function goes here


u_new = X(3);
y_new_2 = X(1);
y_train_new_1 = net_trained(X');
y_train_new_1 = y_train_new_1;
x_train_new = [y_train_new_1', y_train_new_2, u_train_new];
y_train_new = net_trained(x_train_new');
%--------------------------------

% > 2
for i=3: jpasos
    u_train_new = u_train_new(2:end);
    
    y_train_new_2 = y_train_new_1(1:end-1);
    
    y_train_new_1 = y_train_new(1:end - 1);
    
    x_train_new = [y_train_new_1', y_train_new_2', u_train_new];
    
    y_train_new = net_trained(x_train_new');
end

y_j_train = y_train_new;
end

