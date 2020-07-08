"""
Created: 7/4/2020
Autor: Elias Obreque Sepulveda
email: els.obrq@gmail.com

"""
from mpl_toolkits import mplot3d
import matplotlib.pyplot as plt
import P1.P1tools as p1_tools


x_func, y_func, z_func = p1_tools.get_values_function()

fig_real_function = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(x_func, y_func, z_func, rstride=1, cstride=1,
                        cmap='viridis', edgecolor='none')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('f(x, y)')
plt.show()




