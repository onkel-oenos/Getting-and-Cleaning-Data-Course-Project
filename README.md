---
title: "README"
author: "Bob Gravestijn"
date: "22 January, 2015"
output: html_document
---
# Introduction
******
This README.md file describes the Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

This document is part of a set of documents:  

* README.md - detailed explanation about the project and the R script.
* run_analysis.R - R script code.
* tidydata.txt - tidy data output of the R script.
* CodeBook.md - snapshot of the tidy dataset.


# Project description
*******
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following. 

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 

From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Getting the dataset
******
The data of the project can be obtained by using the following R script:
```{r}
# Getting and Cleaning Data
# Coursera
# John Hopkins University

# write the file url and file destination to an object
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data.dir <- "./"
file.dest <- paste(data.dir, "getdata_projectfiles_UCI HAR Dataset.zip", sep = "")

# download from the URL (after checking whether the data directory is present)
if (!file.exists(file.dest)) {
        if (!file.exists(data.dir)) {
                dir.create(data.dir)
        }
        download.file(fileUrl, file.dest, method="curl")

        # extract the files from the zip file into the directory Data
        unzip (file.dest,exdir = data.dir)
}

# set the data dir to "UCI HAR Dataset"
data.dir <- paste(data.dir, "UCI HAR Dataset", sep = "")

# list all the files in the UCI HAR Dataset directory
list.files(data.dir, recursive = TRUE)
```
The dataset includes the following files of interest:

- 'README.txt': Shows detailed information on the dataset.
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.

# Exploring the dataset
******

## Dataset information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Check the README.txt and features_info.txt files for further details about this dataset. 

The files in the directories 'test/Inertial Signals/' and 'train/Inertial Signals/'
will be discarded as they contain the raw measurement data, while we are only interested in 
the measurements on the mean and standard deviation for each measurement. 

## Exploring the dataset
Exporing the text files shows a data table in which the columns inside the table are separated by blank characters. An example for viewing the file 'train/X_train.txt' is:

```{r}
readLines("./train/X_train.txt", n=3)
```

As a result of the above obervation(s), the data in the text files can be loaded into the workspace with the function read.table. Below an example is shown for loading of the data into workspace for the 'features.txt' file:

```{r}
setwd(data.dir)
features = read.table("features.txt")
head(features, n=3)
```
# The R script *run_analysis.R*
******
### Assumption(s)
The R script *run_analysis.R* assumes that the data was downloaded and the files are in the current working directory of R.  
The packages *dplyr* and *tidyr* are installed before running the script.  

The R script *run_analysis.R* runs well on the following configuration:  
*
RStudio Version 0.98.1091 – © 2009-2014 RStudio, Inc.  
Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/600.1.17 (KHTML, like Gecko)
*

## Introduction
The R script *run_analysis.R* supports the project instructions:

> You should create one R script called run_analysis.R that does the following. 
>
>    1. Merges the training and the test sets to create one data set.
>    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
>    3. Uses descriptive activity names to name the activities in the data set
>    4. Appropriately labels the data set with descriptive variable names. 
>    5. From the data set in step 4, creates a second, independent tidy data set with the average of
>    each variable for each activity and each subject.

## 1. Merges the training and the test sets to create one data set

### Load the data
The data in the text files can be loaded into the workspace with the function read.table.
```{r}
# read the features data
features = read.table("features.txt")
# read the class labels with their activity name
activitylabels = read.table("activity_labels.txt")

## testset
# read the subject who performed the activity for each window sample
testsubject = read.table("test/subject_test.txt")
# read the test set
testset = read.table("test/X_test.txt")
# read the test set labels (which are actually the activities)
testactivities = read.table("test/y_test.txt")

## training set
# read the subject who performed the activity for each window sample
trainingsubject = read.table("train/subject_train.txt")
# read the training set
trainingset = read.table("train/X_train.txt")
# read the training set labels (which are actually the activities)
trainingactivities = read.table("train/y_train.txt")
```
### Exploring and merging the datasets
Using the `str()`, `sum()` and `head()` functions the following can be interpreted:

* 'testset' (X_test.txt) (nrows = 2947, ncols = 561) and 'trainingset' (X_train.txt) (nrows = 7352, ncols = 561) are "the data sets"
* 'features' (features.txt) (nrows = 561, ncols = 2) names the variables/columns of 'testset' and 'trainingset'. The 1st column of 'features' is an index (1 to 561), and its 2nd column contains the names of the variables.
* 'activitylabels' (activity_labels.txt) (nrows = 6, ncols = 2) assigns a code (1 to 6) to each activity type. The 1st column is the code (1 to 6), the 2nd column is the activity (walking, sitting, etc).
* 'testactivities' (y_test.txt) (nrows = 2947, ncols = 1) labels the rows of 'testset' (X_test.txt) per activity type taking values of (1 to 6), i.e. decoded with activitylabels. Same applies to the relation trainingactivities and trainingset, i.e. y_train.txt and X_train.txt.
* 'testsubject' (subject_test.txt) (nrows = 2947, ncols = 1) labels the rows of testset per subject/volunteer, and the same applies to the relation trainingsubject and trainingset, i.e. subject_train.txt and X_train.txt.

Using the above interpretation, the training and test sets are merged using rbind() into the following variables:

* dataset is the merge of testset with trainingset;
* activities is the merge of testactivities and trainingactivities;
* subject is the merge of testsubject and trainingsubject.

```{r}
# As the two data frames have the same variables the two data frames (datasets)
# can be joined vertically using the rbind function.
dataset <- rbind(testset, trainingset)
activities <- rbind(testactivities, trainingactivities)
subject <- rbind(testsubject, trainingsubject)
```
## 2. Extract only the measurements on the mean and standard deviation for each measurement 
If one searches for the word "mean" among the column names, the result shows two type of variables:

1. calculated mean variables, indicated in the names by 'mean()' 
2. variables that were calculated using the meanFrequency, i.e. 'meanFreq()'

The "features_info.txt" file explains that the mean, 'mean()', and standard deviation, 'std()', are calculated from the following 33 signals: tBodyAcc-XYZ, tGravityAcc-XYZ, tBodyAccJerk-XYZ, tBodyGyro-XYZ, tBodyGyroJerk-XYZ, tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag, fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccMag, fBodyAccJerkMag, fBodyGyroMag and fBodyGyroJerkMag. Moreover, the file explains that the 'meanFreq()' is the weighted average of the frequency components to obtain a mean frequency, and this is used as input on other variables. As it makes no mathematical sense to take an average of meanFreq(), only variables that have 'mean()' and 'std()' present in their name are going to be of interest. As a result, 66 variables remain.

```{r}
# creating subsets of the dataset containing the containing mean or std
subsetmean <- dataset[,grepl("mean()", names(dataset), fixed = TRUE)]
subsetstd <- dataset[,grepl("std()", names(dataset))]
```

## 3. Use descriptive activity names to name the activities in the data set
To name the activities in the (sub) dataset(s), the variable 'activity', coded with values from 1 to 6, needs to be replaced by 'activity_labels'.
```{r}
# replace the numbers  by activity labels
for (i in 1:nrow(activities)){
        activities[i,1] <- activitylabels[activities[i,1],2]
}
```
Now it is possible to create one, single, dataset with escriptive activity names to name the activities in the data set
```{r}
# combine the activities, subject and subsets
data <- cbind(activities, subject, subsetmean, subsetstd)
```

## 4. Appropriately label the data set with descriptive variable names
In a few of the variable names, a mistake was discovered: the word "Body" was doubled for some of the variables (fBodyBodyAccJerkMag-mean(), fBodyBodyGyroJerkMag-mean(), etc). The first step is to to lower all names to lower case, correct this mistake and replace 'body' by 'body_'.

The other descriptive variable names are created by:

1. *gravity* is substituted by 'gravitational_'
2. *t* is substituted by 'time_';
3. *f* is substituted by 'frequency_';
4. *acc* is substituted by 'linearacceleration';
5. *mag* is substituted by '_magnitude';
6. *gyro* is substituted by 'angularvelocity';
7. *mag* is substituted by 'magnitude';
8. *f* is substituted by 'frequency';
9. *-mean()* is substituted by '_mean';
10. *-std()* is substituted by '_std'.

To avoid some clattering to conclude the following two substituations are made:

* "--" by "" and
* "__" by "_-_"

As a result, the original variable "tBodyAcc-mean()-X" transforms into ""time_body_linearacceleration_mean_x"", i.e. the variable names are now much longer (and clearer) with this format.

```{r}
# change t to time, f to frequency, the sensor signals acc to accelerometer and 
# gyro to gyroscope, mean() to mean and std() to stddev.
# remove extra dashes and BodyBody naming error from original feature names
names(data) <- tolower(names(data))
names(data) <- sub("bodybody", "body", names(data))
names(data) <- sub("body", "body_", names(data))
names(data) <- sub("gravity", "gravitational_", names(data))
names(data) <- sub("^t", "time_", names(data))
names(data) <- sub("^f", "frequency_", names(data))
names(data) <- sub("acc", "linearacceleration", names(data))
names(data) <- sub("gyro", "angularvelocity", names(data))
names(data) <- sub("mag", "magnitude", names(data))
names(data) <- sub("-mean()", "_mean_-", names(data), fixed = TRUE)
names(data) <- sub("-std()", "_stddev_-", names(data), fixed = TRUE)
names(data) <- gsub("--", "", names(data))
names(data) <- gsub("__", "_-_", names(data))
```
The data frame `data` contains both the data of the test and the trainingset as well as the activities and subject.

## 5. Create a tidy data set with the average of each variable for each activity and each subject

The actual instructions are:  

>    5. From the data set in step 4, creates a second, independent tidy data set with the average of
>    each variable for each activity and each subject.

In other words,  we need to:

1. Get the average of each variable for each activity and each subject.
2. With the resulting dataset, create a tidy dataset.

### Create a dataset with the average of each variable for each activity and each subject

To create a dataset with the average of each variable for each activity and each subject the following R code is used:
```{r}
statdata <- data %>% 
                group_by(activity, subject) %>% 
                summarise_each(funs(mean), -activity, -subject)
```
The resulting dataset `statdata` contains 80 observations (6 activities x 30 subjects) of 68 variables showing the mean value of the original columns per activity and subject. But is this dataset tidy?

Characteristics of a tidy dataset:

* Each variable forms a column.
* Each observation forms a row.
* Each type of observational unit forms a table.

If one looks at the columns, the majority of them are a combination of multiple underlying variable names. That is, the columns can be broken down by:

* a motion component: body or gravitational
* a measurement of motion:
        angularvelocity, 
        angularvelocityjerk, 
        angularvelocityjerkmagnitude,        
        angularvelocitymagnitude,
        linearacceleration,
        linearaccelerationjerk,    
        linearaccelerationjerkmagnitude or
        linearaccelerationmagnitude   
* an average statistical value: mean or stddev (standard deviation)
* a (axial) direction: x, y, or z

In other words, the dataset `statdata` violates the 3rd characteristic. 

Using this fact, it is relatively easy to obtain the tidy dataset `tidydata` using the tidyr package tooling to gather, separate and spread the dataset `statdata`. To do so, the variables names come into play. As all variable names follow strictly the same convention, it is possible to split them on the underscore character using the following R script:
```{r}
# take multiple columns and collapse into key-value pairs, duplicating 
# all other columns as needed. 
tidier1 <- tidyr::gather(messy, unit_var_stat_val, val,-one_of("activity","subject")) 
# the mulitple column string can be broken into pieces using the character "_" as a divider
tidier2 <- tidyr::separate(tidier1, unit_var_stat_val,colnames,sep = "_") 
# spread the key-value pair across multiple columns
tidydata <- tidyr::spread(tidier2, var,val)

# the above operation combined:
# tidydata <- tidy %>%
#                tidyr::gather(mezzy, unit_var_stat_val, val, -one_of("activity","subject")) >%>
#                tidyr::separate(tidier1, unit_var_stat_val,colnames,sep = "_") %>%
#                tidyr::spread(tidier2, var,val)
```

### Introduction of NA values
As the variable frequency_body_angularvelocity_mean_x,y,z or frequency_body_angularvelocity_stddev_x,y,z or does not exist, 2520 NA values are introduced in the tidy dataset `tidydata`.

## Output file tidydata.txt

The R script `run_analysis.R` writes the tidy dataset `tidydata` to the current working directory. in text format called "tidydata.txt". The tidy data consists of 7200 obervations of 8 variabels. As explained baove, some NA values are present.
```{r}
# write data to file
 write.table(tidydata,file = "./tidydata.txt", row.names = FALSE)
```
To see the dataset at a later stage, use:
```{r}
# To see the dataset at a later stage, use:
 tdata <- read.table("./tidydata.txt", header = TRUE)
 view(tdata)
```
Please consult the file *CodeBook.md* for more clarification on the technical description of the data.

# The R script run_analysis.R
```{r}
# Getting and Cleaning Data
# Coursera
# John Hopkins University

# load dplyr library
library(dplyr)

# set the data dir to "UCI HAR Dataset" in which the data files are extracted and stored
data.dir <- "./UCI HAR Dataset"
setwd(data.dir)

# read the features data
features = read.table("features.txt")
# read the class labels with their activity name
activitylabels = read.table("activity_labels.txt")

## testset
# read the subject who performed the activity for each window sample
testsubject = read.table("test/subject_test.txt")
# read the test set
testset = read.table("test/X_test.txt")
# read the test set labels (which are actually the activities)
testactivities = read.table("test/y_test.txt")

## training set
# read the subject who performed the activity for each window sample
trainingsubject = read.table("train/subject_train.txt")
# read the training set
trainingset = read.table("train/X_train.txt")
# read the training set labels (which are actually the activities)
trainingactivities = read.table("train/y_train.txt")

# create a vector with (only) the label names
labels <- features$V2
# add the vector with the label names as header to the testset and trainigset
colnames(testset) <- labels
colnames(trainingset) <- labels

## 1. Merge the training and the test sets to create one data set.

# As the two data frames have the same variables the two data frames (datasets)
# can be joined vertically using the rbind function.
dataset <- rbind(testset, trainingset)
activities <- rbind(testactivities, trainingactivities)
subject <- rbind(testsubject, trainingsubject)

names(activities) <- "activity"
names(subject) <- "subject"

## 2. Extract only the measurements on the mean and standard deviation for each measurement.

# creating subsets of the dataset containing the containing mean or std
subsetmean <- dataset[,grepl("mean()", names(dataset), fixed = TRUE)]
subsetstd <- dataset[,grepl("std()", names(dataset))]

## 3. Use descriptive activity names to name the activities in the data set

# replace the numbers  by activity labels
for (i in 1:nrow(activities)){
        activities[i,1] <- as.character(activitylabels[activities[i,1],2])
}

# combine the activities, subject and subsets
data <- cbind(activities, subject, subsetmean, subsetstd)

## Appropriately label the data set with descriptive variable names.

# change t to time, f to frequency, the sensor signals acc to accelerometer and 
# gyro to gyroscope, mean() to mean and std() to stddev.
# remove extra dashes and BodyBody naming error from original feature names
names(data) <- tolower(names(data))
names(data) <- sub("bodybody", "body", names(data))
names(data) <- sub("body", "body_", names(data))
names(data) <- sub("gravity", "gravitational_", names(data))
names(data) <- sub("^t", "time_", names(data))
names(data) <- sub("^f", "frequency_", names(data))
names(data) <- sub("acc", "linearacceleration", names(data))
names(data) <- sub("gyro", "angularvelocity", names(data))
names(data) <- sub("jerk", "jerk", names(data))
names(data) <- sub("mag", "magnitude", names(data))
names(data) <- sub("-mean()", "_mean_-", names(data), fixed = TRUE)
names(data) <- sub("-std()", "_stddev_-", names(data), fixed = TRUE)
names(data) <- gsub("--", "", names(data))
names(data) <- gsub("__", "_-_", names(data))

## From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# calculate of the descriptive statistics mean and standard deviation for 
# multiple columns, minus activity & subject
statdata <- data %>% 
                group_by(activity, subject) %>% 
                summarise_each(funs(mean), -activity, -subject)

# IF the data frame statdata is considered to contain tidy data THEN
# tidydata <- statdata
# write data to file
# write.table(tidydata,file = "./tidydata.txt", row.names = FALSE)
# to see the dataset at a later stage, use:
# tdata <- read.table("./tidydata.txt", header = TRUE)
# view(tdata)

# IF the data frame statdata is still considered to be messy data THEN
messy <- statdata 

# the columns are still a combination of multiple underlying variable names i.e.
# - motion component: body or 
#                       gravitational 
# - measurement of motion: angularvelocity, 
#                                angularvelocityjerk, 
#                                angularvelocityjerkmagnitude,        
#                                angularvelocitymagnitude,
#                                linearacceleration,
#                                linearaccelerationjerk,    
#                                linearaccelerationjerkmagnitude or
#                                linearaccelerationmagnitude   
# - average statistical value: mean or 
#                                stddev (standard deviation)
# - (axial) direction: x, 
#                        y, or 
#                        z
colnames <- c("var", "motion component", "measurement of motion", "average statistical value", "(axial) direction")

# take multiple columns and collapse into key-value pairs, duplicating 
# all other columns as needed. 
tidier1 <- tidyr::gather(messy, unit_var_stat_val, val,-one_of("activity","subject")) 
# the mulitple column string can be broken into pieces using the character "_" as a divider
tidier2 <- tidyr::separate(tidier1, unit_var_stat_val,colnames,sep = "_") 
# spread the key-value pair across multiple columns
tidydata <- tidyr::spread(tidier2, var,val)

# the above operation combined:
# tidydata <- tidy 5>%
#                tidyr::gather(mezzy, unit_var_stat_val, val,
#                              -one_of("activity","subject")) >%>
#                tidyr::separate(tidier1, unit_var_stat_val,colnames,sep = "_") %>%
#                tidyr::spread(tidier2, var,val)

# write data to file
 write.table(tidydata,file = "./tidydata.txt", row.names = FALSE)
# to see the dataset at a later stage, use:
# tdata <- read.table("./tidydata.txt", header = TRUE)
# view(tdata)
```