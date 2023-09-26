%% ejemplo rlocus
figure(1)
G=tf(1,[1 2 2]);
rlocus(G)
grid on
figure(2)
G2=tf(1,[1 2 2 3]);
rlocus(G2) %para ver las raices imaginarias dependiendo de los posibles
%valores de K
%Azul punto lazo abierto, resto de colores valores posibles de k
%En el caso de este sistema se vuelve marginalmente estable a valores de
%1.1 como se puede ver en data point
grid on
%% rltool
rltool(G2)
%Se puede crear nuevos plots y se pone r2y para observarlo como tf
%Dando click derecho en la grafica de z se le puede dar un requerimiento
%Dando en nuevo y poniendo el requerimiento de  0.4
%%
rltool() %Se puede cargar la data guardada