%   This is an example code to use Weighted Pseudo Inverse method for
%   spectral estimation. In this code the default reference reflectance
%   database is used and it is divided into test sets and training sets
%   using K cross validation. Running this code will calculate the estimated 
%   spectra, the mean colour difference and the mean root mean square difference
%   of each test set.  
%   
%   author:          © Tanzima Habib
%   version:         1.1
%   date:  	         1-05-2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracting reflectances from spectral data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Default reference data file:  fogra51_cmyk_380_730_10nm.mat 
% Default wavelength is the range of the reference reflectance database :380nm to 730nm in steps of 10nm
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prerequisites:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

d50 = [24.4880000000000;29.8710000000000;49.3080000000000;56.5130000000000;60.0340000000000;57.8180000000000;74.8250000000000;87.2470000000000;90.6120000000000;91.3680000000000;95.1090000000000;91.9630000000000;95.7240000000000;96.6130000000000;97.1290000000000;102.099000000000;100.755000000000;102.317000000000;100;97.7350000000000;98.9180000000000;93.4990000000000;97.6880000000000;99.2690000000000;99.0420000000000;95.7220000000000;98.8570000000000;95.6670000000000;98.1900000000000;103.003000000000;99.1330000000000;87.3810000000000;91.6040000000000;92.8890000000000;76.8540000000000;86.5110000000000];
twoDegObs = [0.00136800000000000,3.90000000000000e-05,0.00645000100000000;0.00424300000000000,0.000120000000000000,0.0200500100000000;0.0143100000000000,0.000396000000000000,0.0678500100000000;0.0435100000000000,0.00121000000000000,0.207400000000000;0.134380000000000,0.00400000000000000,0.645600000000000;0.283900000000000,0.0116000000000000,1.38560000000000;0.348280000000000,0.0230000000000000,1.74706000000000;0.336200000000000,0.0380000000000000,1.77211000000000;0.290800000000000,0.0600000000000000,1.66920000000000;0.195360000000000,0.0909800000000000,1.28764000000000;0.0956400000000000,0.139020000000000,0.812950100000000;0.0320100000000000,0.208020000000000,0.465180000000000;0.00490000000000000,0.323000000000000,0.272000000000000;0.00930000000000000,0.503000000000000,0.158200000000000;0.0632700000000000,0.710000000000000,0.0782499900000000;0.165500000000000,0.862000000000000,0.0421600000000000;0.290400000000000,0.954000000000000,0.0203000000000000;0.433449900000000,0.994950100000000,0.00874999900000000;0.594500000000000,0.995000000000000,0.00390000000000000;0.762100000000000,0.952000000000000,0.00210000000000000;0.916300000000000,0.870000000000000,0.00165000100000000;1.02630000000000,0.757000000000000,0.00110000000000000;1.06220000000000,0.631000000000000,0.000800000000000000;1.00260000000000,0.503000000000000,0.000340000000000000;0.854449900000000,0.381000000000000,0.000190000000000000;0.642400000000000,0.265000000000000,5.00000000000000e-05;0.447900000000000,0.175000000000000,2.00000000000000e-05;0.283500000000000,0.107000000000000,0;0.164900000000000,0.0610000000000000,0;0.0874000000000000,0.0320000000000000,0;0.0467700000000000,0.0170000000000000,0;0.0227000000000000,0.00821000000000000,0;0.0113591600000000,0.00410200000000000,0;0.00579034600000000,0.00209100000000000,0;0.00289932700000000,0.00104700000000000,0;0.00143997100000000,0.000520000000000000,0];
fname = "fogra51_380_730_10nm"; %set reference reflectance data mat file
K =5; %Set cross validation set number

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set output variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

estimated_spectra = [];% Stores estimated spectra of each test set
wpseudoInv_res = zeros(K,4);% Stores Average Colour Difference, Max Colour Difference, Min Colour Diference, RMSD of each test sets

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathname = 'reflectance_database\';

file = load(strcat(pathname, fname,'.mat'), fname);
reflectances = file.(fname);
[sno,range] = size(reflectances);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare reflectance sets for K-cross validation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = 1/K;
l = (0.001:0.01:1);
S = round(P*sno);
index = randperm(sno);
   
% Create the tests sets
 division = {reflectances(index(1:S),:);reflectances(index(S+1:2*S),:);reflectances(index(2*S+1:3*S),:);reflectances(index(3*S+1:4*S),:); reflectances(index(4*S+1:end),:)};
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spectral estmation main 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:5
    test =  division{i};
    elem = (1:5);
    elem(i) = []; 
    training = [division{elem(1)};division{elem(2)};division{elem(3)};division{elem(4)}];
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Creatte the tristimulus values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = 100 / sum(cmf(:,2).*illuminant);
    xyz_ts = (k .* cmf' * diag(illuminant) * test');
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % APPLY THE SPECTRAL ESTIMATION METHOD
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    ref_wpseudoInv = wpseudoInv(test, training, illuminant, cmf);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate Colour Difference Delta E2000
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [avg, maxi, mini] = getColourDiff(test, ref_wpseudoInv, illuminant,cmf);
    wpseudoInv_res(i,1) = avg;
    wpseudoInv_res(i,2) = maxi; 
    wpseudoInv_res(i,3) = mini;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate RMSD
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    rmsd = rootMeanSquareDifference(test, ref_wpseudoInv);
    wpseudoInv_res(i,4) = rmsd;
    figure(i);
    for k = 1:size(test,1)
        plot(test(k,:),'linewidth',2); hold on;
        plot(ref_wpseudoInv(k,:),'k--','linewidth',1.5); hold on;
        xticklabels([(380:50:780)])
        ylim([0 1.2])
        ylabel('Reflectance factor')
        xlabel('Wavelength')
    end
    title(strcat('Result of Test set with K=',num2str(i),' and RMSD=',num2str(rmsd)));
    hold off;
    
    estimated_spectra   = [estimated_spectra; ref_wpseudoInv];
end
