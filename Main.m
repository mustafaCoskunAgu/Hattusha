clear;
clc;
% 
% %% load Precomputed Network
PrecompFileName = 'Pruned_Hattusha_Multiplex.mat';
load(PrecompFileName);
%deletedSize is the size of networks after deletion



%% Hyper parameters


    epsilon = 1e-6;
    MaxIter = 1000;
    c = 0.85;
    alpha = 0.7;
    gamma = c/(1 + 2*alpha);
    kappa = 2*alpha/(1 + 2*alpha);
    eta = (1 - c)/(1 + 2*alpha);
    lMax = (c + 2*alpha)/(1+ 2*alpha);

%% Create M matrix
M = gamma*Gnorm+kappa*Ynorm;
%%

NumOfDrug =size(Gnorm,1)/deletedSize;
saveMultiplexCR = zeros(NumOfDrug,NumOfDrug);
tic;
for queryNode = 1: NumOfDrug

    for i = 1:deletedSize

        vec = zeros(1,NumOfDrug);
        vec(queryNode) = 1;
        C{i} = vec;
    end

    e = cell2mat(C);
    e = e';

    tic;
    [r] = Hattusha(M,e,lMax,eta,epsilon);
    aveQueryTime = toc;
    fprintf('ith query %g\n',queryNode)  

    X = reshape(r,NumOfDrug,deletedSize);
    mergedR = sum(X,2)/deletedSize;
    saveMultiplexCR(:,queryNode) = mergedR;
end
totalTime = toc;
fprintf('Total Run Time %f\n',totalTime);
fprintf('Average Run Time %f\n',totalTime/NumOfDrug);

% PPRMatrix  = saveMultiplexCR;
% clear saveMultiplex;
% 
% [n,~] = size(PPRMatrix);
% 
% 
% CorrMatrix2 = zeros(n,n);
% newRuntime = 0;
% tic;
%     for i = 1:n
%       for j = 1:i
%         if(i == j)
%            %Do notting
%         else
% %         [I1,~] =find(PPRMatrix(:,i)<=1e-4);
% %         [I2,~] =find(PPRMatrix(:,j)<=1e-4);
% %         ind = intersect(I1,I2);
%         vec = [PPRMatrix(:,i), PPRMatrix(:,j)];
% %        vec(ind, :) = [];
%         CorrMatrix2(i, j) = corr(vec(:,1),vec(:,2));
%         end
% 
% 
%       end
%     end
% 
% newRuntime = toc+ newRuntime;
% fprintf('Time %f\n',newRuntime);
% 
% 
% 
% 
% 
%  clear PPNRMatrix;
%  multiplex = CorrMatrix2 + CorrMatrix2' + eye(n);
% 
%cd AlphaVal
   save('Multiplex_Hattusha_','saveMultiplexCR','-v7.3');

 %YeastClassification
%     %load('MultiplexCR_05.mat')
%     multiplex = log(saveMultiplexCR + 1/NumOfDrug);
%     multiplex = multiplex*multiplex;
% % % %     %end
% %      multiplex = sparse(multiplex);
% %      outputID = char(strcat('C:/Users/Secil/Desktop/DR/MultiSiGraC/', 'CR_01_PPMI_DT' ,'.mat'));
% %      save(outputID, 'multiplex');
%     addpath 'C:/Users/Secil/Desktop/DR/MultiSiGraC/';
%     load('CR_09_PPMI.mat');
%     fprintf('All networks loaded. Learning vectors via SVD...\n');
%     ndim = 512;
%     [V, d] = eigs(multiplex, ndim);
%     x = diag(sqrt(sqrt(diag(d)))) * V';
%     x =real(x);
%     cd C:\Users\Secil\Desktop\DR\deepDR-master;
%     writematrix(x','CRSvd_09_Emb.txt','Delimiter',' ');