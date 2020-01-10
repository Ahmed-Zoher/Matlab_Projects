clc
clear all


Xn         = 1+6*rand(10000,1);   %random X location used for generating the H matrix
Yn         = 1+4*rand(10000,1);   %random Y location used for generating the H matrix
Zn         = rand(10000,1);       % Z location is the same
Zn(1:1:end)= 1.5; 
Trans     = [Xn,Yn,Zn];
Signal    = [Xn,Yn];

Pt        = -5 ; %dbm

Receivers = [0 0 3;0 6 3;8 6 3];  %Receiver positions

XnN        = 1+6*rand(10000,1);   %random X location used for generating the H matrix
YnN        = 1+4*rand(10000,1);
ZnN        = rand(10000,1);
ZnN(1:1:end)= 1.5; 
TransN     = [XnN,YnN,ZnN];
SignalN    = [XnN,YnN];

D= zeros(10000,length(Receivers));
for i=1:1:length(Xn)
    d=[];
    for j=1:1:length(Receivers)
     d   = [d sqrt(sum((Trans(i,:)-Receivers(j,:)).^2))];
    end
    D(i,:)= d;
end

DN= zeros(10000,length(Receivers));
for i=1:1:length(XnN)
    dN=[];
    for j=1:1:length(Receivers) 
    dN   = [dN sqrt(sum((TransN(i,:)-Receivers(j,:)).^2))];
    end
    DN(i,:)= dN;
end

Signal_mean =[Signal(:,1)-mean(Signal(:,1)) , Signal(:,2)-mean(Signal(:,2))];
Signal_meanN =[SignalN(:,1)-mean(SignalN(:,1)) , SignalN(:,2)-mean(SignalN(:,2))];
for count=1:1:2

if count ==1
std = 4;
X_sigmadb = normrnd(0,std,10000,3);
X_sigmadbn = normrnd(0,std,10000,3);
Loop=2.7:0.1:4;
else
pathloss=3;
Loop=0:0.1:8;
end

mse=[];
for temp=Loop
    
if count==2
   std=temp;
   X_sigmadb = normrnd(0,std,10000,3);
   X_sigmadbn= normrnd(0,std,10000,3);
else
   pathloss=temp;
end
    
Obs      = Pt - (10*pathloss*log10(D)) + X_sigmadb; 

Obs_mean = [Obs(:,1)-mean(Obs(:,1)) Obs(:,2)-mean(Obs(:,2)) Obs(:,3)-mean(Obs(:,3))];

R_xy =[];
for i =1:1:size(Obs,2)
    temp =[mean(Signal_mean(:,1).*Obs_mean(:,i)) ; mean(Signal_mean(:,2).*Obs_mean(:,i))];
    R_xy =[R_xy temp];
end

R_x =[];
for i = 1:1:size(Obs,2)
    temp = [];
    for j=1:1:size(Obs,2)
        temp =[temp ; mean(Obs_mean(:,j).*Obs_mean(:,i))];
    end
    R_x =[R_x temp];
end

R_x=R_x/10000;
R_xy=R_xy/10000;

H    = R_xy * inv(R_x);

ObsN = Pt - (10*pathloss*log10(DN)) + X_sigmadbn;

Obs_meanN = [ObsN(:,1)-mean(ObsN(:,1)) ObsN(:,2)-mean(ObsN(:,2)) ObsN(:,3)-mean(ObsN(:,3))];

Est  = Obs_meanN*H';

mse  = [mse mean(sum((Signal_meanN-Est).^2,2))];
end
figure()
plot(Loop,mse)
grid on 
if count==1
title('Mean Square Error and Pathloss Exponent')
xlabel('Pathloss Exponent')
else
title('Mean Square Error and Shadowing Standard Deviation')
xlabel('Shadowing Standard Deviation')
end
ylabel('Mean Square Error')
end