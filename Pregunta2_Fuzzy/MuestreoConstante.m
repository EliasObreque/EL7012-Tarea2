function [r1,f1,h1,t1] = MuestreoConstante(r,f,h,t)
%Extaer del vector de datos los valores tomados con tiempo de muestreo 10 s
cant=0;
for i=1:length(t)
    if mod(t(i),10)==0
        cant=cant+1;
        r1(cant,1)=r(i);
        f1(cant,1)=f(i);
        h1(cant,1)=h(i);
        t1(cant,1)=t(i);
    end
end
end

