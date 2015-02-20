# Cleaning and screening data
# Course project

require("plyr")
library(plyr)

# Create clear workspace
rm(list = ls())

# Download and unzip datafile
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ","Dataset.zip", mode="wb")
unzip("Dataset.zip")

# Reading in the variable and activity labels datasets
features <- read.table("UCI HAR Dataset/features.txt")
activity_n <- read.table("UCI HAR Dataset/activity_labels.txt")

# Reading in test dataset components
ids_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

# Labelling and combining full test dataset

names(x_test) <- features$V2
names(ids_test) <- "id"
names(y_test) <- "activity"
test <- cbind(ids_test, y_test, x_test)
rm(list = c('ids_test','x_test','y_test'))

test <- arrange(test, activity)
test$activity <- factor(test$activity, labels = activity_n$V2)

# Reading in training dataset components
ids_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

# Labelling and combining full test dataset

names(x_train) <- features$V2
names(ids_train) <- "id"
names(y_train) <- "activity"
train <- cbind(ids_train, y_train, x_train)
rm(list = c('ids_train','x_train','y_train'))

train <- arrange(train, activity)
train$activity <- factor(train$activity, labels = activity_n$V2)

# Merge the test and training data into one dataset
unsum_data <- rbind(test, train)
rm(list = c('test','train'))

# Extract subset of data containing means and standard deviations
mean_sd <- as.character(features$V2[(grepl("mean", features$V2) & !grepl("Freq", features$V2)) | (grepl("std", features$V2))])
mean_sd <- c("id", "activity", mean_sd)
unsum_data <- unsum_data[ , mean_sd]
rm(list = c('activity_n','features','mean_sd'))
  
# Create summary data set
sum_data <- ddply(unsum_data, .(id, activity), numcolwise(mean))