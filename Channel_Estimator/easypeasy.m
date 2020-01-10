clc
clear all


Xn         = 1+6*rand(10000,1);   %random X location used for generating the H matrix
Yn         = 1+4*rand(10000,1);   %random Y location used for generating the H matrix
Zn         = rand(10000,1);       
Zn(1:1:end)= 1.5;                 % Z location is the same
Trans     = [Xn,Yn,Zn]; 
Signal    = [Xn,Yn];

Pt        = -5 ; %dbm

Receivers = [0 0 3;0 6 3;8 6 3];  %Receiver positions

XnN        = 1+6*rand(10000,1);   %random new X location used for generating the estimation
YnN        = 1+4*rand(10000,1);   %random new Y location used for generating the estimation
ZnN        = rand(10000,1);        
ZnN(1:1:end)= 1.5;                %Z is the same at all locations
TransN     = [XnN,YnN,ZnN];
SignalN    = [XnN,YnN];

D= zeros(10000,length(Receivers)); 
for i=1:1:length(Xn)               % calculating the distance between each random location and the receivers to get 3 distances for each random location
                                   % because we have 3 receivers
     d   = [sqrt(sum((Trans(i,:)-Receivers(1,:)).^2)) sqrt(sum((Trans(i,:)-Receivers(2,:)).^2)) sqrt(sum((Trans(i,:)-Receivers(3,:)).^2))];
     D(i,:)= d;
end

DN= zeros(10000,length(Receivers));
for i=1:1:length(XnN)            % calculating the distance between each new random location and the receivers to get 3 distances for each random location
                                 % because we have 3 receivers
    dN   = [sqrt(sum((TransN(i,:)-Receivers(1,:)).^2)) sqrt(sum((TransN(i,:)-Receivers(2,:)).^2)) sqrt(sum((TransN(i,:)-Receivers(3,:)).^2))];
    DN(i,:)= dN;
end

Signal_mean  =[Signal(:,1)-mean(Signal(:,1)) , Signal(:,2)-mean(Signal(:,2))];
Signal_meanN =[SignalN(:,1)-mean(SignalN(:,1)) , SignalN(:,2)-mean(SignalN(:,2))];

count=2;   %enter 1 for pathlos graph and 2 for shadowing graph

if count ==1
std = 4;
X_sigmadb  = normrnd(0,std,10000,3);           %shadowing for the first power calculations
X_sigmadbn = normrnd(0,std,10000,3);           %shadowing for the new power calculations (used for estimation)
Loop       = 2.7:0.1:4;                        % note that when looping on path loss we have only 2 shadowings during all the loops
else
pathloss=3;
Loop=0:0.1:8;                                 % note that when looping on shadowing we have we have to generate 2 new shadowing every loop as the
end                                           % standard deviation change

mse=[];
for temp=Loop
 
 %% first step is to get the H matrix with the first generated random locations   
if count==2
   std=temp;
   X_sigmadb = normrnd(0,std,10000,3);  
   X_sigmadbn= normrnd(0,std,10000,3);
else
   pathloss=temp;
end
    
Obs      = Pt - (10*pathloss*log10(D)) + X_sigmadb;                                       %1st power calculation
Obs_mean = [Obs(:,1)-mean(Obs(:,1)) Obs(:,2)-mean(Obs(:,2)) Obs(:,3)-mean(Obs(:,3))];     %getting the mean

R_xy =[];
R_xy =[mean(Signal_mean(:,1).*Obs_mean(:,1)) mean(Signal_mean(:,1).*Obs_mean(:,2)) mean(Signal_mean(:,1).*Obs_mean(:,3));
       mean(Signal_mean(:,2).*Obs_mean(:,1)) mean(Signal_mean(:,2).*Obs_mean(:,2)) mean(Signal_mean(:,2).*Obs_mean(:,3))];
    


R_x =[];
R_x =[mean(Obs_mean(:,1).*Obs_mean(:,1)) mean(Obs_mean(:,1).*Obs_mean(:,2)) mean(Obs_mean(:,1).*Obs_mean(:,3));
      mean(Obs_mean(:,2).*Obs_mean(:,1)) mean(Obs_mean(:,2).*Obs_mean(:,2)) mean(Obs_mean(:,2).*Obs_mean(:,3));
      mean(Obs_mean(:,3).*Obs_mean(:,1)) mean(Obs_mean(:,3).*Obs_mean(:,2)) mean(Obs_mean(:,3).*Obs_mean(:,3))];


R_x  =R_x/10000;       
R_xy =R_xy/10000;   

H    =R_xy * inv(R_x);
%% Second step is to use the H matrix on new location with new power to get their estimation (as if your testing the H matrix)

ObsN = Pt - (10*pathloss*log10(DN)) + X_sigmadbn;
Obs_meanN = [ObsN(:,1)-mean(ObsN(:,1)) ObsN(:,2)-mean(ObsN(:,2)) ObsN(:,3)-mean(ObsN(:,3))];

Est  = Obs_meanN*H';

mse  = [mse mean(sum((Signal_meanN-Est).^2,2))];     
end

%% plotting
figure()
plot(Loop,mse)
grid on 