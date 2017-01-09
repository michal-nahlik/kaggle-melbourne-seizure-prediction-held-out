Description
-----------
This is code used for [Melbourne University AES/MathWorks/NIH Seizure Prediction](https://www.kaggle.com/c/melbourne-university-seizure-prediction) 2016. My solution ended **8th on the private leaderboard** and it is based on **Classification decision trees** with **0.80396 AUC** on public leaderboard and **0.79074 AUC** on private leaderboard.

Software
--------
Matlab 2014a
Used toolboxes: Statistics Toolbox, Signal Toolbox, Wavelet Toolbox

Features
--------
Features were calculated on the whole 10 minute files for each channel without splitting into any shorter epochs. 

I basically took all the features from sample submission script and added few more based on my hunch and some articles about this topic. The features included:

-	mean value, standard deviation, skewness, kurtosis, spectral edge, Shannon’s entropy (for signal and Dyads), Hjorth parameters, several types of fractal dimensions
-	singular values of 10 scale wavelet transformation using Morlet wave
-	maximum correlation between channels in interval -0.5,+0.5 seconds, correlation between channels in frequency domains, correlation between channels power spectrums at each dyadic level

I had 73 features in total for each channel, only the real part of features was used.

Cross validation
----------------
I used *cvpartition* from Statistical toolbox which can create random partitions where each subsample has equal size and roughly the same class proportions. I did not care about sequences which caused my local AUC results to be around 0.1 higher than the leaderboard ones.

Model
-----
A classification decision tree model was created for each channel and patient, the mean output across channels for the patient was used as the outcome. Models were trained with 10 fold cross validation to prevent overfitting.
Because we had only 2 classes the *Exact* training algorithm was used (see Matlab documentation for *fitctree* for more details).

Training models and generating output for each patient took in all cases under one minute. For training I used all data files marked as safe in *train_and_test_data_labels_safe.csv*. No preprocessing was done.

The most important predictors across all decision trees were: correlation between channel power spectrums at dyadic levels, spectral edge, Shannon’s entropy for Dyads, mean value and 3rd estimate of fractional Brownian motion.

File structure description
------------------
- **/features** - code to calculate features
- **/main** - functions to run the models 
- **/model** - helper functions for working with models
- **/util** - functions for loading data, setting environment, creating submission ...
- **settings.m** - file containing basic settings including data paths
- **models.zip** - archive containing pretrained models for each subject and channels which can be loaded and used to create submission with */main/run_trained_dt.m* 

Instructions
------------
 **Held-out evaluation**

 1. Unpack the models from **models.zip** to a folder
 2. Change file/folder paths in **settings.m** for data,models,features and submission file
 3. Set whether the features are supposed to be saved to disk or not
 4. Run the **/main/run_trained_dt.m** script which will load/generate features for each subject, load trained models and create submission