function [valor] = normalizar(v,rango,rangoN)
%v                  Vector a normalizar
%rango [min max]    Rango del intervalo a normalizar
%rangoN             %Rango del vector normalizado
%valor              Vector normalizado

min=rangoN(1);
max=rangoN(2);

for i=1:length(v)
    if v(i)<rango(1)
        valor(i,1)=min;
    elseif v(i)>rango(2)
        valor(i,1)=max;
    else
        valor(i,1)=min+(max-(min))*(v(i)-rango(1))/(rango(2)-rango(1));
    end
end
end

