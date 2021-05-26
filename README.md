# Spectral-Estimation
Spectral Estimation from colorimetry using Weighted Pseudo Inverse method

Use wpseudoInv.m code with input test tristimulus values, training reflectance dataset, illuminant and colour matching functions to obtain estimated spectra from test tristimulus values. The rows of the input training reflectance dataset,  illuminant and colour matching function matrices should be the wavelengths and the rows of the test tristimulus values matrix have to be the tristimulus co-ordintes. If training reflectance, illuminant and colour matching functions are not supplied then default data will be used. 

S= wpseudoInv(test, training, illuminant, cmf) #Call wpseudoInv() as shown in your code to perform spectral estimation. test = test tristimulus vales, training = spectral data for training, default is FOGRA51 spectral reflectance dataset, illuminant = illuminant to be used, default is illuminant D50 and cmf = colour  matching function to be use, default is 1931 2 degree observer.   

FOGRA51 Spectral Reflectance Dataset: FOGRA51 spectral data is the default training dataset. The spectral range is 380nm to 730nm in steps of 10 nm. The spectral data text file can be downloaded from https://www.color.org/chardata/fogra51.xalter . We use 'reflectance_database/fogra51_380_730_10nm.mat' here which contains the spectral reflectance data extracted from the spectral textfile. In this mat file, the matrix 'fogra51_380_730_10nm' contains the spectral reflectance columnwise.  

Use main.m to do spectral estimation using the default reference reflectance database 'FOGRA51'. This is an example code that divides the reference database into training sets and test sets using K cross validation. The test tristimulus values are calculated using the test reflectance, illuminant D50 and CIE 1931 two degree observer. It applies weighted pseudo inverse method (wpseudoInv.m) for spectral estmation from test tristumulus values using the training reflectance set. It also calculates the colour difference between the test tristimulus values and the tristimulus values obtained from the estimated spectra, illuminant D50 and CIE 1931 two degree observer and the root mean square difference between the test spectra and estimated spectra.

Steps to use the main code:

1. Download ZIP as 'Spectral Estimation-main' on to the disk.
2. Unzip 'Spectral Estimation-main'
3. Open main.m stored inside the folder ''Spectral Estimation-main' using MATLAB
4. Run main.m
5. Metric results are stored in variable 'wpseudoInv_res'. Each row contains the results (Average color difference, 95 percentile colour differnec, minimum colour difference and rmse) of a test set. 
6. Variable 'estimated_spectra' stores estimate spectra of each test set
7. Variable 'testsets' stores the reference spectra of test each set.


