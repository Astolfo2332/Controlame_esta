while true
    % Solicitar al usuario que ingrese el valor de Mp (porcentaje de sobrepaso)
    mp=input("Por favor ingrese un valor para el porcentaje de sobrepaso," + ...
            "el valor no debe ser superior a 30% ni menor a 10%. O ingrese 0 para" + ...
            " salir: " );
    close all;
    % Validar si el valor de Mp está vacío
    if length(mp)==0
        display("Por favor ingrese una valor")
    % Salir del bucle si Mp es igual a 0
    elseif mp==0
        break
    % Validar si Mp está por debajo del rango (menor a 10%)
    elseif mp<10
        display("Por favor ingrese un valor superior o igual a 10")
    % Validar si Mp está por encima del rango (mayor a 30%)
    elseif mp>30
        display("Por favor ingrese una valor inferior o igual a 30")
    % Si Mp está dentro del rango (entre 10% y 30%)
    elseif mp>=10 && mp<=30
            % Solicitar al usuario que ingrese el valor de Tp y validar
            tp=input("Ingrese el tiempo donde desea que se encuentre el valor " + ...
                "máximo, debe ser un valor superior a 1: ");
            % Validar si el valor de Tp es nulo o no cumple con la condición
            if length(tp)==0
                display("Por favor ingrese un valor")
            elseif tp>1
                t=0:0.01:tp*5;
                % Calcular los parámetros del sistema de segundo orden
                psi=sqrt((log(mp/100)^2)/(pi^2+(log(mp/100)^2)));
                wn=pi/(tp*sqrt(1-psi^2));
                Ts=3/(wn*psi);
                % Verificar si Ts es mayor que 7 segundos
                if Ts>7
                    display("Para este sobrepaso ingrese un valor de tiempo pico " + ...
                        "menor a "+num2str((psi*7*pi)/(3*sqrt(1-psi^2))))
                else
                    h=tf(wn^2,[1 2*psi*wn wn^2]) % Función de transferencia
                    figure(1)
                    y=step(h,t); %Respuesta al escalón
                    [maxv,maxi]=max(y);     
                    % Calcular y mostrar el sobrepaso máximo (Mp)
                    display("Sobrepaso máximo: ")                    
                    Mp=(abs(maxv-1)/1)*100                    
                    b=atan(sqrt(1-psi^2)/psi);
                    % Calcular y mostrar el ángulo b para el tiempo de levantamiento (Tr)
                    display("Tiempo de levantamiento: ")                    
                    Tr=(pi-b)/(wn*sqrt(1-psi^2))
                    dis=abs(0.5-y);
                    cerca=find(dis==min(dis));
                    % Encontrar y mostrar el tiempo de retardo (Td)
                    display("Tiempo de retardo: ")                    
                    Td=t(cerca)
                    % Mostrar el tiempo de asentamiento (Ts)
                    display("Tiempo de asentamiento: ")
                    Ts
                    plot(t,y)
                    hold on 
                    grid on
                    % Marcar el punto del sobrepaso máximo
                    plot(t(maxi),maxv, "r*",MarkerSize=10)
                    text(t(maxi),maxv+0.1,"Sobrepaso maximo")
                    % Marcar el punto del tiempo de retardo
                    plot(Td,y(cerca), "r*",MarkerSize=10)
                    text(Td,y(cerca),"Tiempo de retardo")
                    % Marcar el punto del tiempo de levantamiento
                    dis=abs(Tr-t);
                    cerca=find(dis==min(dis));
                    plot(t(cerca),y(cerca), "r*",MarkerSize=10)
                    text(t(cerca),y(cerca)-0.1,"Tiempo de levantamiento")
                    % Marcar el punto del tiempo de asentamiento
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
