Gp3=tf([10 0.5],[1 0.1 4 0])
[wn,zeta,p]=damp(Gp3)
rlocus(Gp3)
%% Diseño compensador
pd=-2+2*sqrt(3)*1i;
syms x
Ga3=(10*x+0.5)/(x*(x^2+0.1*x+4))
theta=double(phase(subs(Ga3,pd)))
theta_g=rad2deg(theta)
b=phase(pd)
ad_r=pi-theta
ad_g=180-theta_g
display("Se necesita hacer una adelanto de: " +num2str(ad_g))
%% Metodo bisectriz
pP=(b/2)-(ad_r/2)
pZ=(b/2)+(ad_r/2)
P=norm(real(pd))+(imag(pd)/tan(pP))
Z=norm(real(pd))+(imag(pd)/tan(pZ))
%% Calculo de K
Gc=(x-Z)/(x-P)
K=1/(Gc*Ga3)
K=subs(K,pd)
K=double(norm(K))
%% Evaluacion del compensador
Gcs=tf(K*[1 Z],[1 P])
Gt=Gp3*Gcs
Gtf=feedback(Gt,1)
damp(Gtf)
rlocus(Gt)
<<<<<<< HEAD
%% diseño del compensador de atraso
[num, den] = tfdata(Gt, 'v')
H_x = poly2sym(num, x) / poly2sym(den, x)
Kvo=double(limit(H_x*x,"x",0))

=======
>>>>>>> 23209ae669fb1c0208559602b584f34ee330ae0d
%% rtoools
rltool(Gp3)

