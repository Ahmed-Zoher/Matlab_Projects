clc
close all
clear all
fc=1000;
Ac=1;
ka=0.1;
[mt,fs]=wavread('woman1_nb');

ts=1/fs;
t=0:ts:(length(mt)-1)/fs;
f = ((-fs/2):fs/length(t):((fs/2)-(fs/length(t))));
ct=Ac*cos(2*pi*fc*t);
figure(1)
plot(t,ct)
title('carrier');

ctf=fftshift(abs(fft(ct)))/length(ct);
figure(20);
plot(f,ctf)  %Carrier signal in frequency domain.
title('Carrier frequency domain');

figure(2);
plot(t,mt) %Modulating signal in time domain.
title('Modulating time domain');

mtf=fftshift(abs(fft(mt)))/length(mt);

figure(3);
plot(f,mtf)  %Modulating signal in frequency domain.
title('Modulating frequency domain');

 load gong.mat
 gong=audioplayer(mt,fs);
 play(gong)
a=1+(ka.*mt);
st = a.*ct';

figure(4)
plot(t,st)
title('Modulated signal time domain');


stfft=fftshift(abs(fft(st)))/length(st); %Modulated signal in frequency domain

figure(5);
plot(f,stfft)
title('Modulated in freuency domain');
 
AddNoise1=awgn(st,-1000);
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

stHilb=hilbert(AddNoise1);
absStHilb=abs(stHilb);
noAc=absStHilb./Ac;
noOne=noAc-1;
demodulated=noOne./ka;
figure(9);
plot(t,demodulated)
title('demodulated signal');

% load gong.mat
% gong=audioplayer(demodulated,fs);
% play(gong)

%AddNoise11=awgn(demodulated,-10);
%figure(10);
%plot(AddNoise11)
%title('-10 Noise demodulated');

%AddNoise22=awgn(demodulated,0);
%figure(11);
%plot(AddNoise22)
%title('0 Noise demodulated');

%AddNoise33=awgn(demodulated,15);
%figure(12);
%plot(AddNoise33)
%title('15 Noise demodulated');

% DSB 

DSB = Ac*mt ;
DSBMod = DSB.*ct' ;
figure(13);
plot(t,DSBMod)
title('DSB MOD Time domain');

DSBMod2 = fftshift(abs(fft(DSBMod)))/length(DSBMod); 
figure(14);
plot(f,DSBMod2)
title('DSB MOD FREQ domain');

AddNoise111=awgn(DSBMod,-10);
figure(15);
plot(AddNoise111)
title('-10 Noise');
% load gong.mat
% gong=audioplayer(DSBMod,fs);
% play(gong)

AddNoise222=awgn(DSBMod,0);
figure(16);
plot(AddNoise222)
title('0 Noise');
%load gong.mat
%gong=audioplayer(demodulated,fs);
%play(gong)

AddNoise333=awgn(DSBMod,15);
figure(17);
plot(AddNoise333)
title('15 Noise');
%load gong.mat
%gong=audioplayer(demodulated,fs);
%play(gong)

DSBdemod=AddNoise333.*cos(2*pi*fc*t)';     
[b,a]=butter(5,0.2,'low');
DSBfilter=filter(b,a,DSBdemod);



% load gong.mat
% gong=audioplayer(DSBfilter,fs);
% play(gong)


%SSB 
ctt=Ac*sin(2*pi*fc*t);
SSBmod1=mt.*ct';
SSBmod2=imag(hilbert(mt)).*ctt';
SSBmodlower=SSBmod1+SSBmod2;
SSBmodupper=SSBmod1-SSBmod2;
figure(18);
plot(t,SSBmodlower);
title('LSB modulated time');
figure(19);
plot(f,fftshift(abs(fft(SSBmodlower)))/length(SSBmodlower));
title('LSB modulated freq');
figure(21);
plot(f,fftshift(abs(fft(SSBmodupper)))/length(SSBmodupper));
title('USB modulated freq');


AddNoise1111=awgn(SSBmodlower,-10);
figure(22);
plot(AddNoise1111)
title('-10 Noise');
%load gong.mat
%gong=audioplayer(DSBMod,fs);
%play(gong)

AddNoise2222=awgn(SSBmodlower,0);
figure(23);
plot(AddNoise2222)
title('0 Noise');
%load gong.mat
%gong=audioplayer(demodulated,fs);
%play(gong)


AddNoise3333=awgn(SSBmodlower,15);
figure(24);
plot(AddNoise3333)
title('15 Noise');
%load gong.mat
%gong=audioplayer(demodulated,fs);
%play(gong)


%USBdemod=SSBmodlower.*cos(2*pi*(fc)*t)';
USBdemod=SSBmodlower.*cos(2*pi*fc*t)';
[b,a]=butter(5,0.2,'low');
USBfilter=filter(b,a,USBdemod);


%  load gong.mat
%  gong=audioplayer(USBfilter,fs);
%  play(gong)



USBdemod1 = fftshift(abs(fft(USBfilter)))/length(USBfilter); 
figure(25);
plot(f,USBdemod1)
title('USB deMOD FREQ domain');
% load gong.mat
% gong=audioplayer(USBdemod,fs);
% play(gong)
 

