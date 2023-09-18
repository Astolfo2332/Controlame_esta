%% Punto 4.1
close all;clear;
T=[0.5 1 4];
k=[0.6 1 3 9];
t=0:0.1:10;
u=1;
n = cell(1, 3);
nombre=cell(1,4);
tit=["escalon","rampa","impuslo"];
for a=1:3
    for i=1:3 
        h=tf(1,[T(i) 1]);
        figure(a)
        subplot(2,2,1)
        title("Respuesta "+tit(a))
        if a==1
            s=step(h,t);
        elseif a==2
            s=lsim(h,t,t);
        else
            s=impulse(h,t);
        end
    
        plot(t,s)
        hold on
        n{i}="T: "+num2str(T(i));
        if i==3
        legend(n)
        end
        for o=1:4
            nombre{u}="K: "+num2str(k(o));
            subplot(2,2,i+1)
            g=feedback(h,tf(k(o)));
            title("Respuesta "+tit(a)+" lazo cerrado"+" para T: "+num2str(T(i)))
            if a==1
                sg=step(g,t);
            elseif a==2
                sg=lsim(g,t,t);
            else
                sg=impulse(g,t);
            end
            plot(t,sg)
            hold on
            if o==4
            legend(nombre)
            end
            u=u+1;
        end
        u=1;
    end
end
%% Punto 4.2 
% a
psi=0.3;
wn=[0.9 3];
t=0:0.1:30;
for i=1:2
    figure(4)
    h=tf(wn(i)^2,[1 2*psi*wn(i) wn(i)^2]);
    y=step(h,t);
    plot(t,y)
    hold on
end
legend("wn: 0.9","wn: 3")
title("Respuesta al escalon funcion segundo orden con psi: 0.3")
% b
t=0:0.01:8;
psi=[0.2 0.7 2];
wn=7;
for i=1:3
    figure(5)
    h=tf(wn^2,[1 2*psi(i)*wn wn^2]);
    y=step(h,t);
    plot(t,y)
    hold on
end
legend("psi: 0.2","psi: 0.3","psi: 2")
title("Respuesta al escalon funcion segundo orden con wn: 7")
%% 4.3
t=0:0.01:5;
k=[0.35 1 1.5 6];
psi=0.6;
wn=4;
h=tf(wn^2,[1 2*psi*wn wn^2]);
for n=1:3
    figure(6+n)
    
    for i=1:4
        hr=feedback(h,k(i));
        if n==1
            s=step(hr,t);
        elseif n==2
            s=lsim(hr,t,t);
        else
            s=impulse(hr,t);
        end
        plot(t,s)
        title("Respuesta "+tit(n))
        hold on
        nombre{i}="K: "+num2str(k(i));
        if i==4
            legend(nombre)
        end
        
    end
end

