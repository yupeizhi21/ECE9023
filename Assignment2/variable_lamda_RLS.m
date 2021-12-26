clc,clear,close all 
warning off 
feature jit off 
N = 1000; % Signal observation length
a1 = 0.67; % First-order AR parameters
sigma = 0.001; % Additive white noise variance
for kk =1:100
 v = sqrt(sigma)*randn(N,1);  % Generate v(n) additive white noise
u0 = [1,0.5,0.1,-0.4,0.8]; % Initial data
num = 1; % Numerator coefficient
den = [1,a1]; % Denominator coefficient
Zi = filtic(num,den,u0); % Initial conditions of the filter
un = filter(num,den,v,Zi);% Generate sample sequence u(n), N x 1 x trials

 % Generate expected response signal and observation data matrix
 n0 = 1;% Virtual realization of n0-step linear prediction
 M = 2; % Filter order
 b = un(n0+1:N); % Predicted expected response
 L = length(b);
 un1 = [zeros(M-1,1)',un']; % Extended data
 A = zeros(M,L);
 I =eye(M);
 for k=1:L
 A(:,k) = un1(M-1+k : -1 : k);% Construct observation data matrix
 end
 % Apply RLS algorithm for iterative optimization to calculate the optimal weight vector
 delta = 0.004; % Adjustment parameters


 w = zeros(M,L+1);
 epsilon = zeros(L,1);
 alfa = 1;
 P1 = eye(M)/delta;
 lamda = eye(1,L+1);
 temp = zeros(1,L+1);
 Fai = eye(1,2);
 for k = 1:L
     lamda(k)=0.98;
 end
%RLS iterative algorithm process
 for k=1:L
 PIn = P1 * A(:,k);
 denok = lamda(k)+ A(:,k)'*PIn;
 kn = PIn/denok;
 epsilon(k) = b(k)-w(:,k)'*A(:,k);
 w(:,k+1) = w(:,k) + kn*conj(epsilon(k));
 P1 = P1/lamda(k) - kn*A(:,k)'*P1/lamda(k);
 S = diff(P1,1);
 Fai = Fai*(I-kn*A(:,k)')+S*A(:,k)*conj(epsilon(k));
 temp = alfa*real(Fai*A(:,k)*conj(epsilon(k)));
 lamda(k+1) = lamda(k) + 0.0001;
 end 
 w1(kk,:) = w(1,:);
 w2(kk,:) = w(2,:);
 MSE = abs(epsilon).^2;
 MSE_P(kk) = mean(MSE);
end
W1 = mean(w1); % take the average
W2 = mean(w2); % take the average
figure,plot(1:kk,MSE_P,'r','linewidth',2),title('average MSE');grid on;
figure,plot(1:length(W1),W1,'r','linewidth',2),title('average MSE');hold on;
plot(1:length(W2),W2,'b','linewidth',2),title('weight');hold on;
grid on;legend('\alpha1=0','\alpha2=-1')