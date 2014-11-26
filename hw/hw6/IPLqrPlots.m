function IPLqrPlots
close all 
N=10;
c=linspace(0.1,100,N);
for i=1:N
   [T,X,K,E]=InvertedPendulumLQR(c(i));
   u=-K*X';
    figure (1)
plot(E,'o')
title('Poles vs c')
xlabel('real')
ylabel('Img')
grid on
hold on
figure (2)
plot (T,X(:,1))
title('theta')
grid on
hold on
figure (3)
plot(T,X(:,2))
title ('\dot\theta')
grid on
hold on
figure(4)
plot (T,u)
title('control input')
grid on
hold on
end

