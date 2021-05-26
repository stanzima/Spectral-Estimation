function [avg, maxi, mini] = getColourDiff(ref_test, ref_est, illuminant, cmf)

%   This function calculates colour difference using Delta E2000 and
%   returns average, maximum and minimum colour difference.
%   Colour difference function used here is from Colour Engineering toolbox developed by Phil Green 
%
%   Example:
%   [avg, maxi, mini] = getColourDiff(ref_test, ref_est, illuminant, cmf)
%
%   
%   author:          © Tanzima Habib
%   version:         1.1
%   date:  	         1-05-2021
%########################################################################################################################################################
%ref_test = test reflectance, ref_est= estimated reflectance,
%illuminant = illuminant D50, cmf = CIE 1931 2 degree observer
%########################################################################################################################################################

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate white point
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = 100 / sum(cmf(:,2).*illuminant);
    wp = k .* cmf' * illuminant;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate tristimulus values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    k = 100 / sum(cmf(:,2).*illuminant);
    xyz_est = (k .* cmf' * diag(illuminant) * ref_est');
    xyz_test = (k .* cmf' * diag(illuminant) * ref_test');
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate colour difference
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    lab1 = xyz2lab(xyz_est', 'whitepoint',wp');
    lab2 = xyz2lab(xyz_test', 'whitepoint',wp');
    addpath('Codes_from_Phil_Green');
    cd = ciede2000(lab1,lab2); %Colour difference function used is from Colour Engineering toolbox developed by Phil Green 
    rmpath('Codes_from_Phil_Green');
    avg = mean(cd); %average colour difference
    maxi = prctile(cd,95); %maximum colour difference
    mini = min(cd);  %minimum colour difference

end
