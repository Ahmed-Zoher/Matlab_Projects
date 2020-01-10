clc
clear all 
close all 
syms t
msg=wavread('D:\guc\sem 6\Modulation 1\project\noor.wav');
msgf=fft(msg);

figure(1)
plot(msg);%the time domain of the original msg
figure(2)
plot(abs(msgf));%the freq domain of the original msg

%GENERATING THE CARRIER
A=100;
fc=5*10^(9);
carrier=A*cos(2*pi*fc*t);

%Conventional AM
ka=1;
Scon=(1+ka*msg)*carrier;


%DSB modulation
Sdsb=carrier*msg;

%Generating random noise
[sss,ss]=size(Scon);
[ssss,ss]=size(Sdsb);
noise1=wgn(1,sss,10);

noise2=wgn(1,ssss,10);


%adding noise to conventional
Scon2=noise1+Scon;

%adding noise to DSB
Sdsb2=noise2+Sdsb;

%demodulation conventional
conv_demod=carrier*2*Sconv2;
%demodulation DSB
dsb_demod=carrier*2*Sdsb2;

a=getaudiodata(msg);
play(msg)
