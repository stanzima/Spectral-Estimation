# Spectral-Estimation
Spectral Estimation from colorimetry using Weighted Pseudo Inverse method

Use main.m to do spectral estimation using the default reference reflectance database 'FOGRA51'. The code divides the reference database into training sets and test sets using K cross validation. The test tristimulus values are calculated using the test reflectance, illuminant D50 and CIE 1931 two degree observer. It applies weighted pseudo inverse method (wpseudoInv.m) for spectral estmation from test tristumulus values using the training reflectance set. It also calculates the colour difference between the test tristimulus values and the tristimulus values obtained from the estimated spectra, illuminant D50 and CIE 1931 two degree observer and the root mean square difference between the test spectra and estimated spectra.

Use wpseudoInv.m code with input test tristimulus values, training reflectance dataset, illuminant and colour matching functions to obtain estimated spectra from test tristimulus values. The rows of the input training reflectance dataset,  illuminant and colour matching function matrices should be the wavelengths and the rows of the test tristimulus values matrix have to be the tristimulus co-ordintes. If training reflectance, illuminant and colour matching functions are not supplied then default data will be used.
