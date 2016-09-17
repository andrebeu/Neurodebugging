function [W,Wb,J,A]=trainNet(X,y,nl,it)

% parameters
n=size(X,2); %nl=20; 
alpha=0.0001; lamb=0.000001; % it=150;
syms g(z), g(z)=4*tanh(z); Dg=diff(g);
%z=-3:.1:3; plot(z,eval(g(z)))

% initialize containers
A=cell(1,nl); Z=cell(1,nl); 
W=cell(1,nl-1); Wb=cell(1,nl-1); 
delta=cell(1,nl); DJDW=cell(1,nl-1); DJDWb=cell(1,nl-1);
J=[];

% intialize weights
for i=1:nl
    if i==nl
        A{i}=zeros(size(n));
        Z{i}=zeros(size(n));
        W{i}=randn(1,size(X,1))/10;
        Wb{i}=randn(1)/10;
    else
        A{i}=zeros(size(X,n));
        Z{i}=zeros(size(X,n));
        W{i}=randn(size(X,1))/5;
        Wb{i}=randn(size(X,1),1)/5;
    end
end
W=W(2:end);Wb=Wb(2:end);

% data input 
A{1}=X; t=y; 

for j=1:it
       
    %FP
    for l=2:nl
        biasmat=repmat(Wb{l-1},1,n);
        Z{l}=W{l-1}*A{l-1}+biasmat;
        A{l}=eval(g(Z{l}));
    end
        
    j=(1/n)*sum((t-A{nl}).^2);
    J=[J j];
    
    %BP
    for l=nl:-1:1
        if l==nl
            delta{l}=-(t-A{nl}).*eval(Dg(Z{nl}));
        else
            delta{l}=(W{l}'*delta{l+1}).*eval(Dg(Z{l}));         
            DJDW{l}=(1/n)*delta{l+1}*(A{l})';
            DJDWb{l}=(1/n)*sum(delta{l+1},2);
        end
    end
    
    W=cellfun(@(x,y) x-(alpha*y+lamb*x),W,DJDW,'UniformOutput',0);
    Wb=cellfun(@(x,y) x-alpha*y,Wb,DJDWb,'UniformOutput',0);
    
	%clf, plot(1:numel(t),t)
	%hold on, scatter(1:numel(A{nl}),zscore(A{nl}))    
    %clf, scatter(1:numel(J),J);
    %drawnow 
end

        
