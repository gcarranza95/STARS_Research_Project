function [ padfiles ] = getPads(xmlFile)
%GETPADS Returns Pad Properties: Name, Package, relative coordinate
%   getPads returns values that are to be used in the getElements function
%   getElements uses the information it collects to place the pad
%   coordinates appropriately with respect to the whole board
packageList = xmlFile.getElementsByTagName('package');  

pNum=1;

for i=0:packageList.getLength-1
    packageItem = packageList.item(i);
    padList = packageItem.getElementsByTagName('pad');
    for j=0:padList.getLength-1
    padItem= padList.item(j);
    
    %Nominal Pad values 
    padfiles(pNum).name = char(padItem.getAttribute('name'));
    padfiles(pNum).package = char(packageItem.getAttribute('name')); 
        
    %Pad Coordinate, relative to center coordinate of element
    padfiles(pNum).Coor = [str2double(padItem.getAttribute('x')), str2double(padItem.getAttribute('y'))];
    
    %rotchar = char(padItem.getAttribute('rot'));
    %rotchar = rotchar(2:length(rotchar));
    %padfiles(pNum).rot = str2double(rotchar);
    
    pNum=pNum+1;
    end
    
end


