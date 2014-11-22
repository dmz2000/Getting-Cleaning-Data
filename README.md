# Course Project Submission README

This submission contains the following files
* run_analysis.R
  - contains the code for cleaning and manipulating the data
* tidy_means.txt
  - contains the final tidy data set for submission
* CodeBook.md
  - contains a description of the variable names in the tidy_mean.txt

### Description of run_analysis.R

In the original data set, key information is scattered in various files across training and testing groups. The purpose of the analysis is to derive a tidy dataset that has the appropriate variable and activity labeling, and with the mean computed for each subject and activity.

The analysis is conducted in the following steps:
- reading in all the training and testing data sets and relevant labels
- merging the testing and training data sets into one large data set
- appending the appropriate variable names and activity labels
- filtering to include only columns that contain the mean or standard deviation of measures
- relabeling some of the column names to be more descriptive
- for each subject and activity, compute the mean of the measures



