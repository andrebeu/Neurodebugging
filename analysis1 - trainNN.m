clear
cd('/Users/andrebeukers/Dropbox/Plasticity Debugging/MATLAB plasticity debugging')
%cd('C:\Users\abeukers\Dropbox\Plasticity Debugging\MATLAB plasticity debugging')%lab

load('2014-07-09_2_V4_ALLDONE.mat'); % Data
savedLTP=saved;

%% Preprocessing

clearvars -except savedLTP

% Build trees
dB=@(br,st) drawBranch(savedLTP,br,st);
LTPtree1=buildTree(savedLTP,1); LTPtree2=buildTree(savedLTP,2); 

% Input matrix
XLTP1off=LTPtree1(2:end,4:5); XLTP1on=LTPtree1(2:end,6:7);
XLTP2off=LTPtree2(2:end,4:5); XLTP2on=LTPtree2(2:end,6:7);

% Moving mean
for c=1:numel(XLTP1off)
    for col=1:size(XLTP1off{c},2)
        for i=1:95
            tempoff(i,col)=sum(XLTP1off{c}(i:i+5,col))/5;   
            tempon(i,col)=sum(XLTP1on{c}(i:i+5,col))/5;   
        end
    end
    XLTP1offMM{c,1}=tempoff;
    XLTP1onMM{c,1}=tempon;
end

for c=1:numel(XLTP2off)
    for col=1:size(XLTP2off{c},2)
        for i=1:95
            tempoff(i,col)=sum(XLTP2off{c}(i:i+5,col))/5;   
            tempon(i,col)=sum(XLTP2on{c}(i:i+5,col))/5;   
        end
    end
    XLTP2offMM{c,1}=tempoff;
    XLTP2onMM{c,1}=tempon;
end

% reshape
XLTP1offMM=cellfun(@(x) reshape(x,1,[]), XLTP1offMM,'UniformOutput',0);
XLTP1onMM=cellfun(@(x) reshape(x,1,[]), XLTP1onMM,'UniformOutput',0);
XLTP2offMM=cellfun(@(x) reshape(x,1,[]), XLTP2offMM,'UniformOutput',0);
XLTP2onMM=cellfun(@(x) reshape(x,1,[]), XLTP2onMM,'UniformOutput',0);

% remove nan
XLTP1offMM=XLTP1offMM(cellfun(@(x) ~any(isnan(x)), XLTP1offMM));
XLTP1onMM=XLTP1onMM(cellfun(@(x) ~any(isnan(x)), XLTP1onMM));
XLTP2offMM=XLTP2offMM(cellfun(@(x) ~any(isnan(x)), XLTP2offMM));
XLTP2onMM=XLTP2onMM(cellfun(@(x) ~any(isnan(x)), XLTP2onMM));

% format input matrix
XLTP1offMM=vertcat(XLTP1offMM{:});
XLTP1onMM=vertcat(XLTP1onMM{:});
XLTP2offMM=vertcat(XLTP2offMM{:});
XLTP2onMM=vertcat(XLTP2onMM{:});

% Output vector

% Moving mean
yLTP1off=LTPtree1{1,4}; yLTP2off=LTPtree2{1,4};
yLTP1on=LTPtree1{1,6}; yLTP2on=LTPtree2{1,6};
for c=1:size(yLTP1off,2)
    for i=1:95
        yLTP1offMM(i,c)=sum(yLTP1off(i:i+5,c))/5;
        yLTP2offMM(i,c)=sum(yLTP2off(i:i+5,c))/5;
        yLTP1onMM(i,c)=sum(yLTP1on(i:i+5,c))/5;
        yLTP2onMM(i,c)=sum(yLTP2on(i:i+5,c))/5;
    end
end

yLTP1offMM=reshape(yLTP1offMM,1,[]);
yLTP2offMM=reshape(yLTP2offMM,1,[]);
yLTP1onMM=reshape(yLTP1onMM,1,[]);
yLTP2onMM=reshape(yLTP2onMM,1,[]);

% Normalize w.r.t time point

[XLTP1offMM,mu1off,sig1off]=zscore(XLTP1offMM,0,1); 
[XLTP2offMM,mu2off,sig2off]=zscore(XLTP2offMM,0,1); 
[XLTP1onMM,mu1on,sig1on]=zscore(XLTP1onMM,0,1); 
[XLTP2onMM,mu2on,sig2on]=zscore(XLTP2onMM,0,1);

yLTP1offMM=(yLTP1offMM-mu1off)./sig1off;
yLTP2offMM=(yLTP2offMM-mu2off)./sig2off;
yLTP1onMM=(yLTP1onMM-mu1on)./sig1on;
yLTP2onMM=(yLTP2onMM-mu2on)./sig2on;

%% Train neural net

nl=4; it=200; %parpool(200);

y=yLTP1offMM; X=XLTP1offMM;

parfor i=1:100
    [W,Wb,J,A]=trainNet(X,y,nl,it);
    weights1{i}=W; errors1{i}=J; activations1{i}=A;
end

y=yLTP2offMM; X=XLTP2offMM;

parfor i=1:100
    [W,Wb,J,A]=trainNet(X,y,nl,it);
    weights2{i}=W; errors2{i}=J; activations2{i}=A;
end
