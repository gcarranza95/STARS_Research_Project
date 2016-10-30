
function [b, retval] = generateBoard(filename)

%filename = '555Timer.brd'; %Use for debugging
in_file = filename;
scad_file = [filename(1:end-3) 'scad'];
stl_file = [filename(1:end-3) 'stl'];

b= parseBrdFile(in_file);

fid = fopen(scad_file,'w');

fprintf(fid,'difference() \n{ \n');
fprintf(fid,'cube([%.3f,%.3f,%.3f], center = false); \n', b.brdWidth, b.brdLength,b.brdHeight);
sqrholeSize=b.holeSize;

% Path Extrusions
%These include vias, horizontal, and vertical path extrusions
for i=1:size(b.paths,2)
    rootPath = b.paths(i).rootPath; 
    something = printPaths(rootPath);
    

end

%{
for i=1:size(b.paths,2)
    b.paths
    x1Val = b.paths(i).startCoor(1,1);
    y1Val = b. paths(i).startCoor(1,2);
    z1Val = b.paths(i).startCoor(1,3);
    
    rotX =b.paths(i).directionMatrix(1,1);
    rotY =b.paths(i).directionMatrix(1,2);
    rotZ =b.paths(i).directionMatrix(1,3);
    pathLength = b.paths(i).pathLength;
    fprintf(fid,' translate([%.3f,%.3f,%.3f]) rotate([%.1f,%.1f,%.1f]) \n',x1Val,y1Val,z1Val,rotX,rotY,rotZ);
    fprintf(fid,' linear_extrude(height = %.3f, center = false) \n',pathLength);
    fprintf(fid,' rotate([%d,%d,%d]) square(size = %.3f, center = true); \n',0,0,45,sqrholeSize);
end
%}
% Vertical Hole Extrusions
%{
for j=1:size(b.elements, 2)
    
    for k=1:size(b.elements(j).pads,2)
        
        pad = b.elements(j).pads(k).coor;
        padXVal = pad(1,1);
        padYVal = pad(1,2);
        padZVal = pad(1,3);
        zRotAngle = b.elements(j).pads(k).zRotAngle;
        fprintf(fid,' translate([%.3f,%.3f,%.3f]) rotate([%d,%d,%.1f]) \n',padXVal,padYVal,padZVal,0,0,zRotAngle);
        fprintf(fid,' linear_extrude(height = %.3f, center = false) \n',b.brdHeight-padZVal);
        fprintf(fid,' rotate([%d,%d,%d]) square(size = %.3f, center = true); \n',0,0,45,sqrholeSize);
        
    end
end
%}


%Corners / Rotate Extrude
%{
for m=1:size(b.corners,2)
cornerCoor = b.corners(m).coor;
cornerCoorXVal = cornerCoor(1,1);
cornerCoorYVal = cornerCoor(1,2);
cornerCoorZVal = cornerCoor(1,3);
rotXVal = b.corners(m).rot(1,1);
rotYVal = b.corners(m).rot(1,2);
rotZVal = b.corners(m).rot(1,3);
holeR = b.holeSize*sqrt(2)/2;
fprintf(fid,' translate([%.3f,%.3f,%.3f]) rotate([%.1f,%.1f,%.1f]) \n',cornerCoorXVal,cornerCoorYVal,cornerCoorZVal,rotXVal,rotYVal,rotZVal);
fprintf(fid,' rotate_extrude(convexity= %d, $fn = %d) \n',10,8);
fprintf(fid,' polygon( points = [[%.3f,%.3f],[%.3f,%.3f],[%.3f,%.3f]]); \n',-holeR,0,0,holeR,0,-holeR);

end
%}

%Vias
try
    for n=1:size(b.vias,2)
        viaCoor = b.vias(n).coor1;
        viaXVal= viaCoor(1,1);
        viaYVal=viaCoor(1,2);
        viaTwist= b.vias(n).twist;
        viaZVal1 = b.vias(n).coor1(1,3);
        viaZVal2 = b.vias(n).coor2(1,3);
        zRotAngle = b.vias(n).zRotAngle1;
        fprintf(fid,' translate([%.3f,%.3f,%.3f]) rotate([%d,%d,%.1f]) \n',viaXVal,viaYVal,viaZVal1,0,0,zRotAngle);
        fprintf(fid,' linear_extrude(height = %.3f, center = false, twist = %.1f) \n',viaZVal2-viaZVal1,viaTwist);
        fprintf(fid,' rotate([%d,%d,%d]) square(size = %.3f, center = true); \n',0,0,45,sqrholeSize);
        
        
    end
catch
end

fprintf(fid,'} \n');

fclose(fid);

fileLocation = 'C:\Program Files (x86)\OpenSCAD\OpenSCAD';
cmd = sprintf('"%s" -o "%s" "%s"',fileLocation,stl_file,scad_file);
retval = system(cmd);


end
