while true
mp=input("Por favor ingrese un valor para el porcentaje de sobrepaso," + ...
        "el valor no debe ser superior a 30% ni menor a 10%. O ingrese 0 para" + ...
        " salir: " )
if length(mp)==0
    display("Por favor ingrese una valor")
elseif mp==0
    break
elseif mp<10
    display("Por favor ingrese un valor superior o igual a 10")
elseif mp>30
    display("Por favor ingrese una valor inferior o igual a 30")

else
    t=0:0.01:10;
    psi=sqrt((log(mp/100)^2)/(pi^2+(log(mp/100)^2)));
    wn=pi/(1.2*sqrt(1-psi^2));
    h=tf(wn^2,[1 2*psi*wn wn^2])
    figure(1)
    y=step(h,t);
    [maxv,maxi]=max(y);
    Mp=(abs(maxv-1)/1)*100
    plot(t,y)
    hold on 
    grid on
    plot(t(maxi),maxv, "r*",MarkerSize=10)
    hold off
    figure(2)
    pzmap(h)
end
end

