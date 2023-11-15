%% 4.1.a 
% Gráfica del LGR
J=2; B=7;
ecu=[J B 0]; % Define los coeficientes de la ecuación característica
H=tf(1,ecu); % Crea un objeto de transferencia
figure(1)
rlocus(H) % Genera un gráfico del LGR
%% 4.1.b
% Se encuentran los valores de ganancia K en la funcion rltool
rltool(H)
%% 4.1.c
% Respuesta en frecuencia de los valores de K hallados
t=0:0.1:20; % Define un vector de tiempo
figure(2)
plot(t,t) % Grafica una rampa
hold on

% Crea un sistema retroalimentado con diferentes ganancias
H1=feedback(H*24.5,1);  
s=lsim(H1,t,t); % Calcula y representa la respuesta del sistema
plot(t,s)
damp(H1) % Calcula y muestra los coeficientes de amortiguamiento

% Repite el proceso para diferentes ganancias
H1=feedback(H*6,1)
s=lsim(H1,t,t);
plot(t,s)
damp(H1)

H1=feedback(H*12.5,1)
s=lsim(H1,t,t);
plot(t,s)
damp(H1)

H1=feedback(H*5,1)
s=lsim(H1,t,t);
plot(t,s)
damp(H1)

H1=feedback(H*17,1)
s=lsim(H1,t,t);
plot(t,s)
damp(H1)
%Se pone el titulo, los ejes y las leyendas en el gráfico
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa K=24.5","Respuesta a la rampa K=6","Respuesta a la rampa K=12.5","Respuesta a la rampa K=5","Respuesta a la rampa K=17")
%% 4.2.a
% Gráfica del LGR
syms x
ecu=sym2poly(expand(x*(x+1.5)*(x+2)*(x+3)));  % Define una ecuación característica polinómica
G=tf(1,ecu); % Crea un objeto de transferencia
figure(3)
rlocus(G) % Genera un gráfico del LGR
%% 4.2.b
% Se encuentran los valores de ganancia K en la funcion rltool
rltool(G)
%% 4.2.c
G1=feedback(G*3,1); % Crea un sistema retroalimentado con una ganancia
step(G1) % Genera una respuesta al escalón
damp(G1) % Calcula y muestra los coeficientes de amortiguamiento
rampa(G1,t,3)  % Llama a la función 'rampa' para representar una respuesta a una rampa
%% d 
t=0:1:40; % Define un nuevo vector de tiempo
% Sistema marignalmente estable
figure(4)
G1=feedback(G*16.7751479,1); % Crea un sistema retroalimentado con una ganancia
damp(G1) % Calcula y muestra los coeficientes de amortiguamiento
step(G1) % Genera una respuesta al escalón
% Representación de una rampa
figure(5)
plot(t,t) 
hold on
s=lsim(G1,t,t);
plot(t,s)
figure(6)
%Sistema inestable
G1=feedback(G*16.8,1);
damp(G1)
step(G1) % Generación de la respuesta al escalón
% Representación de una rampa
figure(5)
s=lsim(G1,t,t);
plot(t,s)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa marginalmente estable","Respuesta a la rampa inestable")
%% Sistema Discreto 
% Conversión del sistema G en un sistema discreto
Gd=c2d(G,1);
% Creación de una figura para el LGR del sistema discreto
figure(7)
rlocus(Gd)
%% a
rltool(Gd)
%% a
% Para cumplir un factor de amortiguamiento de 0.7 y una wn>0.6
% Definición de un nuevo vector de tiempo
t=0:1:20; 
figure(8) % Creación de una figura para representar la respuesta a una rampa
G1=feedback(Gd*4,1)
damp(G1)
step(G1) % Generación de la respuesta al escalón

% Representación de una rampa
figure(9)
plot(t,t)
hold on
s=lsim(G1,t,t);
plot(t,s)

%Para cumplir la wn de 0.6
% Repetición del proceso para diferentes ganancias y condiciones
figure(10)
G1=feedback(Gd*2.23,1)
damp(G1)
step(G1)
figure(9)
s=lsim(G1,t,t);
plot(t,s)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa K=4","Respuesta a la rampa K=2.23")
%% d
%Sistema Marginalmente estable
t=0:1:40; %Vector de tiempo

%Respuesta al escalón
figure(11)
G1=feedback(Gd*9.7275,1)
damp(G1)
step(G1)

%Respuesta a la rampa
figure(12)
plot(t,t)
hold on
s=lsim(G1,t,t);
plot(t,s)
%Sistema inestable
figure(13)
G1=feedback(Gd*9.8,1)
damp(G1)
step(G1)
figure(12)
s=lsim(G1,t,t);
plot(t,s)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa K=9.7","Respuesta a la rampa K=9.8")
%%
% Funcion para la respuesta a la rampa de todos los puntos 
function rampa(H,t,n)
figure(n)
s=lsim(H,t,t);
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
end