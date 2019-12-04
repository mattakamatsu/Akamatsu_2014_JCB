%Diffuse and capture model
%Matt Akamatsu, Pollard lab, June 28 2013

%% Initialize variables
clear;
clearvars;
clear classes;
nbTimePoints=8100; % in seconds
nbSimulations=10; % number of simulations 
stoichiometry = 1; % ratio of Type 2: Type 1 node binding
pBind = 0.5; % probability that the reaction betweeen Type 1 and 2 nodes leads to immobilization of the Type 2 node
%nbMontageFrames=10;

diagnose = false; % if true, seed a random number generator and show a sample output to test for reproducibility
if diagnose
    rng(101); %seed the random number generator to test for reproducibility
end
rCList=[0 5 10 20 40 60 80 100 200 400 600 800 1000]; % list of values of radius of capture to test; must be at least as long as the nbSimulations (number of simulations)
nbType2NodesList=[10 20 40 60 80 100 200 300 500 1000]; % list of number of Type 2 nodes to test; must be at least as long as the nbSimulations 
%dList=[200:200:2000]; % list of diffusion coefficient values to test; must be at least as long as the nbSimulations
dList=[200 400 600]; % list of diffusion coefficient values to test; must be at least as long as the nbSimulations
pBindList=[0:10:100];  % list of probabilities of binding to test; must be at least as long as the nbSimulations
stoichiometryList=[1:4];  % list of stoichiometries to test; must be at least as long as the nbSimulations

%% Choose which graphs to plot and save

plotType2NodeTracks=false; %fig 1. Graph tracks of Type 2 node motion and positions of Type 1 nodes
plotNbReacted1VsTime=false; %fig 2. Plot number of bound Type 1 nodes vs. time. Usually same as fig 3 unless stoichiometry >1
plotNbReacted2VsTime=false; %fig 3. Plot number of bound Type 2 nodes vs. time
plotNodeFinalPosition=false; % fig 5. Graph final position of nodes
plotNodeFinalPositionHistogram=false; % fig 6. Plot histogram of final position of Type 2 nodes
plotAvDeviationFromType2Nodes=false; % fig 7. Plot average final X position of Type 2 nodes (all, red; bound, black) relative to average X position of Type 1 nodes

%% Choose one or fewer parameter to vary for each run
varyRc=false;
varyNbType2Nodes=false;
varyD=true;
varyPbind=false;
varyStoichiometry=false;

cellLength=1; % length of the array that accommodates the number of iterations of the parameter

if varyRc
    cellLength=length(rCList);
end

if varyNbType2Nodes
    cellLength=length(nbType2NodesList);
end

if varyD
    cellLength=length(dList);
end

if varyPbind
    cellLength=length(pBindList);
end

if varyStoichiometry
    cellLength=length(stoichiometryList);
    
end
%% Initialize output arrays
nbBound=cell(3,cellLength);
avDevTotal=cell(3,cellLength);
avDevReact=cell(3,cellLength);

react1VsTimeVsSimulations=zeros(nbTimePoints,nbSimulations);
react1NumberVsSimulations=zeros(nbSimulations);

react2VsTimeVsSimulations=zeros(nbTimePoints,nbSimulations);
react2NumberVsSimulations=zeros(nbSimulations);

avReactDevFromMidType1VsSimulations=zeros(nbTimePoints,nbSimulations);
avType2DevFromMidVsSimulations=zeros(nbTimePoints,nbSimulations);

react2VsTimeAvgStdSims=zeros(nbTimePoints,2);


m=1;
%% Run simulation
while m<=cellLength %Iterates simulations while varying the parameter chosen above
    
n=1;
while n<=nbSimulations %Iterates simulations according to nbSimulations
    react2VsTimeShort=zeros(nbTimePoints,1);
    
    react1VsTime=zeros(nbTimePoints,1);
    react2VsTime=zeros(nbTimePoints,1);
    
    avReactDevFromMid=zeros(nbTimePoints,1);
    avReactDevFromMidType1=zeros(nbTimePoints,1);
    
    avType2DevFromMidType1=zeros(nbTimePoints,1);
    avType2DevFromMid=zeros(nbTimePoints,1);
    
    node2=TypeIInode();
    node1=TypeInode();
        
    allNode2s=Type2NodePopulation();
    allNode1s=Type1NodePopulation();
    env=Environment();
    
    react2XPositions=zeros(nbTimePoints,allNode2s.quantity);
    react2YPositions=zeros(nbTimePoints,allNode2s.quantity);
    free2XPositions=zeros(nbTimePoints,allNode2s.quantity);
    free2YPositions=zeros(nbTimePoints,allNode2s.quantity);

    if varyNbType2Nodes
        
        allNode2s.quantity=nBType2NodesList(n) % iterate number of Type 2 nodes
    end
    
    node2xPositions=zeros(nbTimePoints, allNode2s.quantity);
    node2yPositions=zeros(nbTimePoints, allNode2s.quantity);
    
    node1xPositions=zeros(nbTimePoints, allNode1s.quantity);
    node1yPositions=zeros(nbTimePoints, allNode1s.quantity);
    
    reactNode2TempX=zeros(nbTimePoints, allNode1s.quantity);
    reactNode2TempY=zeros(nbTimePoints, allNode1s.quantity);

    listOfType2Nodes=cell(allNode2s.quantity,1);
    
    react2XPos=zeros(allNode2s.quantity,1);
    react2YPos=zeros(allNode2s.quantity,1);
    free2XPos=zeros(allNode2s.quantity,1);
    free2YPos=zeros(allNode2s.quantity,1);
    
    reactList1=zeros(length(listOfType2Nodes),1); % list of number of Type 2 nodes that reacted
    reactList2=zeros(length(listOfType2Nodes),1); % list of nubmer of Type 1 nodes that reacted
    
    for i=1:allNode2s.quantity
        listOfType2Nodes{i}=TypeIInode();
    end
    
    listOfType1Nodes=cell(allNode1s.quantity,1);
    for i=1:allNode1s.quantity
        listOfType1Nodes{i}=TypeInode();
    end
    
    if varyRc
        
        for i=1:allNode2s.quantity
            curNode2=listOfType2Nodes{i};
            curNode2.rC=rCList(n); % iterate rC
            curNode2.setInitialPosition(env);
            node2xPositions(1,i)=curNode2.xPosition;
            node2yPositions(1,i)=curNode2.yPosition;
        end
    else
        if varyD
            for i=1:allNode2s.quantity
                curNode2=listOfType2Nodes{i};
                curNode2.setInitialPosition(env);
                curNode2.D=dList(m);
                node2xPositions(1,i)=curNode2.xPosition;
                node2yPositions(1,i)=curNode2.yPosition;
            end
        else
            for i=1:allNode2s.quantity
                curNode2=listOfType2Nodes{i};
                curNode2.setInitialPosition(env);
                node2xPositions(1,i)=curNode2.xPosition;
            end
        end
    end
    for i=1:allNode1s.quantity
        curNode1=listOfType1Nodes{i};
        curNode1.setInitialPosition(env);
        %node1xPositions(1,i)=curNode1.xPosition; %if Type 1 nodes diffusing
        %node1yPositions(1,i)=curNode1.yPosition;
        node1xPositions(:,i)=curNode1.xPosition; %if Type 1 nodes stationary
        node1yPositions(:,i)=curNode1.yPosition;
    end
    
        avType1DevFromMid=mean(node1xPositions(1,:)-3000); %average X position of type 1 nodes (from center, defined here as X=3000) 

    
    %% Set diffusion and reactions in motion from t=2 until nbTimepoints
    t=2;
    while t<=nbTimePoints
        
        for i=1:allNode2s.quantity
            curNode2=listOfType2Nodes{i};
          
            
            
            if curNode2.reactedWith
                node2xPositions(t,i)=curNode2.xPosition;
                node2yPositions(t,i)=curNode2.yPosition;
            else
                
                
                
                curNode2.diffuse();
                curNode2.isInEnvironment(env);
                
                node2xPositions(t,i)=curNode2.xPosition;
                node2yPositions(t,i)=curNode2.yPosition;
                
                if curNode2.xPosition + curNode2.rC >= min(node1xPositions(1,:)) %optimization; only try to react Type 2 nodes with an X position >= the leftmost Type 1 node
                    
                    
                    for j=1:allNode1s.quantity %react to Type 1 nodes
                        curNode1=listOfType1Nodes{j};
                        if curNode1.reactedWith<stoichiometry; % let Type 2 nodes react with only the Type 1 nodes that haven't reacted with any type 2 nodes (or with fewer than the stoichiometry dictates)
                            curNode2.react(curNode1,pBind); % let current Type 2 node react with current Type 1 node (if it's close enough, according to Type2node.react) and with probability of a successful reaction (binding) dictated by pBind
                        end
                    end
                end
            end
            
        end
        
        % Diffusion of Type 1 nodes. Off by default.        
        %          for i=1:allNode1s.quantity
        %         curNode1=listOfType1Nodes{i};
        %
        %
        %         %curNode1.diffuse();
        %
        %         node1xPositions(t,i)=curNode1.xPosition;
        %         node1yPositions(t,i)=curNode1.yPosition;
        %
        %        end
        %
        for l=1:length(listOfType1Nodes)
            
            reactList1(l)=listOfType1Nodes{l}.reactedWith(1);
            
            react1VsTime(t)=sum(reactList1);
            
        end
        
        for l=1:length(listOfType2Nodes)
            if listOfType2Nodes{l}.reactedWith
                
                react2XPositions(t,l)=listOfType2Nodes{l}.xPosition;
                react2YPositions(t,l)=listOfType2Nodes{l}.yPosition;
            end
        end
        for l=1:length(listOfType2Nodes)
            if ~listOfType2Nodes{l}.reactedWith
                free2XPositions(t,l)=listOfType2Nodes{l}.xPosition;
                free2YPositions(t,l)=listOfType2Nodes{l}.yPosition;
            end
        end
        
        for l=1:length(listOfType2Nodes)
            
            reactList2(l)=listOfType2Nodes{l}.reactedWith;
        end
       
%% Record the average X position of Type 2 nodes relative to the theoretical average X position of Type 1 nodes
        
        histTemp=react2XPositions(t,:); %x pos of all reacted nodes at last time point
        histTemp2=histTemp(histTemp~=0); %x pos of all reacted nodes at last time point (>0)
        
        histTemp3=free2XPositions(t,:); %x pos of all free nodes at last time point
        histTemp4=histTemp3(histTemp3~=0); %x pos of all free nodes at last time point (>0)
        
        histTemp5=node2xPositions(t,:); %x pos of all Type 2 nodes at last time point
        histTemp6=histTemp5(histTemp5~=0); %x pos of all Type 2 nodes at last time point (>0)
        
        devReactFromMid=histTemp2-3000;
        avReactDevFromMid(t)=mean(devReactFromMid); % average deviation of reacted nodes from theoretical middle x position of Type 1 nodes
        avReactDevFromMidType1(t)=avReactDevFromMid(t)-avType1DevFromMid; % average deviation of reacted nodes from true measured x position of middle of Type 1 nodes
        
        devType2FromMid=histTemp5-3000;
        avType2DevFromMid(t)=mean(devType2FromMid); % average deviation of Type 2 nodes from theoretical middle x position of Type 1 nodes
        avType2DevFromMidType1(t)=avType2DevFromMid(t)-avType1DevFromMid; % average deviation of Type 2 nodes from true measured x position of middle of Type 1 nodes
        
%% Record the number reacted vs time and move on to next time point        
        react2VsTime(t)=sum(reactList2); % number reacted vs time
        react2VsTimeShort(t:t+node2.tStep-1)=sum(reactList2);
        t=t+node2.tStep; % Go to next time point
    end
    
    
%     Make montage (not completed)   
% montageStep=size(react2XPositions,1)/nbMontageFrames
%     for i=2:2*montageStep:size(react2XPositions,1)
%         reactNode2TempX(i,:)=react2XPositions(i,:)+i*montageStep;
%         reactNode2TempY(i,:)=react2YPositions(i,:);
%     end
   
    
    reactNumber1=sum(reactList1>0); % Number of Type 1 nodes that reacted
    
    reactNumber2=sum(reactList2) % Number of Type 2 nodes that reacted
    

    %% Plot figures
    
    % Plot tracks of motion of Type 2 nodes
    if plotType2NodeTracks
        fig1=figure(1);clf; hold on; plot(node2xPositions,node2yPositions,'o','MarkerSize',2); plot(node1xPositions,node1yPositions,'o','MarkerEdgeColor','g','MarkerSize',10);xlabel('X (nm)');ylabel('Y (nm)'); xlim([0,env.length]); ylim([0,env.circumference]);
        set(gcf, 'Outerposition', [400 400 380 600])
    end
    
    % Plot number of bound Type 1 nodes vs. time
    if plotNbReacted1VsTime
        fig2=figure(2);hold on; plot(react1VsTime);xlabel('time(s)');ylabel('number of bound Type 1 nodes');ylim ([0 length(listOfType1Nodes)]);
        set(gcf, 'Outerposition', [1400 400 300 300])
    end
    
    % Plot number of bound Type 2 nodes vs. time
    if plotNbReacted2VsTime
        fig3=figure(3);hold on; plot(react2VsTimeShort);xlabel('time(s)');ylabel('number of immobilized Type 2 nodes');ylim ([0 length(listOfType1Nodes)]);xlim([0 nbTimePoints]);
        set(gcf, 'Outerposition', [900 400 300 300])
    end
    
    % Plot final positions of nodes
    if plotNodeFinalPosition
        fig5=figure(5);clf; hold on; plot(react2XPositions(length(react2XPositions),:),react2YPositions(length(react2YPositions),:),'o','MarkerSize',10, 'MarkerEdgeColor', 'y','LineWidth',1.5); hold on;
        plot(free2XPositions(length(free2XPositions),:),free2YPositions(length(free2YPositions),:),'o','MarkerSize',10, 'MarkerEdgeColor', 'r'); hold on;
        plot(node1xPositions(1,:), node1yPositions(1,:),'o','MarkerSize',10, 'MarkerEdgeColor', 'g'); hold on;
        set(gcf, 'Outerposition', [800 400 380 600]);set(gca,'Color','k')
    end
    
    % Plot histogram of final X position of Type 2 nodes
    if plotNodeFinalPositionHistogram
        fig6=figure(6);clf;hold on; hist(node2xPositions(length(node2xPositions),:));xlim ([0 env.length]);
    end
    
    % Plot average position of total (red) and bound (black) Type 2 nodes relative to average X position of Type 1 nodes
    if plotAvDeviationFromType2Nodes
        fig7=figure(7);plot([2:2:nbTimePoints],avReactDevFromMidType1(2:2:nbTimePoints),'k');xlim([1 nbTimePoints]);ylim([-3000 500]); hold on;
        plot([2:2:nbTimePoints],avType2DevFromMidType1(2:2:nbTimePoints),'r');
        set(fig7, 'Outerposition', [900 400 300 300])
    end
    
    react1VsTimeVsSimulations(:,n)=react1VsTime;
    react1NumberVsSimulations(n)=reactNumber1;
    
    react2VsTimeVsSimulations(:,n)=react2VsTime;
    react2NumberVsSimulations(n)=reactNumber2;
    
    
    avReactDevFromMidType1VsSimulations(:,n)=avReactDevFromMidType1;
    avType2DevFromMidVsSimulations(:,n)=avType2DevFromMidType1;

    curNode2.D
    n=n+1;
end
% When varying the values of one parameter, Each column (m) will correspond to the output from one value of that parameter
    nbBound{1,m}=react2VsTimeVsSimulations; % Number bound vs time; each column is one simulation
    nbBound{2,m}=mean(react2VsTimeVsSimulations,2); % Number of bound vs time, averaged over number of simulations for each parameter
    nbBound{3,m}=std(react2VsTimeVsSimulations,0,2); % Standard deviation of number bound vs time, from averages created above
    
    avDevTotal{1,m}=avType2DevFromMidVsSimulations;
    avDevTotal{2,m}=mean(avType2DevFromMidVsSimulations,2);
    avDevTotal{3,m}=std(avType2DevFromMidVsSimulations,0,2);

    avDevReact{1,m}=avReactDevFromMidType1VsSimulations;
    avDevReact{2,m}=mean(avReactDevFromMidType1VsSimulations,2);
    avDevReact{3,m}=std(avReactDevFromMidType1VsSimulations,0,2);
    
    m=m+1;
end
%% Make data for figures for averages over numbers of simulations

%array of multiple-simulation mean (column 1) and standard deviation (column 2) of the number
%of reacted Type 2 nodes, versus time.

fig3=figure(3);hold on; plot([2:2:nbTimePoints],react2VsTimeVsSimulations(2:2:nbTimePoints,:),'k-');xlabel('Time (s)');ylabel('Number of immobilized Type 2 nodes');ylim ([0 length(listOfType1Nodes)]);xlim([0 nbTimePoints]);
set(gcf, 'Outerposition', [900 400 200 250])
box(gca,'on');

for i=2:node2.tStep:nbTimePoints
react2VsTimeAvgStdSims(i,1)=mean(react2VsTimeVsSimulations(n,:));
react2VsTimeAvgStdSims(i,2)=std(react2VsTimeVsSimulations(n,:));

end

if diagnose
    sampleOutput=free2XPositions(2,1)
end

%% Save variables and graphs

dateLabel=[num2str(date) '_'];
dateTime=[num2str(now) '_'];
dLabel=['D' num2str(curNode2.D) '_'];
nb2Label=['nbII' num2str(allNode2s.quantity) '_'];
stoicLabel=['stoic' num2str(stoichiometry) '_'];
timeLabel=['t' num2str(nbTimePoints) '_'];
pBindLabel=['pBind' num2str(pBind*100) '_'];
typeIxPosLabel=['xPosI' num2str(curNode1.center*100) '_'];
varyLabel=[''];
if varyRc 
   varyLabel=['varyRc']; 
end

if varyD
   varyLabel=['varyD']; 
end

if varyNbType2Nodes
    varyLabel='varyNbType2Nodes';
end

if varyPbind
    varyLabel='varyPbind';
end

if varyStoichiometry
    varyLabel='varyStoichiometry';
end

label=[dateLabel dateTime dLabel nb2Label stoicLabel timeLabel pBindLabel typeIxPosLabel varyLabel]
label1=[num2str(label) ' 1']; 
label2=[num2str(label) '_2'];
label3=[num2str(label) '_3'];
label4=[num2str(label) '_4'];
label5=[num2str(label) '_5'];
label6=[num2str(label) '_6'];
label7=[num2str(label) '_7'];


if plotType2NodeTracks
    print (fig1, '-dpdf', label1)
    set (fig1,'PaperPositionMode','auto')

end

if plotNbReacted1VsTime
    print (fig2, '-dpdf', label2)
    set (fig2,'PaperPositionMode','auto')

end

if plotNbReacted2VsTime
    print (fig3, '-dpdf', label3)
    set (fig3,'PaperPositionMode','auto')
end

if plotNodeFinalPosition
    print (fig5, '-dpdf', label5)
    set (fig5,'PaperPositionMode','auto')

end

if plotNodeFinalPositionHistogram
    print (fig6, '-dpdf', label6)
    set (fig6,'PaperPositionMode','auto')

end

if plotAvDeviationFromType2Nodes
    print (fig7, '-dpdf', label7)
    set (fig7,'PaperPositionMode','auto')

end
label2=[label '.mat'];
save(label2)
    

