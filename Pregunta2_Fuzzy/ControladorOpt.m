function [u] = ControladorOpt(r,h,f)
tm=10;
A=1;
B=1;
N=2;
M=2;

F=sym('F%d',[1,max(N,M+1)]);
H=sym('H%d',[1,1+N]);
H(1)=(5.43*f+78.23-20.21*sqrt(h))/(0.63*h^2+11.4*h+17.1)*tm+h;
J=0;

for i=1:N
    H(i+1)=(5.43*F(i)+78.23-20.21*sqrt(H(i)))/(0.63*(H(i))^2+11.4*H(i)+17.1)*tm+H(i);
    J=J+A*(H(i+1)-r)^2;
end

for j=1:M
    J=J+B*F(j+1)^2;
end


 u=10*h;
end

