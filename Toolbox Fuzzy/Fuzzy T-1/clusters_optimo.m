function [errtest,errent]=clusters_optimo(ytest,yent,Xtest,Xent,max_clusters)
ps1=0;
%yent, Xent: corresponden a la salida del set de entrenamiento y a la
%matriz de variables candadatas del set de entrenamiento, respectivamente
%ytest,Xtest: corresponden  a la salida del set de test y a la
%matriz de variables candadatas del set de test, respectivamente
%max_clusters corresponde al n�mero maximo de clusters que se desea
%graficar
errtest=zeros(max_clusters-1,1); %se inicializa el vector de error de test
errent=zeros(max_clusters-1,1);% se inicializa el vector de error de entreneamiento
% se generan los errores de test y entrenamiento para los max_clusters
% clusters
for i=2:max_clusters
[model,result]=TakagiSugeno(yent,Xent,i,[1 2]);% 
ps1=ps1+1
y1=ysim(Xent,model.a,model.b,model.g);
y2=ysim(Xtest,model.a,model.b,model.g);
errtest(i-1)=sqrt(mean((y2-ytest).^2));
errent(i-1)=sqrt(mean((y1-yent).^2));
end
%Finalmente se grafican ambos errores
% figure ()
% plot(errtest,'b','LineWidth',2)
% hold on
% grid on
% plot(errent,'red','LineWidth',2)
% legend('Error de test','Error de entrenamiento')
% xlabel('N�mero de clusters')
% ylabel('Error cuadr�tico medio')
end