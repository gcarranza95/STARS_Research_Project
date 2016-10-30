function [ paths ] = getPaths( xmlFile, bottomLayerHeight, topLayerHeight, elementStruct, viaStruct)
%GETPATHS returns a tree structure for paths which describe how the paths
%travel and branch out when starting at one pad and ending at one or more
%pads
%   getPaths begins by assigning the following path properties: layer,
%   startCoor, endCoor, pathLength, and directionMatrix. This collection of
%   paths is then reorganized using the element and via structures.

%Tag format from xml file
topLayerTag = '1';
bottomLayerTag = '16';

signalList = xmlFile.getElementsByTagName('signal');

%Initialize wire number for top and bottom layers
wireNum=1;
%Assigns pathStruct properties: layer, startCoor & endCoor [x,y,z], pathLength, 
%                               & directionMatrix.
for i=0:signalList.getLength-1
    
    signalItem = signalList.item(i);
    pathWireList = signalItem.getElementsByTagName('wire');
    
    for j=0:pathWireList.getLength-1
        
        %XML File outputs the wire paths in reverse order. Defining h
        %facilitates the order. Using h, the end of one wire(coor2) is the
        %beginning of the next wire (coor1), unless the pin is reached, in
        %which case a new wire path begins.
        h= pathWireList.getLength-1-j;
        
        wireItem = pathWireList.item(h); %Initialize wire item a.k.a path
        
        %Layer Attribute
        layerAttr=wireItem.getAttribute('layer');
        
        %Conditionals to assign layer height for path
        if(strcmp(layerAttr,bottomLayerTag))
            layerHeight = bottomLayerHeight;
            pathStruct(wireNum).layer = 'bottom';
        end
        
        if(strcmp(layerAttr,topLayerTag))
            layerHeight = topLayerHeight;
            pathStruct(wireNum).layer= 'top';
        end
        
        %Assigns start Coor and end Coor for line segments
        startCoor =  [ str2double(wireItem.getAttribute('x1')), str2double(wireItem.getAttribute('y1')), layerHeight];
        pathStruct(wireNum).startCoor = startCoor;
        endCoor = [ str2double(wireItem.getAttribute('x2')), str2double(wireItem.getAttribute('y2')), layerHeight];
        pathStruct(wireNum).endCoor = endCoor;
        
        %Path Length, to be used in getDirectionMatrix function
        pathLength = sqrt(sum((startCoor-endCoor).^2));
        pathStruct(wireNum).pathLength = pathLength;
        
        %Direction Matrix that provides necessary angle rotations to
        %extrude along desired path
        pathStruct(wireNum).directionMatrix = getDirectionMatrix(startCoor,endCoor, pathLength);
        
        
        wireNum=wireNum+1;
        
    end
    
    
end

%Reorginization of path structure


%Make a matrix of only pad coordinates(padMatrix). padMatrix consists of
%the x,y,&z coordinates for all pads.
padNum = 1;
for k = 1:size(elementStruct,2)
    padList = elementStruct(k).pads;
    for  m = 1:size(padList,2)
        padMatrix(padNum,1:3) = padList(m).coor;
        padNum= padNum + 1;
    end
end

%Create connection matrix for pads. Purpose of connection matrix is to note
%which pads have two connections and should not be considered to be a
%parent of a tree
connectionMatrix = zeros(size(padMatrix,1),1);
for n = 1:size(padMatrix,1)
    padCoor = padMatrix(n,1:2);
    for p = 1:size(pathStruct,2)
        pathStartCoor = pathStruct(p).startCoor(1,1:2);
        if(sqrt(sum((padCoor-pathStartCoor).^2)) < 0.005)
            connectionMatrix(n,1)  = connectionMatrix(n,1)+1;
        end
        pathEndCoor = pathStruct(p).endCoor(1,1:2);
        if(sqrt(sum((padCoor-pathEndCoor).^2)) < 0.005)
            connectionMatrix(n,1)  = connectionMatrix(n,1)+1;
        end
    end
end

%Get Path Tree
rootNum=1;
for r=1:size(padMatrix,1)
    padCoor = padMatrix(r,1:2);
    if(connectionMatrix(r,1)==1)
        %padCoor
        for s=1:size(pathStruct,2)
            pathStartCoor = pathStruct(s).startCoor(1,1:2);
            pathEndCoor = pathStruct(s).endCoor(1,1:2);
            if(sqrt(sum((padCoor-pathStartCoor).^2)) < 0.005)
                paths(rootNum).rootPath = TreeNode(pathStruct(s).pathLength,.8, pathStartCoor, pathEndCoor);
                [paths(rootNum).rootPath, connectionMatrix] = getChildren(paths(rootNum).rootPath, pathStruct, padMatrix, connectionMatrix);
                rootNum= rootNum +1;
            end
            if(sqrt(sum((padCoor-pathEndCoor).^2)) < 0.005)
                paths(rootNum).rootPath= TreeNode(pathStruct(s).pathLength,.8, pathEndCoor, pathStartCoor);
                [paths(rootNum).rootPath, connectionMatrix] = getChildren(paths(rootNum).rootPath, pathStruct, padMatrix, connectionMatrix);
                %rootNum
                %connectionMatrix
                rootNum = rootNum +1;
                
            end
            %rootNum
        end
    end
    %connectionMatrix
end

%paths = pathStruct;
end

