function [ directionMatrix ] = getDirectionMatrix(Coor1, Coor2, pathLength)
%GETZROTANGLE Summary of this function goes here
%   Detailed explanation goes here
x1Val = Coor1(1,1); y1Val= Coor1(1,2); z1Val = Coor1(1,3);
x2Val= Coor2(1,1); y2Val = Coor2(1,2); z2Val = Coor2(1,3);

directionMatrix = zeros(1,3);
XYProjectedMagnitude = sqrt((y2Val-y1Val)^2 + (x2Val-x1Val)^2);

%Rotation about x 
%If the rotation about x component is fixed at zero, y and z rotations can 
%treated as components of a spherical coordinate system
directionMatrix(1,1) = 0;
%{
if(ZYProjectedMagnitude ~= 0)
    theta = acosd((y2Val-y1Val)/ZYProjectedMagnitude);
    if(z2Val>=z1Val)
    directionMatrix(1,1) = theta - 90;
    else
    directionMatrix(1,1) = 270-theta;    
    end
    
else
    directionMatrix(1,1)=0;
end
%}

%Rotation about y / Polar angle Theta

    theta = acosd((z2Val-z1Val)/pathLength);
    directionMatrix(1,2) = theta;
    

%Rotation about y / Azimuthal Angle Phi
    phi = atand((y2Val-y1Val)/(x2Val-x1Val));
    if(x2Val>=x1Val)
    directionMatrix(1,3) = phi;
    else
    directionMatrix(1,3) = 180+phi;    
    end
    



end



