function [X, Y] = createMatrixInput(Dt, ry, ru, y_model, u, range_y_m, range_u_m, normalize)
%CREATEMATRIXINPUT Summary of this function goes here
%------------Contrucción del vector de datos
min_amp_y_m = range_y_m(1);
max_amp_y_m = range_y_m(2);

min_amp_u_m = range_u_m(1);
max_amp_u_m = range_u_m(2);

g_lower = y_model(y_model>min_amp_y_m);
u_lower = u(y_model>min_amp_y_m);
new_y_m = g_lower(g_lower<max_amp_y_m);
new_u   = u_lower(g_lower<max_amp_y_m);
if normalize == 1
    new_y_m = new_y_m/max_amp_y_m;
    new_u = new_u/max_amp_u_m;
end


f  = length(new_y_m);
Y  = zeros(Dt,1);
X  = zeros(Dt, ry + ru);
for i = f: -1 :f - Dt + 1
    Y(Dt, 1) = new_y_m(i);
    %Regresores de y
        for j = 1:ry
            X(Dt, j) = new_y_m(i - j);
        end
    %Regresores de u
        for j = 1:ru
            X(Dt, j + ry) = new_u(i - j);
        end
    Dt = Dt-1; 
end
end

