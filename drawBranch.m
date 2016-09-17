function drawBranch(saved,branch_number,s)

% Input branch number and optionally saved file and state number
% draws the branch. nonCa Blue, children Green, extraPts Black
% default state==1

%% Adjusting state mismatch in Dynamo, depends on tree
if s==1
    dynamostate=1; structstate=1;
elseif s==2;
    dynamostate=4; structstate=2;
end
%%

% Initial variable definitions
tree=saved.Dynamo.state{dynamostate}.tree;
branch=tree{branch_number};

% XYZ of structural elements and child base 
haveChildren= ~cellfun(@isempty,branch{2});
XYZ=branch{1}; X=XYZ(1,:); Y=XYZ(2,:); Z=XYZ(3,:);
FX=X(haveChildren); FY=Y(haveChildren); FZ=Z(haveChildren);

% XYZ of Extrapoints
extraNodesArray=extraNodes(saved,structstate); extraBranches=[extraNodesArray{:,1}];
I=extraBranches==branch_number; nodesOnBranch=extraNodesArray(I,:);

if ismember(branch_number,extraBranches)
    XYZextra=[nodesOnBranch{:,3}]; Xextra=XYZextra(1,:);
    Yextra=XYZextra(2,:);Zextra=XYZextra(3,:);
    scatter3(Xextra,Yextra,Zextra,'k') % extraPoints Black
    hold on
end

% Plot and scatter structural elements, base in red
scatter3(X,Y,Z,'b'); hold on, plot3(X,Y,Z,'b') % nonCalcium Blue
scatter3(X(1),Y(1),Z(1),'r'), % branchBase Red
scatter3(FX,FY,FZ,'g') % childrenBases Green

end




