
function[V] = ZigZag(M)

row = 1;
column = 2;
flag = 1;
i = 1;
j=2;
CounterofZeros=0;
x = 1;
V = zeros(1,64);

    while(flag==1)
        if(column==1)
            row = row+1;
            [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);

            while(row~=1)
                row = row-1;
                column = column+1;
                [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            end
        end
            row = 1;
            if(row==1 && column~=2)
            column = column+1;
            end
            [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            while(column~=1)
                column = column-1;
                row = row+1;
                [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            end
            column=1;
            if(row==8)
                flag = 0;
            end
    end
    row = 8;
    column = 1;
    while(x==1)
        
      if(row==8)
            column = column+1;
            [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);

            while(column~=8)
                row = row-1;
                column = column+1;
                [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            end
      end
            column = 8;
            row = row+1;
            if(row==9 && column==8)
                x = 0;
                continue;
            end
            [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            while(row~=8)
                column = column-1;
                row = row+1;
                [V,CounterofZeros,i,j]=Check(M(row,column),V,i,j,CounterofZeros);
            end
            row=8;
            
    end
%      V=reshape(V,2,32);
%  % Category
%  [ V1 ] = Category(V)
%  % Representation for Ac levels in V in binary
%  [ V2 ] = representation( V,V1 )   
%  
end