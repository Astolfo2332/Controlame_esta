close all;
clear;

%% Sección 1: Definición de funciones de transferencia y visualización
% Definir funciones de transferencia f1 y f2
f1 = tf([3 0 1], [1 7 9]);
f2 = tf([10 -5], [1 2 5 3]);

% Mostrar información sobre las funciones de transferencia
present(f1)
present(f2)

%% Sección 2: Descomposición en fracciones parciales y análisis de respuesta al escalón
% Descomposición en fracciones parciales para f1 y f2
[r1, p1, k1] = residue([3 0 1], [1 7 9]);
[r2, p2, k2] = residue([10 -5], [1 2 5 3]);

% Crear función simbólica para la respuesta en fracciones parciales de f1
syms s
f1p = (r1(1)/(s-p1(1))) + (r1(2)/(s-p1(2))) + k1;
f1p = simplify(f1p);
f1p = sym2tf(f1p);%Para esta parte se necesita el toolbox de OVivero/mimoToolbox, disponible en: https://la.mathworks.com/matlabcentral/fileexchange/10816-ovivero-mimotoolbox

% Crear función simbólica para la respuesta en fracciones parciales de f2
f2p = (r2(1)/(s-p2(1))) + (r2(2)/(s-p2(2))) + (r2(3)/(s-p2(3)));
f2p = simplify(f2p);
f2p = sym2tf(f2p);

% Graficar la respuesta al escalón de f1 y f1p en la misma figura
figure(1)
step(f1)
hold on
step(f1p, "r--")
title("Respuesta al escalón para f1")
legend("Original", "Fracciones parciales")

% Graficar la respuesta al escalón de f2 y f2p en la misma figura
figure(2)
step(f2)
hold on
step(f2p, "r--")
title("Respuesta al escalón para f2")
legend("Original", "Fracciones parciales")

%% Sección 3: Gráficas de respuesta al escalón e impulso
% Graficar la respuesta al escalón de f1 y f2 en la misma figura
figure(3)
step(f1)
hold on
step(f2)
legend("f1", "f2")
title("Respuesta al escalón en el punto 1")

% Graficar la respuesta al impulso de f1 y f2 en la misma figura
figure(4)
impulse(f1)
hold on
impulse(f2)
legend("f1", "f2")
title("Respuesta al impulso en el punto 1")

%% Sección 4: Análisis y gráficas de sistema de control
% Definir función de transferencia f3
f3 = tf([7 0 2], [1 3 8]);

% Realizar una simulación del sistema y obtener resultados
out = sim("lab1_s.slx");
t1 = out.simout.time;
x1 = out.simout.signals.values(:, 1);
x2 = out.simout.signals.values(:, 2);

% Graficar la respuesta al escalón de f3 y resultados de simulación
figure(5)
step(f3)
hold on
plot(t1, x1, "r")
legend("MATLAB", "SIMULINK")
title("Respuesta al escalón en el punto 2")

% Graficar la respuesta al impulso de f3 y resultados de simulación
figure(6)
impulse(f3)
hold on
plot(t1, x2, "r")
legend("MATLAB", "SIMULINK")
title("Respuesta al impulso en el punto 2")

% Graficar la señal de impulso de SIMULINK
figure(7)
plot(t1, out.simout.signals.values(:, 3))
title("Señal de impulso SIMULINK")

% Graficar la señal de impulso de manera analitica
figure(8)
impulse(f3)
hold on 
c_f3=f3/(1+f3);
impulse(c_f3)
legend("Lazo abierto","Lazo cerrado")
title("Respuesta impulso")

%% Sección 5: Análisis y gráficas de sistema mecánico
% Definir símbolos y parámetros del sistema mecánico
syms x y s u
k1 = 6;
k2 = k1;
m1 = 10;
m2 = 5;
b = 18;

% Definir ecuaciones del sistema mecánico
ecu1 = -k1*(x-u) - k2*(x-y) - b*(x*s-y*s) == m1*x*s^2;
ecu2 = -k2*(y-x) - b*(y*s-x*s) == m2*y*s^2;

% Resolver las ecuaciones para x e y en términos de s
ecu2_x = solve(ecu2, x);
ecu1_y = subs(ecu1, x, ecu2_x);
ecu2_y = solve(ecu2, y);
ecu1_x = subs(ecu1, y, ecu2_y);

% Encontrar las soluciones de las ecuaciones
s_ecu1_y = solve(ecu1_y, y);
s_ecu1_x = solve(ecu1_x, x);

% Crear funciones de transferencia a partir de los valores numéricos
xs = tf([15 54 18], [25 135 60 54 18]);
ys = tf([54 18], [25 135 60 54 18]);

% Mostrar información sobre las funciones de transferencia
present(xs)
present(ys)

%% Sección 6: Gráficas de respuesta de sistemas mecánicos
% Graficar la respuesta al escalón e impulso de xs y ys
figure(9)
sgtitle("Respuesta del sistema para H1")
subplot(2, 1, 1)
step(xs)
subplot(2, 1, 2)
impulse(xs)

figure(10)
sgtitle("Respuesta del sistema para H2")
subplot(2, 1, 1)
step(ys)
subplot(2, 1, 2)
impulse(ys)

%% Sección 7: Análisis y gráficas de sistemas mecánicos en lazo cerrado
% Calcular funciones de transferencia en lazo cerrado para xs y ys
c_H1 = xs / (1 + xs);
c_H2 = ys / (1 + ys);

% Mostrar información sobre las funciones de transferencia en lazo cerrado
present(c_H1)
present(c_H2)

% Graficar la respuesta al escalón e impulso en lazo cerrado para H1
figure(11)
sgtitle("Respuesta del sistema para H1 en lazo cerrado")
subplot(2, 1, 1)
step(c_H1)
subplot(2, 1, 2)
impulse(c_H1)

% Graficar la respuesta al escalón e impulso en lazo cerrado para H2
figure(12)
sgtitle("Respuesta del sistema para H2 en lazo cerrado")
subplot(2, 1, 1)
step(c_H2,200)
subplot(2, 1, 2)
impulse(c_H2,200)
%%
figure(13)
pzmap(c_H2)
title("Polos y ceros de H2 en lazo cerrado")

figure(14)
pzmap(c_H1)
title("Polos y ceros de H1 en lazo cerrado")

