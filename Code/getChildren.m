function [ pathTree, connectionMatrix ] = getChildren(rootPath, pathStruct,padMatrix, connectionMatrix)
%GETPATHTREE
%   Returns pathTree for a chosen rootPath, along with the edited padMatrix
%   that takes into account any paths that ended with another potential
%   rootPath (connectivity equal to 1). This will alow getPaths to not
%   iterate over a pad that already served as the end for a rootPath.
%editedConnectionMatrix = connectionMatrix;
%rootPath.endCoor
for i=1:size(pathStruct,2)
    pathStartCoor = pathStruct(i).startCoor(1,1:2);
    pathEndCoor = pathStruct(i).endCoor(1,1:2);
    %Compares end coordinate of rootPath to pad coordinates with
    %connection number of 1.
    for j=1:size(padMatrix,1)
        padCoor = padMatrix(j,1:2);
        if(connectionMatrix(j,1)==1)
            if(sqrt(sum((rootPath.endCoor - padCoor).^2)) < 0.005)
                %disp([rootPath.endCoor, padCoor])
                connectionMatrix(j,1) = 0; %Sets connection numer to 0 to signify it's the end of a root path
            end
        end
    end
    %{
    disp('rootPath')
    disp([rootPath.startCoor, rootPath.endCoor])
    disp('path')
    disp([pathStartCoor, pathEndCoor])
    sqrt(sum((rootPath.endCoor-pathStartCoor).^2)
    %}
    if(sqrt(sum((rootPath.endCoor-pathStartCoor).^2)) < 0.005 && sqrt(sum(rootPath.startCoor-pathEndCoor).^2)>.005)
        childPath = rootPath.addChild(TreeNode(pathStruct(i).pathLength,.8, pathStartCoor, pathEndCoor));
        [childPath, connectionMatrix] = getChildren(childPath, pathStruct, padMatrix, connectionMatrix);
    end
    if(sqrt(sum((rootPath.endCoor-pathEndCoor).^2)) < 0.005 && sqrt(sum(rootPath.startCoor-pathStartCoor))>.005)
        childPath = rootPath.addChild(TreeNode(pathStruct(i).pathLength,.8, pathEndCoor, pathStartCoor));
        [childPath, connectionMatrix] = getChildren(childPath, pathStruct, padMatrix, connectionMatrix);
    end
end

pathTree = rootPath;
end

