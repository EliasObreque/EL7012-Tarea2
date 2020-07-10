function [r1,f1,h1,t1] = MuestreoConstante(r,f,h,t)
%Extaer del vector de datos los valores tomados con tiempo de muestreo 10 s
r1 = r(mod(t, 10)==0);
f1 = f(mod(t, 10)==0);
h1 = h(mod(t, 10)==0);
t1 = t(mod(t, 10)==0);
end

