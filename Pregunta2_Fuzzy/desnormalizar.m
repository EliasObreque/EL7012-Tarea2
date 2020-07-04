function [valor] = desnormalizar(v,rango,rangoN)
%v                  Vector a desnormalizar
%rango [min max]    Rango del intervalo a normalizar
%rangoN             %Rango del vector normalizado
%valor              Vector desnormalizado

min=rangoN(1);
max=rangoN(2);

for i=1:length(v)
    valor(i,1)=(v(i)+max)*(rango(2)-rango(1))/(max-(min))+rango(1);
end

end

