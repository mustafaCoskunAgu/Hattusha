    load('Multiplex_Hattusha_Ones.mat');
    load('Pruned_Hattusha_Multiplex_Ones.mat');
    
    
    
    NumOfDrug = size(saveMultiplexCR,1);
    multiplex = log(saveMultiplexCR + 1/NumOfDrug);
    multiplex = multiplex*multiplex;
    
    fprintf('Learning vectors via SVD...\n');
    ndim = 32;
    [V, d] = eigs(multiplex, ndim);
    x = diag(sqrt(sqrt(diag(d)))) * V';
    x =real(x);
    %cd 'C:\Users\Secil\Desktop\DR\deepDR-master';
    %cd C:\Users\Secil\Desktop\DR\AOPEDF-master
    writematrix(x',['Dim_32_Drug_F_Ones' num2str(keepIndex,'%g') '.txt'],'Delimiter',' ');
    %cd 'C:\Users\Secil\Desktop\Hattusha'
    %cd 'C:\Users\Secil\Desktop\DR\deepDR-master\preprocessing';