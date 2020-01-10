clc
clear all
close all
x= rand(1,20000)*6+1;
y= rand(1,20000)*4+1;
d1=[];
d2=[];
d3=[];
for i=1:20000
    d1(i)= sqrt((x(i)-0)^2+(y(i)-0)^2+2.25 );
    d2(i)= sqrt((x(i)-0)^2+(y(i)-6)^2+2.25 );
    d3(i)= sqrt((x(i)-8)^2+(y(i)-6)^2+2.25 );
end
xm = x - mean(x);
ym = y - mean(y);
mu = 0;
variance = 4;
% % get the power
% p1 = -5 - (10*3*log10(d1))+normrnd(mu,variance);
% p2 = -5 - (10*3*log10(d2))+normrnd(mu,variance);
% p3 = -5 - (10*3*log10(d3))+normrnd(mu,variance);
% 
% p1 = p1 - mean(p1);
% p2 = p2 - mean(p2);
% p3 = p3 - mean(p3);
% 
% pm = [p1;p2;p3];
% 
% xT = transpose(xm);
% yT = transpose(ym);
% pT = transpose(pm);
% 
% % Robs_sig = 1/20000*([ x*pT ;y*pT]);
% % %Robs_sig = transpose(RTobs_sig);
% % Robs = 1/20000*transpose([ pm*pT]);
% xpm = [mean(xm.*p1),mean(xm.*p2),mean(xm.*p3)];
% ypm= [mean(ym.*p1),mean(ym.*p2),mean(ym.*p3)];   %Rxy
% 
% obsp1 = [mean(p1.*p1),mean(p1.*p2),mean(p1.*p3)];
% obsp2 = [mean(p2.*p1),mean(p2.*p2),mean(p2.*p3)];
% obsp3 = [mean(p3.*p1),mean(p3.*p2),mean(p3.*p3)];
% Robs_sig = 1/20000*([ xpm;ypm]);
% %Robs_sig_new = transpose(RTobs_sig);
%  Robs =1/20000* transpose([ obsp1; obsp2 ;obsp3]);
% H = Robs_sig*inv(Robs);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xnew= rand(1,20000)*6+1;
ynew= rand(1,20000)*4+1;

for i=1:20000
    d11(i)= sqrt((xnew(i)-0)^2+(ynew(i)-0)^2+2.25 );
    d22(i)= sqrt((xnew(i)-0)^2+(ynew(i)-6)^2+2.25 );
    d33(i)= sqrt((xnew(i)-8)^2+(ynew(i)-6)^2+2.25 );
end
xm_new = xnew - mean(xnew);
ym_new = ynew - mean(ynew);


% (2) n= 2.7:0.05:4 %
MSE = [];
o= 2.7:0.05:4;

for n=2.7:0.05:4
 p1_new = -5 - (10*n*log10(d1)) + normrnd(mu,variance,1,20000);
 p2_new = -5 - (10*n*log10(d2)) + normrnd(mu,variance,1,20000);
 p3_new = -5 - (10*n*log10(d3)) + normrnd(mu,variance,1,20000);
 
 p1m_new = p1_new - mean(p1_new);
 p2m_new = p2_new - mean(p2_new);
 p3m_new = p3_new - mean(p3_new);

 xpm_new = [mean(xm.*p1m_new),mean(xm.*p2m_new),mean(xm.*p3m_new)];
 ypm_new = [mean(ym.*p1m_new),mean(ym.*p2m_new),mean(ym.*p3m_new)];

 obsp1_new = [mean(p1m_new.*p1m_new),mean(p1m_new.*p2m_new),mean(p1m_new.*p3m_new)];
 obsp2_new = [mean(p2m_new.*p1m_new),mean(p2m_new.*p2m_new),mean(p2m_new.*p3m_new)];
 obsp3_new = [mean(p3m_new.*p1m_new),mean(p3m_new.*p2m_new),mean(p3m_new.*p3m_new)];

xT = transpose(xm);
yT = transpose(ym);
% pT_new = transpose(pm_new);

Robs_sig_new = 1/20000 * [ xpm_new;ypm_new];
%Robs_sig_new = transpose(RTobs_sig);
Robs_new = 1/20000 * [obsp1_new ; obsp2_new ;obsp3_new];
H_new = Robs_sig_new * inv(Robs_new);

% To get the mse, we are testing the H on new locations:

% get the power
p11 = -5 - (10*n*log10(d11)) + normrnd(mu,variance,1,20000);
p22 = -5 - (10*n*log10(d22)) + normrnd(mu,variance,1,20000);
p33 = -5 - (10*n*log10(d33)) + normrnd(mu,variance,1,20000);

p11 = p11 - mean(p11);
p22 = p22 - mean(p22);
p33 = p33 - mean(p33);

pm_new = [p11;p22;p33];

obsp1 = [mean(p11.*p11),mean(p11.*p22),mean(p11.*p33)];
obsp2 = [mean(p22.*p11),mean(p22.*p22),mean(p22.*p33)];
obsp3 = [mean(p33.*p11),mean(p33.*p22),mean(p33.*p33)];

xT_new = transpose(xm_new);
yT_new = transpose(ym_new);
pT_new = transpose(pm_new);

% RTobs_sig = 1/20000*([ x*pT ;y*pT]);
% %Robs_sig = transpose(RTobs_sig);
Robs_newt = 1/20000 * transpose([obsp1;obsp2;obsp3]);

estimated = H_new*pm_new;
MSE = [MSE mean(sum(([xm_new;ym_new]- estimated).^2,1))];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(o,MSE)
% (3)
u = [0:0.2:8];
MSE2=[];
for variance=0:0.2:8
 p1_new1 = -5 - (10*3*log10(d1)) + normrnd(mu,variance,1,20000);
 p2_new1 = -5 - (10*3*log10(d2)) + normrnd(mu,variance,1,20000);
 p3_new1 = -5 - (10*3*log10(d3)) + normrnd(mu,variance,1,20000);
 
 p1m_new1 = p1_new1 - mean(p1_new1);
 p2m_new1 = p2_new1 - mean(p2_new1);
 p3m_new1 = p3_new1 - mean(p3_new1);

 xpm_new1 = [mean(xm.*p1m_new1),mean(xm.*p2m_new1),mean(xm.*p3m_new1)];
 ypm_new1 = [mean(ym.*p1m_new1),mean(ym.*p2m_new1),mean(ym.*p3m_new1)];

 obsp1_new1 = [mean(p1m_new1.*p1m_new1),mean(p1m_new1.*p2m_new1),mean(p1m_new1.*p3m_new1)];
 obsp2_new1 = [mean(p2m_new1.*p1m_new1),mean(p2m_new1.*p2m_new1),mean(p2m_new1.*p3m_new1)];
 obsp3_new1 = [mean(p3m_new1.*p1m_new1),mean(p3m_new1.*p2m_new1),mean(p3m_new1.*p3m_new1)];

xT = transpose(xm);
yT = transpose(ym);
% pT_new = transpose(pm_new);

Robs_sig_new1 = 1/20000 * [ xpm_new1;ypm_new1];
%Robs_sig_new = transpose(RTobs_sig);
Robs_new1 = 1/20000 * [obsp1_new1 ; obsp2_new1 ;obsp3_new1];
H_new1 = Robs_sig_new1 * inv(Robs_new1);

% To get the mse, we are testing the H on new locations:

% get the power
p111 = -5 - (10*3*log10(d11)) + normrnd(mu,variance,1,20000);
p221 = -5 - (10*3*log10(d22)) + normrnd(mu,variance,1,20000);
p331 = -5 - (10*3*log10(d33)) + normrnd(mu,variance,1,20000);

p111 = p111 - mean(p111);
p221 = p221 - mean(p221);
p331 = p331 - mean(p331);

pm_new1 = [p111;p221;p331];

obsp1 = [mean(p11.*p11),mean(p11.*p22),mean(p11.*p33)];
obsp2 = [mean(p22.*p11),mean(p22.*p22),mean(p22.*p33)];
obsp3 = [mean(p33.*p11),mean(p33.*p22),mean(p33.*p33)];

xT_new = transpose(xm_new);
yT_new = transpose(ym_new);
pT_new = transpose(pm_new);

% RTobs_sig = 1/20000*([ x*pT ;y*pT]);
% %Robs_sig = transpose(RTobs_sig);
Robs_newt = 1/20000 * transpose([obsp1;obsp2;obsp3]);

estimated1 = H_new1*pm_new1;
MSE2 = [MSE2 mean(sum(([xm_new;ym_new]- estimated1).^2,1))];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
plot(u,MSE2)




