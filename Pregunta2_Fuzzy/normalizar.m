function [valor] = normalizar(v,rango,rangoN)
%v                  Vector a normalizar
%rango              Intervalo de la variable a normalizar [min max]
%rangoN             Intervalo del vector normalizado
%valor              Vector normalizado

a=rangoN(1);
b=rangoN(2);

for i=1:length(v)
    if v(i)<rango(1)
        valor(i,1)=a;
    elseif v(i)>rango(2)
        valor(i,1)=b;
    else
        valor(i,1)=a+(b-(a))*(v(i)-rango(1))/(rango(2)-rango(1));
    end
end
end


