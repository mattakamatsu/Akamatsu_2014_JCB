classdef TypeInode < handle
    properties
        name
        xPosition; % 
        yPosition; % 
        breadth=800; %standard deviation of the breadth of the broad band of nodes, in nm
        center=0.43; %position of center of broad band of nodes (relative to cell length)        
        D=15; % 
        displacementX
        displacementY
        reactedWith =0;
        colorMap 
        %tStep=1; set to same as for Type II node if diffusing
        captureRadius=50;
    end
    methods
     %% Constructor
        function obj = TypeInode()              
           
            
        end        
        function obj = getDisplacement(obj) %calculate a random displacement according to D (diffusion coefficient, property of the object)
            meanDisplacementTheory=0; % average of the the displacement, i.e. the difference between two consecutive positions (for each dimension)
             stdDisplacementTheory=sqrt(2*obj.D*obj.tStep); % standard deviation of the displacement (for each dimension)
            obj.displacementX=meanDisplacementTheory+stdDisplacementTheory*randn(1);
            obj.displacementY=meanDisplacementTheory+stdDisplacementTheory*randn(1);
        end
        
%         function obj = resetPositions(obj)
%             obj.xPosition=0;
%             obj.yPosition=0;
%         
%         end
%         
%         function obj = setRandPositions(obj)
%             obj.xPosition=randn(1)*100;
%             obj.yPosition=randn(1)*100;
%         end
        
        function obj = setInitialPosition(obj, environment)
            %env=Environment();
            obj.xPosition=environment.length*obj.center+randn(1)*obj.breadth; %gaussian dist. along x

            obj.yPosition=rand(1)*environment.circumference; % random dist. along Y
        end
        
        function obj = getCurrentPosition(obj) %update to a new position based on the displacement
                obj.xPosition=obj.xPosition+obj.displacementX;
                obj.yPosition=obj.yPosition+obj.displacementY;
        
        end
        
  
        function obj = diffuse(obj) % run getDisplacement, and update the position accordingly for each time point
            obj.getDisplacement();
            obj.xPosition=obj.xPosition+obj.displacementX;
            obj.yPosition=obj.yPosition+obj.displacementY;
        end
    end
end

