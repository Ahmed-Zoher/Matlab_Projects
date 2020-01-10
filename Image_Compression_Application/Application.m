clc
clear all
close all
%------------------------------------------------------------------------%
%Image Read:-

% Barbara=imread('barbara.pgm');
% BarbaraShow=imshow('barbara.pgm');

% Boat=imread('boat.pgm');
% BoatShow=imshow('boat.pgm');

% Clown=imread('clown.pgm');
% ClownShow=imshow('clown.pgm');
 
% Houses=imread('houses.pgm');
% HousesShow=imshow('houses.pgm');
 
% Kiel=imread('kiel.pgm');
% KielShow=imshow('kiel.pgm');
 
Lena=imread('lena.pgm','pgm');
figure(1)

LenaShow=imshow('lena.pgm');
title('un-compressed image')
%------------------------------------------------------------------------%
%Segmentation:-

SegmentedLena=reshape(Lena, 8, 8, 4096);

%------------------------------------------------------------------------%
%Level Shifting:-

DoubleLena=double(SegmentedLena);
LevelShiftedLena=DoubleLena-128;

%------------------------------------------------------------------------%
% Applying DCT:-

i=1:1:7;
j=0:1:7;
j1=2*j +1; 

DctMatrix=repmat([ones(1,8)*1/sqrt(8) ; 1/4*cos((pi/16)*(repmat(i,8,1)'.*repmat(j1,7,1)))],[1,1,4096]);

TransformedData = [];
for k = 1:1:4096
    TransformedData(:,:,k) = (DctMatrix(:,:,k))*(LevelShiftedLena(:,:,k))*(transpose(DctMatrix(:,:,k))); 
end
%------------------------------------------------------------------------%
% Quantization:-

Quantized = round(TransformedData/8);                                       % Change 8?
%------------------------------------------------------------------------%
%Dc Codebook:-

DcDiff3D(1,1,1)=Quantized(1,1,1);
DcDiff3D(1,1,2:1:4096)=Quantized(1,1,2:1:end)-Quantized(1,1,1:1:end-1);
DcDiff(1:1:4096,1)=DcDiff3D(1,1,1:1:4096);

Codes=cell(4096,1);

Codes(find(DcDiff==0))={[0,0]};
Codes(find(abs(DcDiff)==1))={[0,1,0]};
Codes(find(2<=abs(DcDiff) & abs(DcDiff)<=3))={[0,1,1]};
Codes(find(4<=abs(DcDiff) & abs(DcDiff)<=7))={[1,0,0]};
Codes(find(8<=abs(DcDiff) & abs(DcDiff)<=15))={[1,0,1]};
Codes(find(16<=abs(DcDiff) & abs(DcDiff)<=31))={[1,1,0]};
Codes(find(32<=abs(DcDiff) & abs(DcDiff)<=63))={[1,1,1,0]};
Codes(find(64<=abs(DcDiff) & abs(DcDiff)<=127))={[1,1,1,1,0]};
Codes(find(128<=abs(DcDiff) & abs(DcDiff)<=255))={[1,1,1,1,1,0]};
Codes(find(256<=abs(DcDiff) & abs(DcDiff)<=511))={[1,1,1,1,1,1,0]};
Codes(find(512<=abs(DcDiff) & abs(DcDiff)<=1023))={[1,1,1,1,1,1,1,0]};
Codes(find(1024<=abs(DcDiff) & abs(DcDiff)<=2047))={[1,1,1,1,1,1,1,1,0]};

for i=1:1:4096
    if DcDiff(i)==0
        Codes{i,2}={};
    else
    if DcDiff(i) > -1
        Codes(i,2)={flip(de2bi(DcDiff(i)))};
    else
        Codes(i,2)={xor(flip(de2bi(abs(DcDiff(i)))),ones(1,length(de2bi(abs(DcDiff(i))))))};
    end
    end
    Codes{i,3}=cat(2,Codes{i,1},Codes{i,2});
end


%------------------------------------------------------------------------%
%Ac Codebook:-

ac_huffman={
    '00'               '01'               '100'              '1011'             '11010'            '1111000'          '11111000'         '1111110110'       '1111111110000010' '1111111110000011';...
    '1100'             '11011'            '1111001'          '111110110'        '11111110110'      '1111111110000100' '1111111110000101' '1111111110000110' '1111111110000111' '11111111100001000';...
    '11100'            '11111001'         '1111110111'       '111111110100'     '1111111110001001' '1111111110001010' '1111111110001011' '1111111110001100' '1111111110001101' '1111111110001110';...
    '111010'           '111110111'        '111111110101'     '1111111110001111' '1111111110010000' '1111111110010001' '1111111110010010' '1111111110010011' '1111111110010100' '1111111110010101';...
    '111011'           '1111111000'       '1111111110010110' '1111111110010111' '1111111110011000' '1111111110011001' '1111111110011010' '1111111110011011' '1111111110011100' '1111111110011101';...
    '1111010'          '11111110111'      '1111111110011110' '1111111110011111' '1111111110100000' '1111111110100001' '1111111110100010' '1111111110100011' '1111111110100100' '1111111110100101';...
    '1111011'          '111111110110'     '1111111110100110' '1111111110100111' '1111111110101000' '1111111110101001' '1111111110101010' '1111111110101011' '1111111110101100' '1111111110101101';...
    '11111010'         '111111110111'     '1111111110101110' '1111111110101111' '1111111110110000' '1111111110110001' '1111111110110010' '1111111110110011' '1111111110110100' '1111111110110101';...
    '111111000'        '111111111000000'  '1111111110110110' '1111111110110111' '1111111110111000' '1111111110111001' '1111111110111010' '1111111110111011' '1111111110111100' '1111111110111101';...
    '111111001'        '1111111110111110' '1111111110111111' '1111111111000000' '1111111111000001' '1111111111000010' '1111111111000011' '1111111111000100' '1111111111000101' '1111111111000110';...
    '111111010'        '1111111111000111' '1111111111001000' '1111111111001001' '1111111111001010' '1111111111001011' '1111111111001100' '1111111111001101' '1111111111001110' '1111111111001111';...
    '1111111001'       '1111111111010000' '1111111111010001' '1111111111010010' '1111111111010011' '1111111111010100' '1111111111010101' '1111111111010110' '1111111111010111' '1111111111011000';...
    '1111111010'       '1111111111011001' '1111111111011010' '1111111111011011' '1111111111011100' '1111111111011101' '1111111111011110' '1111111111011111' '1111111111100000' '1111111111100001';...
    '11111111000'      '1111111111100010' '1111111111100011' '1111111111100100' '1111111111100101' '1111111111100110' '1111111111100111' '1111111111101000' '1111111111101001' '1111111111101010';...
    '1111111111101011' '1111111111101100' '1111111111101101' '1111111111101110' '1111111111101111' '1111111111110000' '1111111111110001' '1111111111110010' '1111111111110011' '1111111111110100';...
    '1111111111110101' '1111111111110110' '1111111111110111' '1111111111111000' '1111111111111001' '1111111111111010' '1111111111111011' '1111111111111100' '1111111111111101' '1111111111111110'
    };

zigzagRoute=[];

for i=1:1:4096
    zigzagRoute=ZigZag(Quantized(:,:,i));
    indeces=find(zigzagRoute~=0);
    
    if length(indeces)>0
        
        trancated=zigzagRoute(1:1:indeces(length(indeces)));
        
        reshaped=[trancated(1:2:end); zeros(1,length(trancated)/2) ; trancated(2:2:end)];
        reshaped(2,:)=ceil(log2(abs(reshaped(3,:))));
        reshaped(2,find(abs(reshaped(3,:))==0))=0;
        reshaped(2,find(abs(reshaped(3,:))==1))=1;
        
        Ac_code=[];
        for j=1:1:size(reshaped,2)
            if reshaped(1,j)>15
               reshaped(1,j)=15;
            end
            Ac_code=[Ac_code ac_huffman{reshaped(1,j)+1,reshaped(2,j)}];
            
            if reshaped(3,j) > -1
                temp= num2str(flip(de2bi(reshaped(3,j))));
                temp=temp(find(~isspace(temp)));
                temp2= strcat(',',temp);
                Ac_code =[Ac_code strcat(temp2,',')];
            else
                temp= num2str(xor(flip(de2bi(abs(reshaped(3,j)))),ones(1,length(de2bi(abs(reshaped(3,j)))))));
                temp=temp(find(~isspace(temp)));
                temp2= strcat(',',temp);
                Ac_code =[Ac_code strcat(temp2,',')];
            end
        end
        Ac_code=[Ac_code '1010'];
        Codes{i,4}=Ac_code;
    else
        trancated=[];
        
    end
end

%------------------------------------------------------------------------%
%Decoding:

Decoder_Dc =zeros(4096,4);

%------------------------------------------------------------------------%
%Decoding the category:


Codes_size = cellfun('length',Codes);

tempS=2;
Dc_content=zeros(4096,tempS);
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==0 & Dc_content(:,2)==0),1)=0;

tempS=3;
Dc_content=zeros(4096,tempS);
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==0 & Dc_content(:,2)==1 & Dc_content(:,3)==0),1)=1;
Decoder_Dc(find(Dc_content(:,1)==0 & Dc_content(:,2)==1 & Dc_content(:,3)==1),1)=2;
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==0 & Dc_content(:,3)==0),1)=3;
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==0 & Dc_content(:,3)==1),1)=4;
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==0),1)=5;

tempS=4;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==0),1)=6;
end

tempS=5;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==1 & Dc_content(:,5)==0),1)=7;
end

tempS=6;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==1 & Dc_content(:,5)==1 & Dc_content(:,6)==0),1)=8;
end

tempS=7;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==1 & Dc_content(:,5)==1 & Dc_content(:,6)==1 & Dc_content(:,7)==0),1)=9;
end

tempS=8;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==1 & Dc_content(:,5)==1 & Dc_content(:,6)==1 & Dc_content(:,7)==1 & Dc_content(:,8)==0),1)=10;
end

tempS=9;
Dc_content=zeros(4096,tempS);
if isempty(find(Codes_size(:,1)==tempS))==false
Dc_content(find(Codes_size(:,1)==tempS),:)=cell2mat(Codes(find(Codes_size(:,1)==tempS),1));
Decoder_Dc(find(Dc_content(:,1)==1 & Dc_content(:,2)==1 & Dc_content(:,3)==1 & Dc_content(:,4)==1 & Dc_content(:,5)==1 & Dc_content(:,6)==1 & Dc_content(:,7)==1 & Dc_content(:,8)==1 & Dc_content(:,9)==0),1)=11;
end

%------------------------------------------------------------------------%
%Decoding the Dc diff:

for i=1:1:4096
    binary=Codes{i,2};
    
    if length(Codes{i,2})==0
       Decoder_Dc(i,2)=0;  
    else
    if(binary(1)==1)
       Decoder_Dc(i,2)=bi2de(flip(Codes{i,2}));
    else
       Decoder_Dc(i,2)=-bi2de(flip(xor(Codes{i,2},ones(1,length(Codes{i,2})))));
    end
    end
end

%------------------------------------------------------------------------%
%Decoding Ac:
huffman_pos=reshape(1:1:160,16,10);
Train=zeros(8,8,4096);
for i=1:1:4096
    matrix_out=[];
    tempo=Codes(i,4);
    if isequal(tempo,{[]})==false
       tempstr=strsplit(cell2mat(Codes(i,4)),',');
%      tempstr1=zeros(1,length(tempstr));
        tt=1;
        Ac_part={};
        Dc_part={};
    for jj=1:2:length(tempstr)-1
        Ac_part{tt}=cell2mat(tempstr(jj));
        Dc_part{tt}=cell2mat(tempstr(jj+1));
        tt=tt+1;
    end

    
    Ac_revert=[];
    for j=1:1:length(Ac_part)
        current_Ac=cell2mat(Ac_part(j));
        [row,column]=find(ismember(ac_huffman,current_Ac));
        pos=[row-1;column];
        Ac_revert=[Ac_revert pos];
    end
    
    Dc_revert=[];
    for j=1:1:length(Dc_part)
        current_Dc=cell2mat(Dc_part(j));
        binary_num=current_Dc-'0';
     if(binary_num(1)==1)
        Dc_revert(j)=bi2de(flip(binary_num));
     else
       Dc_revert(j)=-bi2de(flip(xor(binary_num,ones(1,length(binary_num)))));
     end
    end
    matrix_out=[Ac_revert;Dc_revert];
    zigzag_input=zeros(1,2*size(matrix_out,2));
    zigzag_input(1:2:end)=matrix_out(1,:);
    zigzag_input(2:2:end)=matrix_out(3,:);
    matrix_before_zigzag = [0];
    for pp=1:2:length(zigzag_input)
    matrix_before_zigzag=[matrix_before_zigzag zeros(1,zigzag_input(pp)) zigzag_input(pp+1)] ;   
    end
    add_trancated=zeros(1,64-length(matrix_before_zigzag));
    not_trancated=[matrix_before_zigzag add_trancated];
    Train(:,:,i)=inv_zigzag(not_trancated);
    else
        
    end
end
 Train(1,1,1)=Decoder_Dc(1,2);
for i=2:1:4096
    Train(1,1,i)=Train(1,1,i-1)+Decoder_Dc(i,2);
end

de_Quantized=Train*8;



for k = 1:1:4096
    inv_DctMatrix=DctMatrix(:,:,k)^(-1);
    de_TransformedData(:,:,k) = (inv_DctMatrix)*(de_Quantized(:,:,k))*(transpose(inv_DctMatrix)); 
end

data_out=de_TransformedData+128;

SegmentedLena_out=uint8(reshape(data_out, 512, 512));

figure(2)

imshow(SegmentedLena_out);
title('compressed image')