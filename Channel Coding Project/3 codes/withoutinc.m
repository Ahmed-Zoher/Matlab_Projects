function [mov] = withoutinc(string)
% Mfile of the channelcoding without incremental redundancy  
mov=aviread(string);% read the input video
trellis = poly2trellis(7,[133 171]);% representing the trellis
puncturing_1_2 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; %(1/2)rate puncturing pattern(of no use as convenc initialy do the job)


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
       if(r ~= t)                                           %encoding 
       k = s((r*1024)+1:((r+1)*1024));
       L = convenc(k,trellis);       
       c = bsc(L,0.001); %2048 passed over the channel then punctured here the probability of error =0.1
       length(c);
       
       
       decoded_5 = vitdec(c, trellis, 40, 'trunc', 'hard',puncturing_1_2); %decoding
       received((r*1024)+1:((r+1)*1024)) = decoded_5;
                  
 

       end
         
   end
   
    
   received2 = reshape(received,76032,8);
   received3 = bi2de(received2);
red_new=reshape(received3(1:25344),144,176); % 2D matrix containing Red of one frame
green_new=reshape(received3(25345:50688),144,176); % 2D matrix containing green of one frame
blue_new=reshape(received3(50689:76032),144,176); % 2D matrix containing blue of one frame
 
z_new=uint8(cat(3,red_new,green_new,blue_new)); % create a 3D matrix for frame(i)
 
mov(i).cdata=z_new;
 mov(i).colormap=[];

end
movieview(mov)
movie2avi(mov,'mov3.avi');%saving the video 

end

