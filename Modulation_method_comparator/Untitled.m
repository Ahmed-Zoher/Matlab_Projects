clc
clear 
close all
syms t

Tb=1;
fc=1000;
size=12; %size must be multiple of 3 to be suitable for 8-PSK
%generate random binary input
input=round(rand(1,size))

%channel encoding


trellis=poly2trellis(7,[133 171]);
encoded=convenc(input,trellis);

encoded2=encoded;
%Modulation
phi1=1;

%phi1=sqrt(2/Tb)*cos(2*pi*fc*t);
phi2=j;
%-------------------------------------------------------
% 1-coherent BPSK
%polar NRZ level encoder       
for i=1:1:(size*2)
    if encoded(i)==0
      encoded(i)=-1;
    end    
end
%multiplying signal with phi1
bpsk=phi1.*encoded;
%-------------------------------------------------------
encoded=encoded2;
%-------------------------------------------------------
% 2-coherent OOK
   %considering E=1
OOK=phi1.*encoded;
%-------------------------------------------------------

%------------------------------------------------------
% 3-8psk
bin=[]; %converting the binary input to decimal from 0 to 7
for i=1:3:2*size
    bin=[bin;encoded(i:i+2)];
end
dec=bi2de(bin,'left-msb');
lst=[];
for i=1:1:2*size/3
    lst=[lst dec(i)];
end

psk=[];
for i=1:1:2*size/3
    num=lst(i);
    switch num
        case 0
          psk(i)=(1*phi1)+(0*phi2);  
        case 1
          psk(i)=((1/sqrt(2))*phi1)+((1/sqrt(2))*phi2); 
        case 2
          psk(i)=(0*phi1)+(1*phi2);     
        case 3
          psk(i)=((-1/sqrt(2))*phi1)+((1/sqrt(2))*phi2);   
        case 4
          psk(i)=(-1*phi1)+(0*phi2);   
        case 5
          psk(i)=((-1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
        case 6 
          psk(i)=(0*phi1)+(-1*phi2);  
        case 7 
          psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);
          
    end          
end
psk
%------------------------------------------------------
ppp=1;
for SNR=0:1:20
    
%channel
% bpskc=awgn(bpsk,SNR);
% OOKc=awgn(OOK,SNR);
%  pskc=awgn(psk,SNR);
pskc=psk;
bpskc=bpsk;
OOKc=OOK;


%------------------------------------------------------
%1-demodulation of bpsk 
bpsk1=phi1.*bpskc;
for i=1:1:(size*2)
    temp=bpsk1(i);
    if temp>0
        bpsk2(i)=1;
    else
        bpsk2(i)=0;
    end
end
%------------------------------------------------------

%-------------------------------------------------------
% 2-demodulation of coherent OOK
OOK1=phi1.*OOKc;
for i=1:1:(size*2)
    temp=OOK1(i);
    if temp>0.5
        OOK2(i)=1;
    else
       OOK2(i)=0;
    end
end

%------------------------------------------------------

%------------------------------------------------------
% 3-demodulation of 8psk
 
 psk2=[];

for l=1:1:2*size/3
    ang=angle(pskc(l));

    if(-1*pi/8<ang && ang<=pi/8)
        psk2=[psk2 0 0 0]; 
    else if (pi/8<ang && ang<=3*pi/8)
        psk2=[psk2 0 0 1];
    else  if (3*pi/8<ang && ang<=5*pi/8)
        psk2=[psk2 0 1 0];
        else if (5*pi/8<ang && ang<=7*pi/8)
        psk2=[psk2 0 1 1];
     else if  (-7*pi/8<ang && ang<=-5*pi/8)
        psk2=[psk2 1 0 1];
     else if (-5*pi/8<ang && ang<-3*pi/8)
        psk2=[psk2 1 1 0];
     else if  (-3*pi/8<ang && ang<=-1*pi/8) 
         psk2=[psk2 1 1 1];
         else   if (7*pi/8>ang || ang<=-7*pi/8)
       psk2=[psk2 1 0 0];
        end 
        end
        end
        end
        end
        end
        end
        end
    

end
psk2

%------------------------------------------------------


%channel decoder
 decoded1=vitdec(bpsk2,trellis,10,'trunc','hard');
 decoded2=vitdec(OOK2,trellis,10,'trunc','hard');
 decoded3=vitdec(psk2,trellis,10,'trunc','hard');
 
 BERbpsk(ppp)=sum(xor(decoded1,input))/length(input);
 BEROOK(ppp)=sum(xor(decoded2,input))/length(input);
 BERpsk(ppp)=sum(xor(decoded3,input))/length(input);%pe=3*ber
 ppp=ppp+1;
end
%-------------------------------------------------------------------------
%without channel coding
%Modulati
phi1=1;
encoded=input;
%phi1=sqrt(2/Tb)*cos(2*pi*fc*t);
phi2=j;
%-------------------------------------------------------
% 1-coherent BPSK
%polar NRZ level encoder       
for i=1:1:(size)
    if encoded(i)==0
      encoded(i)=-1;
    end    
end
%multiplying signal with phi1
bpsk=phi1.*encoded;
length(bpsk);
%-------------------------------------------------------

%-------------------------------------------------------
% 2-coherent OOK

   %considering E=1
OOK=phi1.*input;
%-------------------------------------------------------

%------------------------------------------------------
% 3-8psk
     
bin=[]; %converting the binary input to decimal from 0 to 7
for i=1:3:size
    bin=[bin;input(i:i+2)];
end
dec=bi2de(bin,'left-msb');
lst=[];
for i=1:1:size/3
    lst=[lst dec(i)];
end

psk=[];
for i=1:1:size/3
    num=lst(i);
    switch num
        case 0
          psk(i)=(1*phi1)+(0*phi2);  
        case 1
          psk(i)=((1/sqrt(2))*phi1)+((1/sqrt(2))*phi2); 
        case 2
          psk(i)=(0*phi1)+(1*phi2);     
        case 3
          psk(i)=((-1/sqrt(2))*phi1)+((1/sqrt(2))*phi2);   
        case 4
          psk(i)=(-1*phi1)+(0*phi2);   
        case 5
          psk(i)=((-1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
        case 6 
          psk(i)=(0*phi1)+(-1*phi2);  
        case 7 
          psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);
          
    end          
end
psk;

%------------------------------------------------------
ppp=1;
for SNR=1:1:20
    
%channel
% bpskc=awgn(bpsk,SNR);
% OOKc=awgn(OOK,SNR);
% pskc=awgn(psk,SNR);
pskc=psk;
bpskc=bpsk;
OOKc=OOK;

%------------------------------------------------------
%1-demodulation of bpsk 
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

%------------------------------------------------------

%-------------------------------------------------------
% 2-demodulation of coherent OOK
OOK1=phi1.*OOKc;
OOK2=[];
for i=1:1:(size)
    temp=OOK1(i);
    if temp>0.5
        OOK2(i)=1;
    else
       OOK2(i)=0;
    end
end

%------------------------------------------------------

%------------------------------------------------------
% 3-demodulation of 8psk
 
 psk2=[];
 
for l=1:1:size/3
    ang=angle(pskc(l));

    if(-1*pi/8<ang && ang<=pi/8)
        psk2=[psk2 0 0 0]; 
    else if (pi/8<ang && ang<=3*pi/8)
        psk2=[psk2 0 0 1];
    else  if (3*pi/8<ang && ang<=5*pi/8)
        psk2=[psk2 0 1 0];
        else if (5*pi/8<ang && ang<=7*pi/8)
        psk2=[psk2 0 1 1];
     else if  (-7*pi/8<ang && ang<=-5*pi/8)
        psk2=[psk2 1 0 1];
     else if (-5*pi/8<ang && ang<-3*pi/8)
        psk2=[psk2 1 1 0];
     else if  (-3*pi/8<ang && ang<=-1*pi/8) 
         psk2=[psk2 1 1 1];
         else   if (7*pi/8>ang || ang<=-7*pi/8)
       psk2=[psk2 1 0 0];
        end 
        end
        end
        end
        end
        end
        end
        end
    

end
psk2;

%------------------------------------------------------


%channel decoder
 

 BERbpsk1(ppp)=sum(xor(bpsk2,input))/length(input);
 BEROOK1(ppp)=sum(xor(OOK2,input))/length(input);
 BERpsk1(ppp)=sum(xor(psk2,input))/length(input);%pe=3*ber
 ppp=ppp+1;
end

%------------------------------------------------------------------------
   
SNR=1:1:20;
%bonus plot theoretical
    THbpsk=qfunc(sqrt(2*SNR));
    THOOK=qfunc(sqrt(SNR/2));
    THpsk=2*qfunc(sqrt(2*SNR)*sin(pi/8));
    
    
plot(SNR,BERbpsk)
title('SNR vs bpsk BER with channel coding');
figure();
plot(SNR,BERbpsk1)
title('SNR vs bpsk BER without channel coding');
figure();
plot(SNR,BEROOK)
title('SNR vs OOK BER with channel coding');
figure();
plot(SNR,BEROOK1)
title('SNR vs OOK BER without channel coding');
figure();
plot(SNR,BERpsk)
title('SNR vs 8psk BER with channel coding');
figure();
plot(SNR,BERpsk1)
title('SNR vs 8psk BER without channel coding');
figure();
plot(SNR,BERbpsk,'g')
hold on
plot(SNR,BEROOK,'r')
hold on
plot(SNR,BERpsk,'b')
hold on
title('SNR vs bpsk ,OOK and 8psk BER with channel coding');
figure();
plot(SNR,BERbpsk1,'g')
hold on
plot(SNR,BEROOK1,'r')
hold on
plot(SNR,BERpsk1,'b')
hold on
title('SNR vs bpsk ,OOK and 8psk BER without channel coding');

%bonus
figure();
plot(SNR,THbpsk,'g')
hold on
plot(SNR,BERbpsk,'r')
hold on
plot(SNR,BERbpsk1,'b')
title('theoretical bpsk vs simulated');

figure();
plot(SNR,THOOK,'g')
hold on
plot(SNR,BEROOK,'r')
hold on
plot(SNR,BEROOK1,'b')
title('theoretical OOK vs simulated');

figure();
plot(SNR,THpsk,'g')
hold on
plot(SNR,BERpsk.*3,'r')
hold on
plot(SNR,BERpsk1.*3,'b')
title('theoretical psk vs simulated');

