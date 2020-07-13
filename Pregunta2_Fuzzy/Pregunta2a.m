clear all, clc
t = cputime;
tescalon=180;
tsim=tescalon*6;
sim('SimEstanque2a',tsim)
clear('Xdatos');

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
time = cputime-t

