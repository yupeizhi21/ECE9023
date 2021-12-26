T=14.4;%Simulation time
Tt=0.1;%Simulation interval


muzzle_velocity = 100; % How fast should the cannonball come out?
angle = 45; % Angle from the ground.
speedX = muzzle_velocity*cos(angle*pi/180);
speedY = muzzle_velocity*sin(angle*pi/180);
V=[speedX,speedY];%The initial velocity 

noiselevel = 20;
x = [];
y = [];
x2 = [];
y2 = [];
nx = [];
ny = [];
kx = [];
ky = [];
control_vector=[0;0;0.5*-9.81*0.1*0.1;-9.81*0.91];
Q=zeros(4);
Z=eye(4);
H=eye(4);
R=0.2*eye(4);
I=eye(4);
A=[1,0.1,0,0;0,1,0,0;0,0,1,0.1;0,0,0,1];
B=[0,0,0,0;0,0,0,0;0,0,1,0;0,0,0,1];
current_state_estimate=[0;speedX;500;speedY];
current_prob_estimate=eye(4);

gravity = [0,-9.81];
velocity = [muzzle_velocity*cos(angle*pi/180), muzzle_velocity*sin(angle*pi/180)];
loc = [0,0]; % The initial location of the cannonball.
acceleration = [0,0]; % The initial acceleration of the cannonball.

figure;
title('Simulate the flight path');
hold on;

index = 1;
for i=0:Tt:T
    
    %%
    predicted_state_estimate=A*current_state_estimate+B*control_vector;
    predicted_prob_estimate = (A*current_prob_estimate)*A'+Q;
    Kg=predicted_prob_estimate*H'*(H*predicted_prob_estimate*H'+R)^(-1);
    Pn=(I-Kg*H)*predicted_prob_estimate;  
    Xn=predicted_state_estimate+Kg*(Z-H*predicted_state_estimate);    
    %%
    
    timeslicevec = [Tt,Tt];
    sliced_gravity = gravity.*timeslicevec;
    sliced_acceleration = sliced_gravity;
    velocity = velocity+sliced_acceleration;
    sliced_velocity = velocity.*timeslicevec;
    loc =loc+sliced_velocity;
    if loc(2) < 0
      loc(2) = 0
    end
    x2(index) =loc(1);
    y2(index) =loc(2);
    nx(index) = normrnd(x2(index),noiselevel);
    ny(index) = normrnd(y2(index),noiselevel);
    if ny(index) <= 0
    ny(index)=0;
    end
    
    kx(index) = Xn(1,1);
    ky(index) = Xn(3,1);
    if ky(index) <= 0
    break;
    end
    Z=[nx(index),V(1),ny(index),V(2)];
    current_state_estimate = Xn;
    current_prob_estimate = Pn;
    index=index+1;
end 
plot(nx,ny,'--',kx,ky,'b--o',x2,y2,':')
title('Measurement of a Cannonball in Flight')
legend('measured','kalman','true')