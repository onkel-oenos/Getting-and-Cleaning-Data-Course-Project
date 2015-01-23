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