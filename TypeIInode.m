
classdef TypeIInode < handle
    properties
        name % name of the strain
        %nbTimePoints=50;
        xPosition=0; 
        yPosition=0; 
        xPositions;% for multiple nodes
        yPositions;
        D=400; % Diffusion coefficient, in nm^2/s
        reactedWith=0; 
        %diffusionCoefficient %Diffusion coefficient
        displacementX
        displacementY
        %diffuse
        %react
        colorMap 
        tStep=2;
        rC=60; % Effective capture radius, in nm. Affected by time step, and includes probability of binding within a given time step.
        %timePoints=100;
    end
    methods
        %% Constructor
        function obj = TypeIInode()              
           
            
        end
        %can record position in an array...         
        
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
%             obj.xPosition=rand(1)*100;
%             obj.yPosition=rand(1)*100;
%         end
        
        function obj = setInitialPosition(obj, environment)
            %env=Environment();
            obj.xPosition=0;
            obj.yPosition=rand(1)*environment.circumference;
        end
        
        function obj = getCurrentPosition(obj) %update to a new position based on the displacement
                obj.xPosition=obj.xPosition+obj.displacementX;
                obj.yPosition=obj.yPosition+obj.displacementY;
        
        end

            function obj = isInEnvironment(obj, env)
                %env=Environment();
                if obj.xPosition <0
                    obj.xPosition = abs(obj.xPosition); %reflect in X for x<0
                end

                if obj.xPosition>env.length
                    %obj.xPosition=rem(obj.xPosition,env.length); %reflect in X for x>environment length
                    obj.xPosition=obj.xPosition-(obj.xPosition-env.length);
                end
                
                if obj.yPosition<0
                    obj.yPosition=obj.yPosition + env.circumference; %continuous in Y (objects with y<0 get transported to the top of the field, minus remainder.)
                end
                
                if obj.yPosition>env.circumference
                    obj.yPosition=rem(obj.yPosition,env.circumference); %continuous in Y (objects with y> circumference get transported to the bottom of the field, plus remainder.)
                end

            end


            function obj = diffuse(obj) % run getDisplacement, and update the position accordingly for each time point
            %allType2Nodes=Type2NodePopulation();
            %for i=1:allType2Nodes.quantity
%                 for j=1:(obj.nbTimePoints-1)
%                     obj.getDisplacement();
%                     obj.xPosition(j+1)=obj.xPosition(j)+obj.displacementX;
%                     obj.yPosition(j+1)=obj.yPosition(j)+obj.displacementY;
%                 end
                %for j=1:(obj.nbTimePoints-1)
                    obj.getDisplacement();
                    obj.xPosition=obj.xPosition+obj.displacementX;
                    obj.yPosition=obj.yPosition+obj.displacementY;
                %end
%                 obj.xPositions(:,i)=obj.xPosition;
%                 obj.yPositions(:,i)=obj.yPosition;
           % end
            end
            function obj = react(obj,curNode1,pBind)
               %function obj = react(obj,curNode1)
    
                %node1=TypeInode();
                % I can program in the Type 1 node capture radius and see
                % if that's more computationally expensive.
                %allType2Nodes=Type2NodePopulation();
                %allType1Nodes=Type1NodePopulation();
                %node1=TypeInode();
                %for i=1:allType1Nodes.quantity
                if (obj.xPosition-curNode1.xPosition)^2+(obj.yPosition-curNode1.yPosition)^2<obj.rC^2
                    
                    bindDice=rand(1); % for changing p(bind)
                        if bindDice<=pBind
                    obj.reactedWith(1)=true;
                    curNode1.reactedWith(1)=curNode1.reactedWith(1)+1;
                        end
%                 else
%                     obj.reactedWith=0;
                %end
                end
                    
            end
            function obj = increaseD(obj)
                
                obj.D=obj.D+1000;
                
            end
            
%         function obj = setPosition()
%             %obj.xPosition(1)=0;
%             %obj.yPosition(1)=0;
%                 
%             obj.displacementX=meanDisplacementTheory+stdDisplacementTheory*randn(timePoints,1);
%             obj.displacementY=meanDisplacementTheory+stdDisplacementTheory*randn(timePoints,1);
%            
%               for i=1:timePoints
%                     obj.xPosition(i+1)=obj.xPosition(i)+obj.displacementX;
%                     obj.yPosition(i+1)=obj.yPosition(i)+obj.displacementY;
%         
%         
%               end
%        
%         
%         end
    end
end
        
