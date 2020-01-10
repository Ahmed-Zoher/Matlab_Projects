function [ Vector , CounterofZeros,i,j] = Check(Number,Vector, i,j,CounterofZeros)


if (Number==0)
    CounterofZeros= CounterofZeros+1;
else
  %  CounterofZeros=CounterofZeros+1;
    Vector(i) = CounterofZeros;
    Vector(j) = Number;
    CounterofZeros = 0;
    i = i+2;
    j = j+2;
end
   end

