clc
close all
clear all
fc=1000;
Ac=1;
ka=0.1;
[mt,fs]=wavread('noor');
ts=1/fs;
t=0:ts:(length(mt)-1)/fs;
ct=Ac*cos(2*pi*fc*t);
figure(1)
plot(t,ct)
title('carrier');

figure(2);
plot(t,mt) %Modulating signal in time domain.
title('Modulating time domain');

ctf=abs(fft(mt));
figure(3);
plot(ctf)  %Modulating signal in frequency domain.
title('Modulating frequency domain');

load gong.mat
gong=audioplayer(mt,fs);
play(gong)

a=1+(ka.*mt);
st = a.*ct';
figure(4)
plot(t,st)
title('Modulated signal time domain');

stfft=abs(fft(st)); %Modulated signal in frequency domain
figure(5);
plot(t,stfft)
title('Modulated in freuency domain');
 
AddNoise1=awgn(st,-10);
figure(6);
plot(AddNoise1)
title('-10 Noise');
%load gong.mat
%gong=audioplayer(AddNoise1,fs);
%play(gong)

AddNoise2=awgn(st,0);
figure(7);
plot(AddNoise2)
title('0 Noise');
%load gong.mat
%gong=audioplayer(AddNoise2,fs);
%play(gong)

AddNoise3=awgn(st,15);
figure(8);
plot(AddNoise3)
title('15 Noise');
%load gong.mat
%gong=audioplayer(AddNoise3,fs);
%play(gong)

stHilb=hilbert(st);
absStHilb=abs(stHilb);
noAc=absStHilb./Ac;
noOne=noAc-1;
demodulated=noOne./ka;
figure(9);
plot(t,demodulated)
title('demodulated signal');
%load gong.mat
%gong=audioplayer(demodulated,fs);
%play(gong)

AddNoise11=awgn(demodulated,-10);
%figure(10);
%plot(AddNoise11)
%title('-10 Noise demodulated');

AddNoise22=awgn(demodulated,0);
%figure(11);
%plot(AddNoise22)
%title('0 Noise demodulated');

AddNoise33=awgn(demodulated,15);
%figure(12);
%plot(AddNoise33)
%title('15 Noise demodulated');

