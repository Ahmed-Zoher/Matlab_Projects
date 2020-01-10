clc 
clear all 
close all 
BW=25*10^(6);
BWch=200*10^(3);
areacity=450;
subs=5;
erlanguser=1/144;
ci=6.25;
Gtx=10^(0.6);
Grx=10^(0.3);
slots=8;
userslots=2;
pb=0.05;
sens=0.04; %Watts
Ptx=1; %watts
freq=2.4*10^(9);



%MileStone 1 with no sectoring 
%calculation reuse factor "N"
CIcurrent=0;
n=6;
N=0;
i=1;
j=0;
while (i<1000 && CIcurrent<ci)
    while( j<1000 && CIcurrent<ci)
       N=(i*i)+(i*j)+(j*j);
       CIcurrent=3*N/n;
       j=j+1;
    end
    i=i+1;
end
CIcurrent
N
Nch=BW/BWch;

Nchpcell=floor(Nch/N)*(slots/userslots);
Nchpcell
erlangcell=inverlangb(Nchpcell,pb);
erlangcell
subspcell=floor(erlangcell/erlanguser)
Ncells=ceil(subs/subspcell);
Ncells

%radius of cell
areacell=areacity/Ncells;
R=sqrt((2/(3*sqrt(3)))*areacell)

%checking the power rules with respect to "R" and "N"
Prx=Ptx*Gtx*Grx*((3*10^(8))/(freq*(4*pi*R)^(2)));
Prx
%changing the N if it is not suitable 
while (Prx<sens)
   
       N=(i*i)+(i*j)+(j*j);
       CIcurrent=3*N/n;
       j=j+1;
    
    i=i+1;
CIcurrent
N
Nch=BW/BWch;

Nchpcell=floor(Nch/N)*(slots/userslots);
Nchpcell
erlangcell=inverlangb(Nchpcell,pb);
erlangcell
subspcell=floor(erlangcell/erlanguser)

Ncells=ceil(subs/subspcell);
Ncells
totalsub=Ncells*subspcell
%radius of cell
areacell=areacity/Ncells;
R=sqrt((2/(3*sqrt(3)))*areacell)

%checking the power rules with respect to "R" and "N"
Prx=Ptx*Gtx*Grx*((3*10^(8))/(freq*(4*pi*R)^(2)));
Prx
end



%displaying N in the cellular form 
% M_max = 4; %// number of cells in vertical direction
% N_max = 5; %// number of cells in horizontal direction
% trans = 1;  %// hexagon orientation (0 or 1)
% 
% %// Do the plotting:
% hold on
% for m = -M_max:M_max
%     for n = -N_max:N_max
%         center = [.5 sqrt(3)/2] + m*[0 -sqrt(3)] + n*[3/2 sqrt(3)/2];
%         if ~trans
%             
%           
%             plot([center(1)-1 center(1)],[center(2) center(2)],'red')
%             
%             plot([center(1) center(1)+1/2],[center(2) center(2)+sqrt(3)/2],'red')
%           
%             plot([center(1) center(1)+1/2],[center(2) center(2)-sqrt(3)/2],'red')
%             
%         else
%             %// exchange the two arguments to `plot`
%            if (n==0 && m==0)||(n==-1 && m==0)
%             plot([center(2) center(2)],[center(1)-1 center(1)],'red')
%             plot([center(2) center(2)+sqrt(3)/2],[center(1) center(1)+1/2])
%             plot([center(2) center(2)-sqrt(3)/2],[center(1) center(1)+1/2],'red')
%            else 
%                if (n==0 && m==1)||(n==-1 && m==0)
%                     plot([center(2) center(2)],[center(1)-1 center(1)])
%             plot([center(2) center(2)+sqrt(3)/2],[center(1) center(1)+1/2],'red')
%             plot([center(2) center(2)-sqrt(3)/2],[center(1) center(1)+1/2]) 
%                else 
%                    
%                plot([center(2) center(2)],[center(1)-1 center(1)])
%             plot([center(2) center(2)+sqrt(3)/2],[center(1) center(1)+1/2])
%             plot([center(2) center(2)-sqrt(3)/2],[center(1) center(1)+1/2]) 
%                end
%            end
%             
%         end %if
%     end %for
% end %for
% 
% plot([-15 15],[0 0],'-.') %// adjust length manually
% plot([-15 15],[-15*sqrt(3) 15*sqrt(3)],'-.') %// adjust length manually
% axis image
% set(gca,'xtick',[])
% set(gca,'ytick',[])
% axis([-10 10 -13.3 13.3]) %// adjust axis size manually
% set(gca,'Visible','off') %// handy for printing the image

z=i-1;
x=j-1;
x
z
le=ceil(sqrt(Ncells));

    l=le;
    b=le;
    C=rand(l,b);
    xhex=[0 1 2 2 1 0]; % x-coordinates of the vertices
    yhex=[2 3 2 1 0 1]; % y-coordinates of the vertices
    pp=1;3
    for i=1:b
        j=i-1;
        for k=1:l
            m=k-1;
           if(pp<Ncells)
            patch((xhex+mod(k,2))+2*j,yhex+2*m,C(i,k)); % make a hexagon at [2i,2j]
%          pp
           else
             patch((xhex+mod(k,2))+2*j,yhex+2*m,'white');
             
           end
             
            hold on
            pp=pp+1;
        end
    end

    
    axis equal

