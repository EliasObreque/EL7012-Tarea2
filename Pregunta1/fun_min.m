function fxy_min = fun_min(x)

 fxy_min=-exp(-2*log10(2)*(((sqrt(x(1)^2+x(2)^2)-0.08)/0.854)^2))....
    *sin(5*pi*(sqrt(x(1)^2+x(2)^2)^0.75-0.1))^2;

end
