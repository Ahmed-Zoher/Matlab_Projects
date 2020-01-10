clc
clear all
close all 

Rho= 0.7;
X=zeros(6,100000);
X(1,:)=normrnd(0,1,1,100000);

for i=2:6
    X(i,:)= X(i-1,:)*Rho + normrnd(0,sqrt(1-Rho^2),1,100000);
end
Obs=X(1:1:5,:);
Signal= X(6,:);

Obs_mean = [Obs(1,:)-mean(Obs(1,:)); Obs(2,:)-mean(Obs(2,:)) ;Obs(3,:)-mean(Obs(3,:)); Obs(4,:)-mean(Obs(4,:)); Obs(5,:)-mean(Obs(5,:))];
Signal_mean=Signal-mean(Signal);

Obs_mean=Obs_mean';
Signal_mean=Signal_mean';
Signal=Signal';
Obs=Obs';

R_xy =[];
R_xy =[mean(Signal_mean(:,1).*Obs_mean(:,1)) mean(Signal_mean(:,1).*Obs_mean(:,2)) mean(Signal_mean(:,1).*Obs_mean(:,3)) mean(Signal_mean(:,1).*Obs_mean(:,4)) mean(Signal_mean(:,1).*Obs_mean(:,5))];
     


R_x =[];
R_x =[mean(Obs_mean(:,1).*Obs_mean(:,1)) mean(Obs_mean(:,1).*Obs_mean(:,2)) mean(Obs_mean(:,1).*Obs_mean(:,3)) mean(Obs_mean(:,1).*Obs_mean(:,4)) mean(Obs_mean(:,1).*Obs_mean(:,5));
      mean(Obs_mean(:,2).*Obs_mean(:,1)) mean(Obs_mean(:,2).*Obs_mean(:,2)) mean(Obs_mean(:,2).*Obs_mean(:,3)) mean(Obs_mean(:,2).*Obs_mean(:,4)) mean(Obs_mean(:,2).*Obs_mean(:,5));
      mean(Obs_mean(:,3).*Obs_mean(:,1)) mean(Obs_mean(:,3).*Obs_mean(:,2)) mean(Obs_mean(:,3).*Obs_mean(:,3)) mean(Obs_mean(:,3).*Obs_mean(:,4)) mean(Obs_mean(:,3).*Obs_mean(:,5));
      mean(Obs_mean(:,4).*Obs_mean(:,1)) mean(Obs_mean(:,4).*Obs_mean(:,2)) mean(Obs_mean(:,4).*Obs_mean(:,3)) mean(Obs_mean(:,4).*Obs_mean(:,4)) mean(Obs_mean(:,4).*Obs_mean(:,5))
      mean(Obs_mean(:,5).*Obs_mean(:,1)) mean(Obs_mean(:,5).*Obs_mean(:,2)) mean(Obs_mean(:,5).*Obs_mean(:,3)) mean(Obs_mean(:,5).*Obs_mean(:,4)) mean(Obs_mean(:,5).*Obs_mean(:,5))];

  R_x  =R_x/100000;       
R_xy =R_xy/100000;   

H    =R_xy * inv(R_x);

New=zeros(6,100000);
New(1,:)=normrnd(0,1,1,100000);

for i=2:6
    New(i,:)= New(i-1,:)*Rho + normrnd(0,sqrt(1-Rho^2),1,100000);
end
Obsn=New(1:1:5,:);
Signaln= New(6,:);

Obs_meann = [Obsn(1,:)-mean(Obsn(1,:)); Obsn(2,:)-mean(Obsn(2,:)) ;Obsn(3,:)-mean(Obsn(3,:)); Obsn(4,:)-mean(Obsn(4,:)); Obsn(5,:)-mean(Obsn(5,:))];
Signal_meann=Signal-mean(Signaln);

Est  = H*Obs_meann;

 mse=mean((Signaln-Est).^2);