classdef Type2NodePopulation < handle
    properties
        name % name of the strain
        quantity=65; 
        startingPositionX
        startingPositionY
        %xPx % x coordinate (center of mass)
        %yPx % y coordinate (center of mass)
%         distanceFromOrigin % distance from first data point
%         instantaneousSpeed 
%         instantaneousSpeedX % x coordinate of the instantaneous speed 
%         instantaneousSpeedY % y coordinate of the instantaneous speed 
%         speedAngle % angle of the instantaneous speed 
%         D=1e3; % timeScale % delay between 2 time points
%         diffusionCoefficient %Diffusion coefficient
%         displacementX
%         displacementY
        %diffuse
        %react
        colorMap 
%         tStep=1;
        %timePoints=100;
    end
    methods
        %% Constructor
        function obj = Type2NodePopulation()              
                   
        end
        
%         function obj = setStartingPosition(obj)
%             
%             for i=1:obj.quantity
%                 obj.startingPositionX(i)=-1000;
%                 obj.startingPositionY(i)=10*randn(1);
%                 
%             end
%             
%         end
    end
end