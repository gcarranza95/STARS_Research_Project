function [ vias ] = getVias(xmlFile)
%GETVIAS Summary of this function goes here
%   Detailed explanation goes here

    viaFiles = xmlFile.getElementsByTagName('via');

for i=0:viaFiles.getLength-1
    viaItem= viaFiles.item(i);
    xVal= str2double(viaItem.getAttribute('x'));
    yVal= str2double(viaItem.getAttribute('y'));
    viaCoor = [xVal, yVal];
    vias(i+1).coor1 = viaCoor;
    vias(i+1).coor2 = viaCoor;
    %%By eliminating this I'll be just providing the via x and y coordinates 
    %{
    for j=1:size(pathStruct,2)
        pathCoor1 = pathStruct(j).coor1;
        pathCoor2 = pathStruct(j).coor2;
        viaCoor = viaCoor(1,1:2);
        
        if(sqrt(sum((pathCoor1(1,1:2)-viaCoor).^2))<0.005 || sqrt(sum((pathCoor2(1,1:2)-viaCoor).^2))<0.005)
            
            if(pathCoor1(1,3) == 10)
                vias(i+1).coor1(1,3) = pathCoor1(1,3);
                zRotAngle1= pathStruct(j).zRotAngle;
                vias(i+1).zRotAngle1 = zRotAngle1;
                
            end
            
            if(pathCoor1(1,3) == 20)
                vias(i+1).coor2(1,3) = pathCoor1(1,3);
                zRotAngle2 = pathStruct(j).zRotAngle;
                vias(i+1).zRotAngle2 = zRotAngle2;
            end
            
        end
        
    end
    
    vias(i+1).twist = abs(zRotAngle1-zRotAngle2);
    %}    
end

end

