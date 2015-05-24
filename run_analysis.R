# Coursera
# Getting and Cleaning Data
# Project
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each
#    variable for each activity and each subject.

library("dplyr")

## Load datasets and features' names

X_train  <- read.table("train/X_train.txt", quote="\"")
X_test   <- read.table("test/X_test.txt", quote="\"")
features <- read.table("features.txt", quote="\"", stringsAsFactors=FALSE)

## Renaming

names(X_train) <- features$V2
names(X_test)  <- features$V2

# Merge the training and the test sets to create one data set

data <- rbind(X_train,X_test)
names(data) <- tolower(names(data))

# Extract only the measurements on the mean and standard deviation for each measurement

measMean <- grep("(mean)", names(data))
measStd <- grep("(std)", names(data))
ind  <- sort(c(measMean,measStd))

# Second data frame

data <- data[,ind]

# Load activities

y_train <- read.table("train/y_train.txt", quote="\"")
y_test  <- read.table("test/y_test.txt", ,quote="\"")

activities <- rbind(y_train,y_test)
activities <- factor(activities[,1])
activity_labels <- read.table("activity_labels.txt", quote="\"")

levels(activities) <- tolower(activity_labels$V2)

# Label the data set with descriptive variable names

data<-cbind(data,activities)

# Load subject indices

subject_train <- read.table("train/subject_train.txt", quote="\"")
subject_test  <- read.table("test/subject_test.txt", quote="\"")

subject <- c(subject_train$V1, subject_test$V1)
subject <- factor(subject)

data <- cbind(data,subject) 

## Final tidy data frame

tidy.data <- data %>% 
    group_by(subject,activities) %>% 
    summarise_each(funs(mean))

write.table(tidy.data, 
            file = "tidyData.txt", 
            row.name=FALSE)
