while true
mp=input("Por favor ingrese un valor para el porcentaje de sobrepaso," + ...
        "el valor no debe ser superior a 30% ni menor a 10%. O ingrese 0 para" + ...
        " salir: " );
close all
if length(mp)==0
    display("Por favor ingrese una valor")
elseif mp==0
    break
elseif mp<10
    display("Por favor ingrese un valor superior o igual a 10")
elseif mp>30
    display("Por favor ingrese una valor inferior o igual a 30")
elseif mp>=10 && mp<=30
        tp=input("Ingrese el tiempo donde desea que se encuentre el valor " + ...
            "máximo, debe ser un valor superior a 1: ");
        if length(tp)==0
            display("Por favor ingrese un valor")
        elseif tp>1
            t=0:0.01:tp*5;
            psi=sqrt((log(mp/100)^2)/(pi^2+(log(mp/100)^2)));
            wn=pi/(tp*sqrt(1-psi^2));
            Ts=3/(wn*psi);
            if Ts>7
                display("Para este sobrepaso ingrese un valor de tiempo pico " + ...
                    "menor a "+num2str((psi*7*pi)/(3*sqrt(1-psi^2))))
            else
                h=tf(wn^2,[1 2*psi*wn wn^2])
                figure(1)
                y=step(h,t);
                [maxv,maxi]=max(y);
                display("Sobrepaso máximo: ")
                Mp=(abs(maxv-1)/1)*100
                b=atan(sqrt(1-psi^2)/psi);
                display("Tiempo de levantamiento: ")
                Tr=(pi-b)/(wn*sqrt(1-psi^2))
                dis=abs(0.5-y);
                cerca=find(dis==min(dis));
                display("Tiempo de retardo: ")      
                Td=t(cerca)
                display("Tiempo de asentamiento: ")
                Ts
                plot(t,y)
                hold on 
                grid on
                plot(t(maxi),maxv, "r*",MarkerSize=10)
                text(t(maxi),maxv+0.1,"Sobrepaso maximo")
                plot(Td,y(cerca), "r*",MarkerSize=10)
                text(Td,y(cerca),"Tiempo de retardo")
                dis=abs(Tr-t);
                cerca=find(dis==min(dis));
                plot(t(cerca),y(cerca), "r*",MarkerSize=10)
                text(t(cerca),y(cerca)-0.1,"Tiempo de levantamiento")
                dis=abs(Ts-t);
                cerca=find(dis==min(dis));
                plot(t(cerca),y(cerca), "r*",MarkerSize=10)
                text(t(cerca),y(cerca),"Tiempo de asentamiento")
                hold off
            end
        else
            display("Ingrese un valor valido, recuerde que debe ser superior a 1")
        end
else
    display("Ingrese un valor numerico")
end
end

