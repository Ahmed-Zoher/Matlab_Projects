clc
clear all 
close all

size=10000;

%generate random binary input
input=round(rand(1,size))
phi1=1;

%--------------------------------------------------------------------------
%without fading
% 1-coherent BPSK
%polar NRZ level encoder 
nrz=input;

for i=1:1:(size)
    if input(i)==0
      nrz(i)=-1;
    end    
end
%multiplying signal with phi1
bpsk=phi1.*nrz;



%channel
ppp=1;
for SNR=0:1:30
bpskc=awgn(bpsk,SNR);



%demodulation
bpsk1=phi1.*bpskc;
bpsk2=[];
for i=1:1:(size)
    temp=bpsk1(i);
    if temp>0
        bpsk2(i)=1;
    else
        bpsk2(i)=0;
    end
end

 BERbpsk(ppp)=sum(xor(bpsk2,input))/length(input);
 ppp=ppp+1;
end

%--------------------------------------------------------------------------
%with fading
% 1-coherent BPSK
%polar NRZ level encoder 
nrz=input;

for i=1:1:(size)
    if input(i)==0
      nrz(i)=-1;
    end    
end
%multiplying signal with phi1
bpsk=phi1.*nrz;



%channel
ppp=1;
for SNR=0:1:30

h=randn(1,size)+(j.*randn(1,size));
sh=bpsk.*h;
bpskc=awgn(sh,SNR);
% Ps=sum((input.^2))/size;
% Pn=Ps/(10^(SNR/10));
% n=sqrt(Pn);
% bpskc=sh+n;

%demodulation
bpskc=real(bpskc);
bpskc=bpskc./h;
bpsk1=phi1.*bpskc;
bpsk2=[];
for i=1:1:(size)
    temp=bpsk1(i);
    if temp>0
        bpsk2(i)=1;
    else
        bpsk2(i)=0;
    end
end

 BERbpsk1(ppp)=sum(xor(bpsk2,input))/length(input);
 ppp=ppp+1;
end

SNR=0:1:30;
plot(SNR,BERbpsk)
title('SNR vs bpsk BER without channel fading');
figure();
plot(SNR,BERbpsk1)
title('SNR vs bpsk BER with channel fading');
