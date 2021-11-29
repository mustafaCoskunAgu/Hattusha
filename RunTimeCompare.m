clear;
clc;
% 
% %% load Precomputed Network
deletedSize = 5;
PrecompFileName = 'Pruned_Hattusha_Multiplex.mat';
load(PrecompFileName);
%deletedSize is the size of networks after deletion


    %Generate Query nodes onces
    NumOfDrug = size(Gnorm,1)/deletedSize;
    allQueries = 1:1:NumOfDrug;
    
    idx=randperm(length(allQueries),5);
    queryNodes=allQueries(idx);

%% Hyper parameters


    epsilon = 1e-10;
    MaxIter = 1000;
    c = 0.85;
    %alphaset = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9];
    alphaset =  [0.7,0.8,0.9];
    saveFileNames={ 'RunTime_07.mat','RunTime_08.mat','RunTime_09.mat'}; % 'RunTime_01_DT.mat', 'RunTime_02_DT.mat','RunTime_03_DT.mat','RunTime_04_DT.mat',...
       % 'RunTime_05_DT.mat', 'RunTime_06_DT.mat',
    for k = 1: length(alphaset)
    
    alpha = alphaset(k);
    gamma = c/(1 + 2*alpha);
    kappa = 2*alpha/(1 + 2*alpha);
    eta = (1 - c)/(1 + 2*alpha);
    lMax = (c + 2*alpha)/(1+ 2*alpha);
    
    %alphaSet = 0.1:0.1:0.9;
    

 
    RuntimeholderMRWR = zeros(length(queryNodes),1);
    RuntimeholderEMRWR = zeros(length(queryNodes),1);
    %%
    M = gamma*Gnorm+kappa*Ynorm;
    
    
    
    for i = 1: length(queryNodes)
        for j = 1:deletedSize
            vec = zeros(1,NumOfDrug);
            vec(queryNodes(i)) = 1;
            C{j} = vec;
        end

        e = cell2mat(C);
        e = e';
        
        tic; 
        [r, Objs, Deltas] = CR(Gnorm, Ynorm, I_n, e, alpha, c, MaxIter, epsilon);
        %[r] =  MRWR (M,e,eta,epsilon);
        MRWRtime = toc;
        fprintf('MRWR Run time %f\n',MRWRtime);
        RuntimeholderMRWR(i) = MRWRtime;
        
        
        
        tic;
        [r2] = Hattusha(M,e,lMax,eta,epsilon);
        EMRWRtime = toc;
        fprintf('Efficient MRWR Run time %f\n',EMRWRtime);
        RuntimeholderEMRWR(i) = EMRWRtime;
        fprintf('#################################---%g---###########################################\n',i);
        
    end
    %cd RunTime_PR\
    fprintf('===================%g=============== FILE saved\n',k);
    save(saveFileNames{k},'RuntimeholderMRWR','RuntimeholderEMRWR');
    %cd ..
    end
%     B=B_index(idx);
%     
%     queryNode = [1];
%     
%      % CR
%         e = sparse(e);
%         [r, Objs, Deltas] = CR(Anorm, Ynorm, I_n, e, alpha, c, MaxIter, epsilon);

%% Create M matrix
%