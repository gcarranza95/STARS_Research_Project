classdef TreeNode < handle
    %TREENODE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % Overall channel length in meters
        length = 0;
        
        % Channel diameter in meters
        diameter = 0;
        
        % The children segments
        children = {};
        
        % The average flow velocity
        vel = 0;
        
        % The volumetric flow rate
        Q = 0;
        
        % The flow resistance
        R = Inf;
        
        % The distance along the channel
        ell = 0;
        
        %Starting coordinate
        startCoor = [0,0,0];
        endCoor = [0,0,0];
    end
    
    methods
        function treeNodeObj = TreeNode (len, diam, startCoor, endCoor)
           treeNodeObj.length = len; 
           treeNodeObj.diameter = diam;
           treeNodeObj.startCoor = startCoor;
           treeNodeObj.endCoor = endCoor; 
        end
        
        function child = addChild (obj, child)
           obj.children{length(obj.children)+1} = child; 
        end
        
        function Q = computeQ (obj)
           obj.Q = pi*obj.diameter^2 * obj.vel / 4; 
           Q = obj.Q;
        end
        
        function R = computeR (obj, mu_poise)
           obj.R =(8*mu_poise*obj.length)/(pi*obj.diameter^2);
           R = obj.R;
        end
        
        function dP = computePressureDrop (obj, mu_dyn)
           dP = 32 * mu_dyn * obj.length * obj.vel / obj.diameter^2; 
        end
        
        function r = hasReachedEnd (obj)
           if obj.ell >= obj.length
               r = 1;
           else
               r = 0;
           end
        end
        
        function status = stepSimulation (obj, T)
        
            if obj.hasReachedEnd() 
            R(2) = (8*mu_poise*L(2))/(pi*D(2)^2);
            R(3) = (8*mu_poise*L(3))/(pi*D(3)^2);

            K = sqrt(R(3)/R(2));
            Q(2) = K/(1+K) * Q(1);
            Q(3) = 1/(1+K) * Q(1);

            v(2) = 4*Q(2)/(pi*D(2)^2);
            v(3) = 4*Q(3)/(pi*D(3)^2);
            L(2) = L(2) + v(2)*T;
            L(3) = L(3) + v(3)*T;
                      
            
        end
    end
    
    end
end


