function [ parsedBrd ] = parseBrdFile( brdFile )
%GENERATEBRD Summary of this function goes here
%   Detailed explanation goes here

brdFile = '555Timer.brd';
xmlFile = xmlread(brdFile);

%FIELD - Board Dimensions

%Extracts dimension from xmlFile
DimList = xmlFile.getElementsByTagName('plain');
DimItem = DimList.item(0);
DimWireList = DimItem.getElementsByTagName('wire');
DimWireItem = DimWireList.item(1);

%Assigns dimension fields
parsedBrd.brdWidth = str2double(DimWireItem.getAttribute('x1'));
parsedBrd.brdLength = str2double(DimWireItem.getAttribute('y2'));
parsedBrd.brdHeight = 30;
parsedBrd.topLayerHeight = 20;
parsedBrd.bottomLayerHeight = 10;

%FIELD - Holes/Shape of Holes
parsedBrd.holeSize = 0.8;
parsedBrd.shape = 'square';

%FIELD- Elements
%Element fields include: name, package, centerCoor, pads (pads includes
%coor and zRotAngle fields)
%parsedBrd.paths used to acquire zRotAngle from pads
parsedBrd.elements = getElements(xmlFile, parsedBrd.brdHeight);

%FIELD - Vias
%the try catch is implemented in case there exists a board file with no
%vias.  
try
parsedBrd.vias = getVias(xmlFile);
catch
    parsedBrd.vias = 'No vias';
end


%FIELD- Paths; fields include: layer,Coor1,Coor2,zRotAngle, and pathLength
%getPaths uses Elements field and Via field to lay out an organized form of 
% the paths starting from one pad and ending at another for all the pads. 

parsedBrd.paths = getPaths(xmlFile, parsedBrd.bottomLayerHeight, parsedBrd.topLayerHeight, parsedBrd.elements, parsedBrd.vias);


%FIELD - Corners 
%parsedBrd.corners = getCorners(parsedBrd.paths, parsedBrd.vias, parsedBrd.elements);


end






