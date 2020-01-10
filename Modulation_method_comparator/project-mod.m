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

%-------------------------------------------------------
% 2-coherent OOK
   %considering E=1
OOK=phi1.*encoded;
%-------------------------------------------------------

%------------------------------------------------------
% 3-8psk
     
bin=[]; %converting the binary input to decimal from 0 to 7
% for i=1:3:size
%     bin=[bin;input(i:i+2)];
% end
% dec=bi2de(bin,'left-msb');
% lst=[];
% for i=1:1:size/3
%     lst=[lst dec(i)];
% end
% for i=1:1:size/3
%     num=lst(i);
%     switch num
%         case 1
%           psk(i)=(1*phi1)+(0*phi2);  
%         case 2
%           psk(i)=((1/sqrt(2))*phi1)+(0*phi2); 
%         case 3
%           psk(i)=(0*phi1)+(1*phi2);     
%         case 4
%           psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
%         case 5
%           psk(i)=(-1*phi1)+(0*phi2);   
%         case 6
%           psk(i)=((-1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
%         case 7 
%           psk(i)=(0*phi1)+(-1*phi2);  
%         case 8 
%           psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);
%           
%     end          
% end
% psk
%------------------------------------------------------
ppp=1;
for SNR=-10:1:10
    
%channel
bpskc=awgn(bpsk,SNR);
OOKc=awgn(OOK,SNR);



%------------------------------------------------------
%1-demodulation of bpsk 
bpsk1=phi1.*bpskc;
for i=1:1:(size*2)
    temp=int(bpsk1(i),t,0,Tb);
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
    temp=int(OOK1(i),t,0,Tb);
    if temp>0.5
        OOK2(i)=1;
    else
       OOK2(i)=0;
    end
end

%------------------------------------------------------

%------------------------------------------------------
% 3-demodulation of 8psk

%------------------------------------------------------


%channel decoder
 decoded1=vitdec(bpsk2,trellis,10,'trunc','hard')
 decoded2=vitdec(OOK2,trellis,10,'trunc','hard')
 
 BERbpsk(ppp)=sum(xor(decoded1,input))/length(input);
 BEROOK(ppp)=sum(xor(decoded2,input))/length(input);
 ppp=ppp+1;
end
%-------------------------------------------------------------------------
%without channel coding
%Modulation
phi1=1;
encoded=input;
%phi1=sqrt(2/Tb)*cos(2*pi*fc*t);
phi2=sqrt(2/Tb)*sin(2*pi*fc*t);
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
%-------------------------------------------------------

%-------------------------------------------------------
% 2-coherent OOK
   %considering E=1
OOK=phi1.*encoded;
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
for i=1:1:size/3
    num=lst(i);
    switch num
        case 1
          psk(i)=(1*phi1)+(0*phi2);  
        case 2
          psk(i)=((1/sqrt(2))*phi1)+(0*phi2); 
        case 3
          psk(i)=(0*phi1)+(1*phi2);     
        case 4
          psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
        case 5
          psk(i)=(-1*phi1)+(0*phi2);   
        case 6
          psk(i)=((-1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);   
        case 7 
          psk(i)=(0*phi1)+(-1*phi2);  
        case 8 
          psk(i)=((1/sqrt(2))*phi1)+((-1/sqrt(2))*phi2);
          
    end          
end
psk
%------------------------------------------------------
ppp=1;
for SNR=-10:1:10
    
%channel
bpskc=awgn(bpsk,SNR);
OOKc=awgn(OOK,SNR);
pskc=awgn(psk,SNR);


%------------------------------------------------------
%1-demodulation of bpsk 
bpsk1=phi1.*bpskc;
for i=1:1:(size)
    temp=int(bpsk1(i),t,0,Tb);
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
for i=1:1:(size)
    temp=int(OOK1(i),t,0,Tb);
    if temp>0.5
        OOK2(i)=1;
    else
       OOK2(i)=0;
    end
end

%------------------------------------------------------

%------------------------------------------------------
% 3-demodulation of 8psk

%------------------------------------------------------


%channel decoder
 decoded1=vitdec(bpsk2,trellis,10,'trunc','hard')
 decoded2=vitdec(OOK2,trellis,10,'trunc','hard')
 
 BERbpsk1(ppp)=sum(xor(decoded1,input))/length(input);
 BEROOK1(ppp)=sum(xor(decoded2,input))/length(input);
 ppp=ppp+1;
end

%------------------------------------------------------------------------






SNR=-10:1:10;

% plot(SNR,BERbpsk)
% title('SNR vs bpsk BER with channel coding');
% figure();
% plot(SNR,BERbpsk1)
% title('SNR vs bpsk BER without channel coding');
% figure();
% plot(SNR,BEROOK)
% title('SNR vs OOK BER with channel coding');
% figure();
% plot(SNR,BEROOK1)
% title('SNR vs OOK BER without channel coding');
% figure();
% plot(SNR,BERbpsk,'g')
% hold on
% plot(SNR,BEROOK,'r')
% hold on
% title('SNR vs bpsk and OOK BER with channel coding');
% figure();
% plot(SNR,BERbpsk1,'g')
% hold on
% plot(SNR,BEROOK1,'r')
% hold on
% title('SNR vs bpsk and OOK BER without channel coding');
