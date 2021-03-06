clear;
clc;


Nets = {'drugdrug.txt','drugsimBPnet.txt','drugsimCCnet.txt','drugsimChemicalnet.txt','drugsimMetanet.txt',...
    'drugsimMFnet.txt','drugsimTherapeuticnet.txt','drugsimWmnet.txt','Sim_drugProtein.txt','Sim_drugsideEffect.txt'};

B = load('DrugRepo_A_Matrix.mat');
B = B.distanceMatrix + B.distanceMatrix';

%Distance Kernel
B = exp(-B/100);

rowSum = sum(B,2);

[value, ind] = sort(rowSum, 'ascend');

[index,~] = find(value<2);

deleteIndex = ind(index);


allIndex = 1:size(Nets,2);

keptIndex = setdiff(allIndex,deleteIndex);



A = B(keptIndex,keptIndex);


cd 'data\drugNets';



%Nets = {'proteinprotein.txt', 'proteinsim1network.txt','proteinsim2network.txt','proteinsim3network.txt', ...
%    'proteinsim4network.txt'};




Nets(deleteIndex) = [];



%A = ones(size(Nets,2));

 
 for i = 1: size(Nets,2)
    X = load(Nets{i});
    %Mk = RandSurf(A{1}.network, Kstep, alpha);
    %G{i}=X.network;
    X = sparse(X);
    G{i} = X;
 end
 
 NumberOfDrug = size(X,2);
 
 
 
 for i = 1: size(Nets,2)
    G_ID{i} = 1:NumberOfDrug;
 end
 
 
 %% Initialization
h = length(G);
ns = cellfun(@length, G_ID);
n = sum(ns);
I_n = speye(n);



%% Normalize G
Gnorms = cell(size(G));

for i = 1:h
    
    D = sum(G{i},2);
    D = D.^(-0.5);
    D = diag(D);
    Gnorms{i} = D*G{i}*D;
    
end

Gnorm = blkdiag(Gnorms{:});

%% Common node mapping
Y = sparse(n,n);
Dv = cell(h,1);
dA = sum(A,2);

for i = 1:h
    
    Dv{i} = dA(i)*speye(ns(i));
    Y_i = sparse(ns(i),n);
    
    for j = i:h
        
        [proj, I1, I2] = intersect(G_ID{i}, G_ID{j});
        Oij = sparse(I1, I2, ones(length(proj),1), ns(i), ns(j));
        Y_i(:, sum(ns(1:j-1))+1:sum(ns(1:j))) = A(i,j)*Oij;
        
    end
    
    Y(sum(ns(1:i-1))+1:sum(ns(1:i)), :) = Y_i;
    
end

Y = triu(Y) + triu(Y)' - diag(diag(Y));

%% Construct normalized Y
Dv = blkdiag(Dv{:});
Dv = diag(diag(Dv).^(-0.5));
Ynorm = Dv*Y*Dv;
deletedSize = size(Nets,2);
%% Save precomputed matrices
cd '..\..\'
PrecompFileName = 'Pruned_Hattusha_Multiplex.mat';
save(PrecompFileName,'Gnorm','Ynorm','I_n','deletedSize');