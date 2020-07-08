"""
Created: 7/4/2020
Autor: Elias Obreque Sepulveda
email: els.obrq@gmail.com

"""

import numpy as np


def function_p1(x, y):
    f_xy = np.exp(-2 * np.log(2) * ((np.sqrt(x**2 + y**2) - 0.08)/0.854) ** 2) *\
           np.sin(5 * np.pi * ((np.sqrt(x ** 2 + y ** 2)) ** 0.75 - 0.1)) ** 2
    return f_xy


def get_values_function():
    x = np.linspace(0, 1, 50)
    y = np.linspace(0, 1, 50)
    X, Y = np.meshgrid(x, y)

    Z = function_p1(X, Y)
    return X, Y, Z
