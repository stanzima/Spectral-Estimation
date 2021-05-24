%   This function calculates root mean square difference(rmsd) between the test spectra and the estimated spectra and
%   returns rmsd.
%
%   Example:
%   RMSD = rootMeanSquareDifference(R_test, R_est)
%
%   
%   author:          © Tanzima Habib
%   version:         1.1
%   date:  	         1-05-2021
%########################################################################################################################################################
%ref_test = test reflectance, ref_est= estimated reflectance,
%########################################################################################################################################################

function RMSD = rootMeanSquareDifference(R_test, R_est)

    RMSD= mean(sqrt(mean((R_test - R_est).^2,2)));

end
