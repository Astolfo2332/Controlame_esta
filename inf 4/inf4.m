close all; clear; clc;
%% Punto 1
% Define un sistema de transferencia Gp1 y realiza retroalimentación.
Gp1=tf(5,[1 3 0])
% Retroalimentación de Gp1 y cálculo de los polos dominantes.
Gp1f=feedback(Gp1,1)
[wn zeta p]=damp(Gp1f);
p=max(p(p~=0))
% Grafica el Lugar de las Raíces (LGR) del sistema Gp1.
figure()
rlocus(Gp1)
% Grafica la respuesta al escalón del sistema retroalimentado.
figure()
step(Gp1f)
%% Compensador de atraso
% Calcula un compensador de atraso para mejorar el sistema.
syms x
% Extrae los coeficientes numéricos de Gp1 para realizar cálculos simbólicos.
[num, den] = tfdata(Gp1, 'v');
% Crea una función simbólica H_x a partir de los coeficientes de Gp1.
H_x = poly2sym(num, x) / poly2sym(den, x);
% Calcula el valor límite de H_x*x cuando x tiende a 0 para obtener Kvo.
Kvo=double(limit(H_x*x,"x",0))
display("Tiene un error estacionario de: "+num2str(100/Kvo)+"%")
syms B T
% Inicializa el valor de Kc para el diseño del compensador.
Kc=1;
% Define la ganancia deseada para el error estacionario.
Kv=50;
% Define la función del compensador de atraso.
atras= Kc*B*((T*x+1)/(B*T*x+1));
% Resuelve la ecuación de la ganancia deseada para determinar el valor de B.
eq=Kv==limit(x*H_x*atras,"x",0)
B=double(solve(eq,B)) 
% Define polos para el compensador de atraso.
Zc=-0.1;
Pc=Zc/B;
% Define la función de transferencia del compensador de atraso.
GcA=(x-Zc)/(x-Pc)
%% Calculo de K
% Calcula la ganancia Kc para cumplir con los requisitos de fase del compensador.
Kc=1/(H_x*GcA)
Kc=subs(Kc,p)
Kc=double(norm(Kc))
% Evalúa la posición de los polos y ceros en frecuencia para determinar la fase.
Zceval=subs((x+Zc),p);
Pceval=subs((x+Pc),p);
% Calcula la diferencia de fase necesaria para el compensador de atraso.
fase=-double(rad2deg(atan(imag(Zceval)/real(Zceval))-atan(imag(Pceval)/real(Pceval))))
% Define la función de transferencia del compensador de atraso con la ganancia calculada.
GcA=tf(Kc*[1 -Zc],[1 -Pc])
%% Evaluación
% Retroalimenta el sistema original con el compensador de atraso.
Gp1f=Gp1*GcA
Gp1ff=feedback(Gp1f,1)
% Calcula el nuevo error estacionario y lo muestra en la consola.
[num, den] = tfdata(Gp1f, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kv=double(limit(H_x*x,"x",0))
display("Tiene un nuevo error estacionario de: "+num2str(100/Kv)+"%")
%% Graficos
% Grafica el LGR del sistema con el compensador de atraso.
figure()
rlocus(Gp1f)
% Grafica la respuesta al escalón del sistema con el compensador de atraso.
figure()
step(Gp1ff)
% Muestra información detallada sobre los polos del sistema con el compensador de atraso.
damp(Gp1ff)
%% Comparación
%Comparaciones de las respuestas al escalon, impulso y la rampa para el
%diseño
t=0:1:10;
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
rampa(Gp1f,t)
title("Respuesta a la rampa sistema original")
subplot(2,1,2)
rampa(Gp1ff,t)
title("Respuesta a la rampa compensador de atraso")

figure()
sgtitle("Comparación de las ramas a medida del proceso de diseño")
subplot(2,1,1)
rlocus(Gp1)
title("LGR inicial")
subplot(2,1,2)
rlocus(Gp1f)
title("LGR con compensador de atraso")

figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
step(Gp1f)
title("Respuesta a escalón sistema original")
subplot(2,1,2)
step(Gp1ff)
title("Respuesta a escalón compensador de atraso")

figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
impulse(Gp1f)
title("Respuesta a impulso sistema original")
subplot(2,1,2)
impulse(Gp1ff)
title("Respuesta a impulso compensador de atraso")


%% Punto 2
% Define un nuevo sistema de transferencia Gp2, realiza retroalimentación y obtiene los polos dominantes.
Gp2=tf(10,[2 11 12 0])
% Define la función simbólica G2a para cálculos simbólicos.
G2a=10/(2*x^3+11*x^2+12*x)
% Retroalimenta Gp2 y obtiene los polos dominantes.
Gp2f=feedback(Gp2,1)
wn=3;
zeta=0.7;
p=roots([1 2*wn*zeta wn^2])
p=p(1)
%% Diseño del compensador
% Calcula la fase y el ángulo de adelanto requeridos para mejorar el sistema.
theta=double(phase(subs(G2a,p)))
theta_g=rad2deg(theta)
b=phase(p)
ad_r=pi-theta
ad_g=180-theta_g
display("Se necesita hacer una adelanto de: " +num2str(ad_g))
%% Metodo bisectriz
% Método bisectriz para determinar la ubicación de los polos y ceros del compensador de adelanto.
pP=(b/2)-(ad_r/2);
pZ=(b/2)+(ad_r/2);
P=norm(real(p))+(imag(p)/tan(pP));
Z=norm(real(p))+(imag(p)/tan(pZ));
%% Calculo de K
% Calcula la ganancia K para cumplir con los requisitos de fase del compensador de adelanto.
Gc=(x-Z)/(x-P);
K=1/(Gc*G2a);
K=subs(K,p);
K=double(norm(K))
%% Evaluacion del compensador
% Crea la función de transferencia del compensador de adelanto.
Gcs=tf(K*[1 Z],[1 P])
Gt=Gp2*Gcs
Gtf=feedback(Gt,1)
% Muestra información detallada sobre los polos del sistema con el compensador de adelanto.
damp(Gtf)
% Grafica el Lugar de las Raíces (LGR) del sistema con el compensador de adelanto.
figure()
rlocus(Gt)
% Grafica la respuesta a una rampa del sistema original y del sistema con el compensador de adelanto.
t=0:1:30;
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
rampa(Gp2f,t)
title("Respuesta a la rampa sistema original")
subplot(2,1,2)
rampa(Gtf,t)
title("Respuesta a la rampa compensador de adelanto")

figure()
sgtitle("Comparación de las ramas a medida del proceso de diseño")
subplot(2,1,1)
rlocus(Gp2)
title("LGR inicial")
subplot(2,1,2)
rlocus(Gt)
title("LGR con compensador de adelanto")
% Grafica la respuesta a un escalon del sistema original y del sistema con el compensador de adelanto.
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
step(Gp2f)
title("Respuesta a escalón sistema original")
subplot(2,1,2)
step(Gtf)
title("Respuesta a escalón compensador de adelanto")
% Grafica la respuesta al impulso del sistema original y del sistema con el compensador de adelanto.
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
impulse(Gp2f)
title("Respuesta a impulso sistema original")
subplot(2,1,2)
impulse(Gtf)
title("Respuesta a impulso compensador de adelanto")


%% Punto 3
% Define un sistema de transferencia Gp3, realiza retroalimentación y obtiene los polos dominantes.
Gp3=tf([10 0.5],[1 0.1 4 0])
% Retroalimenta Gp3 y calcula los polos dominantes.
Gp3f=feedback(Gp3,1)
damp(Gp3)
% Grafica el LGR del sistema Gp3.
figure()
rlocus(Gp3)
% Grafica la respuesta al escalón del sistema retroalimentado Gp3.
figure()
step(Gp3f)
%% Diseño compensador de adelanto
% Define un polo deseado para el compensador de adelanto.
pd=-2+2*sqrt(3)*1i;
% Define la función simbólica Ga3 para cálculos simbólicos.
Ga3=(10*x+0.5)/(x*(x^2+0.1*x+4))
% Calcula la fase y el ángulo de adelanto requeridos para mejorar el sistema.
theta=double(phase(subs(Ga3,pd)))
theta_g=rad2deg(theta)
b=phase(pd)
ad_r=pi-theta
ad_g=180-theta_g
display("Se necesita hacer una adelanto de: " +num2str(ad_g))
%% Metodo bisectriz
% Método bisectriz para determinar la ubicación de los polos y ceros del compensador de adelanto.
pP=(b/2)-(ad_r/2);
pZ=(b/2)+(ad_r/2);
P=norm(real(pd))+(imag(pd)/tan(pP));
Z=norm(real(pd))+(imag(pd)/tan(pZ));
%% Calculo de K
% Calcula la ganancia K para cumplir con los requisitos de fase del compensador de adelanto.
Gc=(x-Z)/(x-P);
K=1/(Gc*Ga3);
K=subs(K,pd);
K=double(norm(K))
%% Evaluacion del compensador
% Crea la función de transferencia del compensador de adelanto.
Gcs=tf(K*[1 Z],[1 P])
Gt=Gp3*Gcs
Gtf=feedback(Gt,1)
damp(Gtf)
% Grafica el Lugar de las Raíces (LGR) del sistema con el compensador de adelanto.
figure()
rlocus(Gt)
% Grafica la respuesta al escalón del sistema con el compensador de adelanto.
figure()
step(Gtf)
%% diseño del compensador de atraso
% Calcula el error estacionario y diseña un compensador de atraso para mejorar el sistema.
[num, den] = tfdata(Gt, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kvo=double(limit(H_x*x,"x",0))
display("Tiene un error estacionario de: "+num2str(100/Kvo)+"%")
syms B T
% Inicializa el valor de Kc para el diseño del compensador.
Kc=1;
% Define la ganancia deseada para el error estacionario.
Kv=1/0.03 
% Define la función del compensador de atraso.
atras= Kc*B*((T*x+1)/(B*T*x+1));
% Resuelve la ecuación de la ganancia deseada para determinar el valor de B.
eq=Kv==limit(x*H_x*atras,"x",0)
B=double(solve(eq,B)) 
% Define polos para el compensador de atraso.
Zc=-0.1;
Pc=Zc/B;
% Define la función de transferencia del compensador de atraso.
GcA=(x-Zc)/(x-Pc)
%% Calculo de K
% Calcula la ganancia Kc para cumplir con los requisitos de fase del compensador de atraso.
Kc=1/(H_x*GcA);
Kc=subs(Kc,pd);
Kc=double(norm(Kc))
% Evalúa la posición de los polos y ceros en frecuencia para determinar la fase.
Zceval=subs((x+Zc),pd);
Pceval=subs((x+Pc),pd);
fase=-double(rad2deg(atan(imag(Zceval)/real(Zceval))-atan(imag(Pceval)/real(Pceval))))
% Define la función de transferencia del compensador de atraso con la ganancia calculada.
GcA=tf(Kc*[1 -Zc],[1 -Pc])
%% Adición de los compensadores y evaluación final
% Combina los compensadores de adelanto y atraso y evalúa el sistema final.
Gtf2=Gt*GcA
Gtff=feedback(Gtf2,1)
% Calcula el nuevo error estacionario y lo muestra en la consola.
[num, den] = tfdata(Gtf2, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kv=double(limit(H_x*x,"x",0))
display("Tiene un nuevo error estacionario de: "+num2str(100/Kv)+"%")
figure()
step(Gtff)
damp(Gtff)
figure()
pzmap(Gtff)
figure()
rlocus(Gtf2)
%% Graficos de comparación
% Grafica comparativa de LGR para los diferentes sistemas.
figure()
sgtitle("Comparación de las ramas a medida del proceso de diseño")
subplot(3,1,1)
rlocus(Gp3)
title("LGR inicial")
subplot(3,1,2)
rlocus(Gt)
title("LGR luego del compensador de adelanto")
subplot(3,1,3)
rlocus(Gtf2)
title("LGR luego del compensador de adelanto y atraso")
% Grafica comparativa de respuestas al escalón para los diferentes sistemas.
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(3,1,1)
step(Gp3f)
title("Respuesta al escalón sistema original")
subplot(3,1,2)
step(Gtf)
title("Respuesta al escalón compensador de adelanto")
subplot(3,1,3)
step(Gtff)
title("Respuesta al escalón compensador de adelanto y atraso")
% Grafica comparativa de respuestas a rampa para los diferentes sistemas.
t=0:1:200;
figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(3,1,1)
rampa(Gp3f,t)
title("Respuesta a la rampa sistema original")
subplot(3,1,2)
rampa(Gtf,t)
title("Respuesta a la rampa compensador de adelanto")
subplot(3,1,3)
rampa(Gtff,t)
title("Respuesta a la rampa compensador de adelanto y atraso")
%% rtoools
function rampa(H,t)
% Función que grafica la respuesta a una rampa de un sistema dado.
    % Parámetros:
    %   H: Función de transferencia del sistema.
    %   t: Vector de tiempo para la simulación.

% Simula la respuesta del sistema a una entrada de rampa.
s=lsim(H,t,t);
% Grafica la respuesta del sistema y la rampa de referencia.
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
end