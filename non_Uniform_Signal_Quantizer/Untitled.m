clc 
clear all 
close all 

variable=0.1:0.1:1000;
x=wblpdf(variable,0.5,0.9)

index=find(variable<1);
Average=sum(variable(index).*(x(index)/sum(x(index))));