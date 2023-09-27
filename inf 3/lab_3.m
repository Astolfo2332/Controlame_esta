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
%% 4.2
syms x
ecu=sym2poly(expand(x*(x+1.5)*(x+2)*(x+3)));
G=tf(1,ecu)
rlocus(G)
%% b
rltool(G)
%% c
G1=feedback(G,3)
damp(G1)
step(G1)
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
