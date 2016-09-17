function tree=buildTree(saved,s) 
% Input saved file, pre (s=1) or post-learning (s=2)
% Output tree cell array
% Cols: bID XYZ Child baseFoff tipFoff baseFon tipFon extras

%% Define state
 
if s==1
    dynamostate=2; structstate=1;
elseif s==2;
    dynamostate=3; structstate=2;
end

%% Create tree cell array 

% loading old tree and assigning bID
tree=saved.Dynamo.state{dynamostate}.tree;
bID=num2cell(1:numel(tree)); 

% selecting out nonempty branches 
branchNotEmpty=~cellfun(@isempty,tree)';
bID=bID(branchNotEmpty);
tree=tree(branchNotEmpty)';

% collect in cell array 
tree=vertcat(tree{:});
tree(:,5)=bID;

% keeping only bID XYZ and Children
bID_array=tree(:,5); XYZ_array=tree(:,1); children_array= tree(:,2);
tree=[bID_array, XYZ_array, children_array];


%% Include off.F data to tree array (epoch 1)

% keeping only non empty branches
offF=saved.datastruct.responses.byEpoch{structstate}.off.F;
onF=saved.datastruct.responses.byEpoch{structstate}.on.F; 

offF=offF(branchNotEmpty,:,:,:); 
onF=onF(branchNotEmpty,:,:,:); 

% separate tip/baseF for on/off into array
baseFoff=squeeze(offF(:,1,:,:)); baseFoff=num2cell(baseFoff,[2,3]);
baseFon=squeeze(offF(:,1,:,:)); baseFon=num2cell(baseFon,[2,3]);

tipFoff=squeeze(offF(:,2,:,:)); tipFoff=num2cell(tipFoff,[2,3]);
tipFon=squeeze(offF(:,2,:,:)); tipFon=num2cell(tipFon,[2,3]);

baseFoff=cellfun(@squeeze,baseFoff,'UniformOutput',false);
baseFon=cellfun(@squeeze,baseFon,'UniformOutput',false);

tipFoff=cellfun(@squeeze,tipFoff,'UniformOutput',false);
tipFon=cellfun(@squeeze,tipFon,'UniformOutput',false);

% including baseF/tipF in tree array
tree(:,4)=baseFoff; tree(:,5)=tipFoff;
tree(:,6)=baseFon; tree(:,7)=tipFon;


%% Include extra points to tree array
% origin XYZ off.F

extra=extraNodes(saved,structstate);

% create arrays of bIDs (for maps)
extrabID=[extra{:,1}]'; treebID=[tree{:,1}]';

% input bID output index location on tree
treebID_map=containers.Map(treebID,1:numel(treebID));

for b=1:numel(extrabID) 
    % loop through bIDs of extra nodes
    bID=extrabID(b); 
    
    % create cell array of every extra node in current branch
    I1=ismember(extrabID,bID); % position of every extra node on bID in extra array
    extraOnbID={extra(I1,2:end)}; % cell array of extra nodes on bID 
    
    % append cell containing extras to respective branch in tree
    I2=treebID_map(bID);    
    tree(I2,9)=extraOnbID;
end

end







