## Data cleaning for UCI Smartphone Accelerometer Human Activity Recognition data set

The data was downloaded from [a coursera dropbox](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) on Monday, June 19, 2014.

**if you are looking for a codebook, I decided that the 'features_info.txt' that comes with the data is a sufficient description**

The data comes in several disconnected chunks that need to be put together. It includes:

1. Training set  
 * ~7000 observations of 561 variables
 * subject id of each observation
 * activity code of each observation
2. Test set  
 * ~2000 observations of 561 variables
 * subject id of each observation
 * activity code of each observation
3. Variable names  
4. Dictionary mapping activity code to the activity  

Every piece is read in. The observations are given column names from the 'Variable names' piece, and columns are added for subject ids and activity codes.  
The train and test sets are now complete dataframes, and they are pasted together with rbind to create a full dataset, 'accel'.

The activity code dictionary is used to loop through the column of activity codes and replace them with human-readable activity names.

Grep is used to find each instance of 'mean()' and 'sd()' in the list of variable names in order to determine which column numbers correspond to variables reporting those statistics.  
This method ignores variables which report 'meanFreq', which is not strictly an average value but a weighted average of frequencies from a fourier transform.  
The column number of the appropriate variables is used to subset the full accel data.

The variable names in the accel subset are cleaned using gsub to remove '()' and '-', as well as capitalize mean and std, in order to conform to camelCase (an acceptable naming format according to [the R Style Guide](https://google-styleguide.googlecode.com/svn/trunk/Rguide.xml).

The cleaned accel subset is melted down with subject and activity as grouping variables and cast to get the mean of each variable for each combination of subject and activity. This tidy dataset is written to the working directory.
