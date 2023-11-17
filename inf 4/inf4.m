close all; clear; clc;
%% Punto 1
Gp1=tf(5,[1 3 0])
Gp1f=feedback(Gp1,1)
[wn zeta p]=damp(Gp1f);
p=max(p(p~=0))
figure()
rlocus(Gp1)
figure()
step(Gp1f)
%% Compensador de atraso
syms x
[num, den] = tfdata(Gp1, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kvo=double(limit(H_x*x,"x",0))
display("Tiene un error estacionario de: "+num2str(100/Kvo)+"%")
syms B T
Kc=1;
Kv=50 % Del error deseado
atras= Kc*B*((T*x+1)/(B*T*x+1));
eq=Kv==limit(x*H_x*atras,"x",0)
B=double(solve(eq,B)) 
Zc=-0.1;
Pc=Zc/B;
GcA=(x-Zc)/(x-Pc)
%% Calculo de K
Kc=1/(H_x*GcA)
Kc=subs(Kc,p)
Kc=double(norm(Kc))
Zceval=subs((x+Zc),p);
Pceval=subs((x+Pc),p);
fase=-double(rad2deg(atan(imag(Zceval)/real(Zceval))-atan(imag(Pceval)/real(Pceval))))
GcA=tf(Kc*[1 -Zc],[1 -Pc])
%% Evaluación
Gp1f=Gp1*GcA
Gp1ff=feedback(Gp1f,1)
[num, den] = tfdata(Gp1f, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kv=double(limit(H_x*x,"x",0))
display("Tiene un nuevo error estacionario de: "+num2str(100/Kv)+"%")
%% Graficos
figure()
rlocus(Gp1f)
figure()
step(Gp1ff)
damp(Gp1ff)
%% Comparación
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
Gp2=tf(10,[2 11 12 0])
G2a=10/(2*x^3+11*x^2+12*x)
Gp2f=feedback(Gp2,1)
wn=3;
zeta=0.7;
p=roots([1 2*wn*zeta wn^2])
p=p(1)
%% Diseño del compensador
theta=double(phase(subs(G2a,p)))
theta_g=rad2deg(theta)
b=phase(p)
ad_r=pi-theta
ad_g=180-theta_g
display("Se necesita hacer una adelanto de: " +num2str(ad_g))
%% Metodo bisectriz
pP=(b/2)-(ad_r/2);
pZ=(b/2)+(ad_r/2);
P=norm(real(p))+(imag(p)/tan(pP));
Z=norm(real(p))+(imag(p)/tan(pZ));
%% Calculo de K
Gc=(x-Z)/(x-P);
K=1/(Gc*G2a);
K=subs(K,p);
K=double(norm(K))
%% Evaluacion del compensador
Gcs=tf(K*[1 Z],[1 P])
Gt=Gp2*Gcs
Gtf=feedback(Gt,1)

damp(Gtf)

figure()
rlocus(Gt)


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

figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
step(Gp2f)
title("Respuesta a escalón sistema original")
subplot(2,1,2)
step(Gtf)
title("Respuesta a escalón compensador de adelanto")

figure()
sgtitle("Comparación de las respuestas en el proceso de diseño")
subplot(2,1,1)
impulse(Gp2f)
title("Respuesta a impulso sistema original")
subplot(2,1,2)
impulse(Gtf)
title("Respuesta a impulso compensador de adelanto")


%% Punto 3
Gp3=tf([10 0.5],[1 0.1 4 0])
Gp3f=feedback(Gp3,1)
damp(Gp3)
figure()
rlocus(Gp3)
figure()
step(Gp3f)
%% Diseño compensador de adelanto
pd=-2+2*sqrt(3)*1i;
Ga3=(10*x+0.5)/(x*(x^2+0.1*x+4))
theta=double(phase(subs(Ga3,pd)))
theta_g=rad2deg(theta)
b=phase(pd)
ad_r=pi-theta
ad_g=180-theta_g
display("Se necesita hacer una adelanto de: " +num2str(ad_g))
%% Metodo bisectriz
pP=(b/2)-(ad_r/2);
pZ=(b/2)+(ad_r/2);
P=norm(real(pd))+(imag(pd)/tan(pP));
Z=norm(real(pd))+(imag(pd)/tan(pZ));
%% Calculo de K
Gc=(x-Z)/(x-P);
K=1/(Gc*Ga3);
K=subs(K,pd);
K=double(norm(K))
%% Evaluacion del compensador
Gcs=tf(K*[1 Z],[1 P])
Gt=Gp3*Gcs
Gtf=feedback(Gt,1)
damp(Gtf)
figure()
rlocus(Gt)
figure()
step(Gtf)
%% diseño del compensador de atraso
[num, den] = tfdata(Gt, 'v');
H_x = poly2sym(num, x) / poly2sym(den, x);
Kvo=double(limit(H_x*x,"x",0))
display("Tiene un error estacionario de: "+num2str(100/Kvo)+"%")
syms B T
Kc=1;
Kv=1/0.03 % Del error deseado
atras= Kc*B*((T*x+1)/(B*T*x+1));
eq=Kv==limit(x*H_x*atras,"x",0)
B=double(solve(eq,B)) 
Zc=-0.1;
Pc=Zc/B;
GcA=(x-Zc)/(x-Pc)
%% Calculo de K
Kc=1/(H_x*GcA);
Kc=subs(Kc,pd);
Kc=double(norm(Kc))
Zceval=subs((x+Zc),pd);
Pceval=subs((x+Pc),pd);
fase=-double(rad2deg(atan(imag(Zceval)/real(Zceval))-atan(imag(Pceval)/real(Pceval))))
GcA=tf(Kc*[1 -Zc],[1 -Pc])
%% Adición de los compensadores y evaluación final
Gtf2=Gt*GcA
Gtff=feedback(Gtf2,1)
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
%%rltool(Gt)
function rampa(H,t)
s=lsim(H,t,t);
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
end
