function [ corners ] = getCorners( pathStruct, viaStruct, elementStruct )
%GETTURNPOINTS Summary of this function goes here
%   Detailed explanation goes here


cNum=1;

%Horizontal Corners 
for i=2:size(pathStruct,2)
    
    corners(cNum).rot = [0,0,0];
    prevCoor2 = pathStruct(i-1).coor2;
    
    currentCoor1 = pathStruct(i).coor1;
        if (sqrt(sum((prevCoor2-currentCoor1).^2))<0.005)
        corners(cNum).coor = prevCoor2; %currentCoor1 is also valid
        cNum=cNum+1;
        
    end
    
end

%Via Corners 
try 
for j=1:size(viaStruct,2)
 corners(cNum).coor = viaStruct(j).coor1;
 corners(cNum).rot =  [90,0,viaStruct(j).zRotAngle1+90];
 cNum = cNum+1;
 corners(cNum).coor = viaStruct(j).coor2;
 corners(cNum).rot = [90,0,viaStruct(j).zRotAngle2+90];   
cNum = cNum+1;
end
end

%Pad Corners
for k=1:size(elementStruct,2)
    pads = elementStruct(k).pads;
    for m=1:size(pads,2)
    padCoor = pads(m).coor;
    padAngle = pads(m).zRotAngle;
    
    corners(cNum).coor = padCoor;
    
    
    corners(cNum).rot = [90,0,padAngle+90];
    
    cNum=cNum+1;
    
    end
        
     

end

