clc
clear all
close all

variable = [0:0.01:7];                                                     %Random Variable
L        = 10;                                                             %Number of levels
sigma   = [0.5,2];                                                         %Scale prameters  
level_max= 70;                                                             %End number of levels for plotting SQNR
L_start  = L;                                                              %Start number of levels for plotting SQNR                                                             
SQNR_ts=[];

for s=1:1:2
    
sigma2   = sigma(s);   
X        = raylpdf(variable,sigma2);                                       %Rayleigh pdf
figure()
plot(variable,X)                                                           %Rayleigh pdf plot
if s==1
title('Rayleigh pdf at Scale Parameter of "0.5"')
else
title('Rayleigh pdf at Scale Parameter of "2"')
end
grid on
xlabel('Random Variable')
ylabel('Rayleigh pdf')
SQNR_t   = [];

for L= L_start:2:level_max
    
yk       = [0:0.1:0.1*(L-1)];                                              %Representation levels --> (L)
xk       = yk(1:L-1)+yk(2:L);                                              %Decision levels       --> (L-1)                    
xk       = xk/2;                                                           %Since optimal quantizer

    
counter  = 1;
change   = 100000;  
thresh   = 0.00001;
while abs(change) > thresh

addition = 0;
yk_new   = [];
D        = [];
SQNR     = [];
for k=1:1:L
    if k==1
        Low=-1;
    else 
        Low=xk(k-1);
    end
    if k==L
        High=1000000;
    else 
        High=xk(k);
    end
    
    %     for x = 1:1:length(X)
    %         addition = addition + (x*(X(x)/sum(X(find(U<X<xk(k)))))*dx);
    %
    %     end
    
    indeces  = intersect(find(Low<variable),find(variable<High));
    addition = sum(variable(indeces).*(X(indeces)/sum(X(indeces))));
    yk_new   = [yk_new addition];
    
    D_temp   = sum(((variable(indeces)-addition).^2).*(X(indeces)/sum(X(indeces))));
    D_temp2  = D_temp*sum(X(indeces));
    D        = [D D_temp2];
    
    E_x2     = sum(X(indeces))*sum(((variable(indeces)).^2).*(X(indeces)/sum(X(indeces))));
    SQNR     = [SQNR E_x2];
end
xk_old   = xk;
xk       = yk_new(1:L-1)+yk_new(2:L);                                                      
xk       = xk/2; 

if counter > 1
dist_old     = distortion;
distortion   = sum(D);
dist_new     = distortion;

change       = dist_old-dist_new;
else
distortion   = sum(D); 
end
SQNR         = sum(SQNR)/distortion;
counter      = counter+1;

%% Plot pdf with levels
% figure()
% plot(variable,X)
% hold on 
% stem([0 xk_old],yk_new)
end
if L == 16
figure()
plot(variable,X)
hold on 
grid on
stem([0 xk_old],yk_new)
if s==1
title('PDF with Quantizer at Scale Parameter of "0.5" at L = 16')
else
title('PDF with Quantizer at Scale Parameter of "2" at L = 16')
end
legend('PDF for the random variable','Quantizer levels')
xlabel('Decision Levels')
ylabel('Representation Values')
end
SQNR_t       = [SQNR_t SQNR];
end

SQNR_ts=[SQNR_ts; SQNR_t];
figure()
semilogy(L_start:2:level_max,10*log(SQNR_t))
grid on
if s==1
title('SQNR vs No. of Levels at Scale Parameter of "0.5"')
else
title('SQNR vs No. of Levels at Scale Parameter of "2"')
end
xlabel('No. of Levels')
ylabel('SQNR in (dB)')
s
end

     
figure()
semilogy(L_start:2:level_max,10*log(SQNR_ts(1,:)))                                                           
hold on 
semilogy(L_start:2:level_max,10*log(SQNR_ts(2,:)))  

title('SQNR at Scale Parameter of "0.5" and "2"')
legend('Scale Parameter = 0.5','Scale Parameter = 2')
grid on
xlabel('No. of Levels')
ylabel('SQNR in (dB)')