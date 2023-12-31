%% 4.1 a
J=2;B=7;
H=tf(1,[J B 0])
rlocus(H)
grid on
%% b
rltool(H)
%% c
H1=feedback(H,24.5)
damp(H1)
H1=feedback(H,6)
damp(H1)
H1=feedback(H,12.5)
damp(H1)
H1=feedback(H,5)
damp(H1)
H1=feedback(H,17)
damp(H1)
%% 4.2
syms x
ecu=sym2poly(expand(x*(x+1.5)*(x+2)*(x+3)));
G=tf(1,ecu)
rlocus(G)
%% b
rltool(G)
%% c
t=0:0.1:20;
G1=feedback(G,3)
damp(G1)
figure(1)
step(G1,t);
figure(2)
s=lsim(G1,t,t);
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
%% d 
%marignalmente estable
figure()
G1=feedback(G,16.75)
damp(G1)
step(G1)
figure()
%inestable
G1=feedback(G,16.8)
damp(G1)
step(G1)
%% discreto 
Gd=c2d(G,1)
rlocus(Gd)
%% a
rltool(Gd)
%% a
%Para cumplir la wn de 0.6
t=0:1:20;
figure()
G1=feedback(Gd,4)
damp(G1)
step(G1)
figure()
s=lsim(G1,t,t);
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
figure()
% Para cumplir un factor de amortiguamiento de 0.7 y una wn>0.6
G1=feedback(Gd,2.23)
damp(G1)
step(G1)
figure()
s=lsim(G1,t,t);
plot(t,s)
hold on
plot(t,t)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Respuesta a la rampa","Rampa")
%% d
%marginalmente estable
figure()
G1=feedback(Gd,9.7)
damp(G1)
step(G1)
%Inestable
figure()
G1=feedback(Gd,9.8)
damp(G1)
step(G1)