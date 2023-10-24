%% 4.1 a
J=2;B=7;
ecu=[J B 0]
H=tf(1,ecu)
figure(1)
rlocus(H)
%% b
rltool(H)
%% c
t=0:0.1:20;
figure(2)
plot(t,t)
hold on
H1=feedback(H*24.5,1)
s=lsim(H1,t,t);
plot(t,s)
damp(H1)

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

title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa K=24.5","Respuesta a la rampa K=6","Respuesta a la rampa K=12.5","Respuesta a la rampa K=5","Respuesta a la rampa K=17")
%% 4.2
syms x
ecu=sym2poly(expand(x*(x+1.5)*(x+2)*(x+3)));
G=tf(1,ecu)
figure(3)
rlocus(G)
%% b
rltool(G)
%% c
G1=feedback(G*3,1);
step(G1)
damp(G1)
rampa(G1,t,3)
%% d 
t=0:1:40;
%marignalmente estable
figure(4)
G1=feedback(G*16.7751479,1);
damp(G1)
step(G1)
figure(5)
plot(t,t)
hold on
s=lsim(G1,t,t);
plot(t,s)
figure(6)
%inestable
G1=feedback(G*16.8,1);
damp(G1)
step(G1)
figure(5)
s=lsim(G1,t,t);
plot(t,s)
title("Ramp response")
xlabel("Time(seconds)")
ylabel("Amplitude")
legend("Rampa","Respuesta a la rampa marginalmente estable","Respuesta a la rampa inestable")
%% discreto 
Gd=c2d(G,1)
figure(7)
rlocus(Gd)
%% a
rltool(Gd)
%% a
%Para cumplir la wn de 0.6
t=0:1:20;
figure(8)
G1=feedback(Gd*4,1)
damp(G1)
step(G1)
figure(9)
plot(t,t)
hold on
s=lsim(G1,t,t);
plot(t,s)

figure(10)
% Para cumplir un factor de amortiguamiento de 0.7 y una wn>0.6
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
%marginalmente estable
t=0:1:40;
figure(11)
G1=feedback(Gd*9.7275,1)
damp(G1)
step(G1)
figure(12)
plot(t,t)
hold on
s=lsim(G1,t,t);
plot(t,s)
%Inestable
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