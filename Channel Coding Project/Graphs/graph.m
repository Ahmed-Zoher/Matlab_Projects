function [mov] = graph(string)
% Mfile of graphs of the channelcoding with incremental redundancy  
mov=aviread(string); % read the input video
trellis = poly2trellis(7,[133 171]); % representing the trellis
puncturing_8_9 = [1 1 1 0 1 0 1 0 0 1 1 0 1 0 1 0]; %(8/9)rate puncturing pattern
puncturing_4_5 = [1 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0]; %(4/5)rate puncturing pattern
puncturing_2_3 = [1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0]; %(2/3)rate puncturing pattern
puncturing_4_7 = [1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0]; %(4/7)rate puncturing pattern
puncturing_1_2 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; %(1/2)rate puncturing pattern

N_Punct = ceil(2048/16);% to get how many (16 bit packets) in the 2048 packet 

counter23 = 1; % a counter for ber calculations

for p=0.0001:0.01:0.22  %looping over different probabilities
    i=1; % plotting one frame only to save time 

   block = mov(i).cdata;
   r=block(:,:,1);                             %getting the first_matrix (red) of the cdata of the frame
   g=block(:,:,2);                             %getting the second_matrix (green)of the cdata of the frame
   b=block(:,:,3);                             %getting the third_matrix (blue) of the cdata of the frame
   red=reshape(r,1,[]);                        %transposing r then reshaping it in one row
   green=reshape(g,1,[]);                      %transposing g then reshaping it in one row
   blue=reshape(b,1,[]);                       %transposing b then reshaping it in one row
   concat=[red green blue];                    % concatenuate the 3 colors toghether
   binary = de2bi(concat);                     % converting the vector into binary
   s = reshape(binary,1,[]);                   % reshaping it into a single row vector
   t=ceil(length(s)/1024);                     %getting how many packets of length 1024 in the frame
   received = zeros(1,length(s));
   q=0; % a counter to get the no of bits transmitted for throughput calculations
   for r = 0:1:t-1      
       if(r ~= t)                                           %encoding 
       k = s((r*1024)+1:((r+1)*1024));
       L = convenc(k,trellis);       
       c = bsc(L,p); %2048 passed over the channel then punctured 
       length(c);      
       punctured1 = zeros(1,1152);                          %puncturing 
       counter1 = 1;
       for o1 = 0:1:N_Punct
           if(o1 ~= N_Punct)
               for f = (o1*16)+1:((o1+1)*16);
               if (puncturing_8_9(f - (o1*16)) == 1)
                   punctured1(counter1) = c(f);
                   counter1 = counter1 + 1;
               end               
               end
           end        
       end
 decoded_1 = vitdec(punctured1, trellis,40, 'trunc', 'hard',puncturing_8_9);   %decoding
if(xor(decoded_1,k)==0) %comparing the decoded bits with the transmitted
    received((r*1024)+1:((r+1)*1024)) = decoded_1;
    q=q+1152;
else
    punctured2 = zeros(1,1280);
       counter2 = 1;
       for o2 = 0:1:N_Punct
           if(o2 ~= N_Punct)
               for f2 = (o2*16)+1:((o2+1)*16);
               if (puncturing_4_5(f2 - (o2*16)) == 1)
                   punctured2(counter2) = c(f2);
                   counter2 = counter2 + 1;
               end
               end
           end
       end       
  decoded_2 = vitdec(punctured2, trellis, 40, 'trunc', 'hard',puncturing_4_5);   %decoding     
 if(xor(decoded_2,k)==0)% either 0 or 1 compare with the transmitted and if there is error upgrade
     received((r*1024)+1:((r+1)*1024)) = decoded_2;
     q=q+1280;
 else     
punctured3 = zeros(1,1536);
       counter3 = 1;
       for o3 = 0:1:N_Punct
           if(o3 ~= N_Punct)
               for f3 = (o3*16)+1:((o3+1)*16);
               if (puncturing_2_3(f3 - (o3*16)) == 1)
                   punctured3(counter3) = c(f3);
                   counter3 = counter3 + 1;
               end
               end
           end
       end       
       decoded_3 = vitdec(punctured3, trellis, 40, 'trunc', 'hard',puncturing_2_3);     
        if(xor(decoded_3,k)==0)
            received((r*1024)+1:((r+1)*1024)) = decoded_3;
            q=q+1536;
        else
            punctured4 = zeros(1,1792);
       counter4 = 1;
       for o4 = 0:1:N_Punct
           if(o4 ~= N_Punct)
               for f4 = (o4*16)+1:((o4+1)*16);
               if (puncturing_4_7(f4 - (o4*16)) == 1)
                   punctured4(counter4) = c(f4);
                   counter4 = counter4 + 1;
               end
               end
           end
       end     
       decoded_4 = vitdec(punctured4, trellis, 40, 'trunc', 'hard',puncturing_4_7);     
       if(xor(decoded_4,k)==0)
           received((r*1024)+1:((r+1)*1024)) = decoded_4;
           q=q+1792;           
       else         
       punctured5 = zeros(1,2048);
       counter5 = 1;
       for o5 = 0:1:N_Punct
           if(o5 ~= N_Punct)
               for f5 = (o5*16)+1:((o5+1)*16);
               if (puncturing_1_2(f5 - (o5*16)) == 1)
                   punctured5(counter5) = c(f5);
                   counter5 = counter5 + 1;
               end
               end
           end
       end     
   decoded_5 = vitdec(punctured5, trellis, 40, 'trunc', 'hard',puncturing_1_2);     
       received((r*1024)+1:((r+1)*1024)) = decoded_5;
       q=q+2048;
      end
        end     
 end 
end
       end        
   end
[number(counter23),ratio(counter23)] = biterr(s,received); % calculating coded bit error probability
received2 = reshape(received,76032,8);
received3 = bi2de(received2);
red_new=reshape(received3(1:25344),144,176); % 2D matrix containing Red of one frame
green_new=reshape(received3(25345:50688),144,176); % 2D matrix containing green of one frame
blue_new=reshape(received3(50689:76032),144,176); % 2D matrix containing blue of one frame
z_new=uint8(cat(3,red_new,green_new,blue_new)); % create a 3D matrix for frame(i)
mov(i).cdata=z_new;
mov(i).colormap=[];
throughput(counter23)=length(s)/q % calculating the througput by dividing the length of the transmitted frame by the total no of bits transmitted 
counter23 = counter23 + 1; % incrementing the counter 
end

p=0.0001:0.01:0.22;
figure(1); % plotting of ber & throughput vs probability
plot(p,ratio);
title('coded bit error probability')
figure(2);
plot(p,throughput);
title('throughput')
end



