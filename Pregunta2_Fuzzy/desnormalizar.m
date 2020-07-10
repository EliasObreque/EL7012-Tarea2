function [valor] = desnormalizar(v,rango,rangoN)
%v                  Vector a desnormalizar
%rango              Rango de la variable a normalizar [min max]
%rangoN             Rango del vector normalizado
%valor              Vector desnormalizado

a=rangoN(1);
b=rangoN(2);

for i=1:length(v)
    valor(i,1)=(v(i)-a)*(rango(2)-rango(1))/(b-(a))+rango(1);
end

end

