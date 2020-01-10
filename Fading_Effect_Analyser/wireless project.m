clc
clear all 
close all

size=10;

%generate random binary input
input=round(rand(1,size))
phi1=1;


% 1-coherent BPSK
%polar NRZ level encoder 
nrz=input;
for i=1:1:(size*2)
    if input(i)==0
      nrz(i)=-1;
    end    
end
%multiplying signal with phi1
bpsk=phi1.*nrz;



%channel
bpskc=bpsk
%demodulation
bpsk1=phi1.*bpskc;
bpsk2=[];
for i=1:1:(size*2)
    temp=bpsk1(i);
    if temp>0
        bpsk2(i)=1;
    else
        bpsk2(i)=0;
    end
end
output=bpsk2