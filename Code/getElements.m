function [ elements ] = getElements( xmlFile, brdHeight )
%GETELEMENTS Return Element Properties: name, centerCoor, rot, and pads 
%   Acquires element properties from xml file. In conjunction with getPads,
%   get Elements also returns the pad locations with respect to the board.
%   getPads only provides pad locations with respect to the center
%   coordinate of the element

elementList = xmlFile.getElementsByTagName('element');
elements(elementList.getLength).name= '';
elementAngles(elementList.getLength).rot= '';
elements(elementList.getLength).package= '';


%Get Element Properties
for i = 0:elementList.getLength-1
    elementItem = elementList.item(i);
    
    elements(i+1).name = char(elementItem.getAttribute('name'));
    elements(i+1).centerCoor = [ str2double(elementItem.getAttribute('x')), str2double(elementItem.getAttribute('y'))];
    rotchar = char(elementItem.getAttribute('rot'));
    rotchar = rotchar(2:length(rotchar));
    elementAngles(i+1).rot = str2double(rotchar);
    elements(i+1).package = char(elementItem.getAttribute('package'));
    
end

padfiles = getPads(xmlFile);

%Uses getPads to provide pad x and y locations with respect to the board
for j=1:size(elements,2)
    padNum=1; %Reinitialize padNum for each element
    for k=1:size(padfiles,2)
        
        if(strcmp(elements(j).package,padfiles(k).package))
            totalRotAngle = elementAngles(j).rot;
            %padfiles(k).rot +
            rotMatrix = [cosd(totalRotAngle) -sind(totalRotAngle); sind(totalRotAngle) cosd(totalRotAngle) ]; 
            relativePadCoor= (rotMatrix*padfiles(k).Coor')'; %Return pad coordinates when rotated with respect to center coordinate of element
            padCoor = elements(j).centerCoor + relativePadCoor; % Place pad with respect to board
            elements(j).pads(padNum).coor = [padCoor, brdHeight];
            padNum = padNum+1;
        end
        
        
    end
    
end


%Acquire pad zRotAngle and padZVal 
%{
numOfConnections = 0;
for m=1:size(elements,2)
    
    elementPad=elements(m).pads;
    
    for n=1:size(elementPad,2)
        elementPadCoor=elementPad(n).coor;
        elements(m).pads(n).coor(1,3) = 0;
        numOfConnections = 0;
        for k=1:size(pathStruct,2)
            
            pathCoor1 = pathStruct(k).coor1;
            pathCoor1 = pathCoor1(1,1:2);
            pathCoor2 = pathStruct(k).coor2;
            pathCoor2 = pathCoor2(1,1:2);
            
            
            if(sqrt(sum((elementPadCoor-pathCoor1).^2))<0.005 || sqrt(sum((elementPadCoor-pathCoor2).^2))<0.005)
                
                if(elements(m).pads(n).coor(1,3) ~= 10 )
                    
                    elements(m).pads(n).coor(1,3) = pathStruct(k).coor1(1,3);
                    
                end
                
                numOfConnections = numOfConnections + 1;
                
                if(numOfConnections == 1)
                    corner1Angle = pathStruct(k).zRotAngle;
                    elements(m).pads(n).zRotAngle = corner1Angle;
                end
                
                if(numOfConnections == 2)
                    corner2Angle = pathStruct(k).zRotAngle;
                    
                    if(abs(corner1Angle-corner2Angle) == 90)
                        elements(m).pads(n).zRotAngle = mod(corner1Angle,90);
                    else
                        elements(m).pads(n).zRotAngle = mod(abs(corner1Angle+corner2Angle)/2,90);
                    end
                    
                end
                
            end
             
        end
        
    end
    
    
end
%}
end





