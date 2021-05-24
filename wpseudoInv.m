%   This function applies weighted pseudo inverse method for spectral estimation from colorimetry and returns estimated spectra
%
%   Example:
%   S = wpseudoInv(training, test, illuminant, cmf)
%
%   Spectral Estimation using Weighted Pseudo Inverse method (Reference Paper: Babaei, V., Amirshahi, S.H. and Agahian, F., 2011. Using weighted pseudo?inverse method 
                                                             ...for reconstruction of reflectance spectra and analyzing the dataset in terms of normality. Color Research & Application, 36(4), pp.295-305.)
%   author:          © Tanzima Habib
%   version:         1.1
%   date:  	         1-05-2021
%########################################################################################################################################################
% S = estimated spectra, training=training reflectances ,  test = test tristimulus values
% illuminant = illuminant D50, cmf = CIE 1931 2 degree observer
%########################################################################################################################################################
% Note: Training reflectance, cmf and illuminant matrices should have rows
% as wavelength and xyz_ts matrix should have rows as three tristimulus co-ordinates
%########################################################################################################################################################

function S = wpseudoInv(training, test, illuminant, cmf)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate white point
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = 100 / sum(cmf(2,:).*illuminant);
    wp = k .* cmf * illuminant';

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the reference tristimulus values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = 100 / sum(cmf(2,:).*illuminant);
    xyz_tr = (k .* cmf * diag(illuminant) * training);
    
    S = zeros(size(training,1),size(test,2));
    for i = 1: size(test,2)
         T = test(:,i);
         lab1 = xyz2lab(xyz_tr', 'whitepoint',wp');
         lab2 = xyz2lab(T', 'whitepoint',wp');
         w_xyz = sum((lab1 - lab2).^2,2); %calculate Delta Ea*b* (Lab colour difference)
         e = 0.00001;
         w_xyz = 1./(w_xyz+e); %handle division by 0 by adding e 
         w_xyz = w_xyz/max(w_xyz); %normalize
         w = diag(w_xyz);
         M = (training*w)*pinv(xyz_tr*w); %transformation matrix
         S(:,i) = M*T; %estimated spectra
    end
    S = S';
    
end