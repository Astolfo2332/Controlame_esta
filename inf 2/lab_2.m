% funcion para realimentacion feedback(G(s),H(s))
% lsim(g,x,t) con x=t asi lsim(g,t,t)
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
    
        plot(t,s,LineWidth=2)
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
            plot(t,sg,LineWidth=2)
            hold on
            if o==4
            legend(nombre)
            end
            u=u+1;
        end
        u=1;
    end
end