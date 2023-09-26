%% 4.1 a
J=2;B=7;
H=tf(1,[J B 0]);
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