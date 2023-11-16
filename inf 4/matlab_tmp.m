%% Punto 1
Gp1=tf(5,[1 3 0])
Gp1f=feedback(Gp1,1)
[wn zeta p]=damp(Gp1);
p=max(p(p~=0))
figure()
rlocus(Gp1)
figure()
step(Gp1f)
%% Compensador de atraso

delete matlab_tmp.m