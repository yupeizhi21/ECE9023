clc,clear,close all 
T=60;
Tt=1;
Q=0.00001*eye(1);
Z=eye(1);
H=eye(1);
R=0.1*eye(1);
I=eye(1);
A=[1];
B=[1];
P=[1];
xhat = [3]
measuredvoltage = [];
truevoltage = [];
kalman = [];
current_state_estimate=[3];
current_prob_estimate=eye(1);
figure;
hold on;
t=1.25;
e= 0.25;
control_vector = [0];
index = 1;
for i=0:Tt:T
    measured = normrnd(t,e);
    measuredvoltage(index) = measured;
    truevoltage(index) = t;
    kalman(index)= current_state_estimate; 
    %%
    predicted_state_estimate=A*current_state_estimate+B*control_vector;
    predicted_prob_estimate = (A*current_prob_estimate)*A'+Q;
    Kg=predicted_prob_estimate*H'*(H*predicted_prob_estimate*H'+R)^(-1);
    current_prob_estimate=(I-Kg*H)*predicted_prob_estimate; 
    Z = [measured];
    current_state_estimate=predicted_state_estimate+Kg*(Z-H*predicted_state_estimate);    
    %%
    index=index+1;
end 
plot(0:Tt:T,measuredvoltage,'b',0:Tt:T,truevoltage,'r',0:Tt:T,kalman,'g')
title('Voltage Measurement with Kalman Filter')
legend('measured','true voltage','kalman')