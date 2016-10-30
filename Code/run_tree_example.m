%% RP injection simulations
clear all
close all

%% Generate a tree representing the path of the channels from the injection point to all the extremities

rootNode = TreeNode(10e-3, 1e-3,0,5);
child_r_1 = rootNode.addChild( TreeNode(10e-3,0.85e-3, 0, 0) );
child_r_2 = rootNode.addChild( TreeNode(30e-3,0.3e-3, 1,1) );


child_1_1 = child_r_1.addChild (TreeNode(10e-3,1.0e-3,0,1));
child_1_2 = child_r_1.addChild (TreeNode(10e-3,1.2e-3,0,2));

for i=1:3

end

rootNode