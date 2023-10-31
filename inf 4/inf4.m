Gp3=tf([10 0.5],[1 0.1 4 0])
[wn,zeta,p]=damp(Gp3)
rlocus(Gp3)
pd=-2+2*sqrt(3)*1i;
syms x
Ga3=(10*x+0.5)/(x*(x^2+0.1*x+4))
display("Se necesita hacer una adelanto de: " +num2str(180-double(rad2deg(phase(subs(Ga3,pd))))) )
step(Gp3)
%% rtoools

