clear
%cd('C:\Users\abeukers\Dropbox\Plasticity Debugging\MATLAB plasticity debugging')%lab
cd('/Users/andrebeukers/Dropbox/Plasticity Debugging/MATLAB plasticity debugging')%home

load('weightserrors');

%% Preprocessing

% separate hidden from output weights
W1=cellfun(@(x) x(1), weights1); E1=cellfun(@(x) x(200),errors1);
W2=cellfun(@(x) x(1), weights2); E2=cellfun(@(x) x(200),errors2);

% rounding 
W1=cellfun(@(x) round(x,3), W1,'UniformOutput',0); 
W2=cellfun(@(x) round(x,3), W2,'UniformOutput',0); 
 
% matrix: each row an observation, each col a parameter
W1=cellfun(@(x) reshape(x,1,[]),W1,'UniformOutput',0); W1=vertcat(W1{:});
W2=cellfun(@(x) reshape(x,1,[]),W2,'UniformOutput',0); W2=vertcat(W2{:});

% rowise zscore
W1=zscore(W1,0,1);
W2=zscore(W2,0,1);

%% Figure: NN errors

hold on
for i=1:100
    erplot1=scatter(1:200,errors1{i});
end

title('Prelearning Error For Each Iteration')
xlabel('Iteration'); ylabel('Error')

figure, hold on 
for i=1:100
    erplot2=scatter(1:200,errors2{i});
end

title('Postlearning Error For Each Iteration')
xlabel('Iteration'); ylabel('Error')

%% Build correlation matrices

% correlation matrices
[corrW1,pcorrW1]=corrcoef(W1); 
[corrW2,pcorrW2]=corrcoef(W2);

%% Convergence measure

%parpool(12)

parfor i=1:50
    pwr=i*.2
    alph=1/(10^pwr);
    conv1(i)=sum(abs(corrW1(pcorrW1<alph)));
    conv2(i)=sum(abs(corrW2(pcorrW2<alph)));
end

%% Figure: convergence

B=bar(conv2-conv1)

