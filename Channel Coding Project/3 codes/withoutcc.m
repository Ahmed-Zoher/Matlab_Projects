
function [mov] = withoutcc(string)
% Mfile of the channelcoding without channel coding  
mov=aviread(string);% read the input video

for i=1:30 %looping over the 30 video frames
    
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
   
   for r = 0:1:t-1      
       if(r ~= t)                              %encoding 
       k=zeros(1,1024);
       c=zeros(1,1024);
       k(1:1024) = s((r*1024)+1:((r+1)*1024));
       c(1:1024)= bsc(k,0.001);                %1024 passed over the channel here the probability of error =0.1
       received((r*1024)+1:((r+1)*1024)) = c(1:1024);
       end
   end
    
   length(received)    
   received2 = reshape(received,76032,8);
   received3 = bi2de(received2);
red_new=reshape(received3(1:25344),144,176); % 2D matrix containing Red of one frame
green_new=reshape(received3(25345:50688),144,176); % 2D matrix containing green of one frame
blue_new=reshape(received3(50689:76032),144,176); % 2D matrix containing blue of one frame 
z_new=uint8(cat(3,red_new,green_new,blue_new)); % create a 3D matrix for frame(i)
 
mov(i).cdata=z_new;
mov(i).colormap=[];

end
mov(1).cdata
movieview(mov)
movie2avi(mov,'mov2.avi');%saving the video 

end

