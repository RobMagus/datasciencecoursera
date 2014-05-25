#run_analysis.R
#cleans UCI accelerometer machine learning data
library(reshape2)

#read in necessary datasets
train.raw <- scan('UCI HAR Dataset/train/X_train.txt') #quicker and less problems than read.table
train.m <- matrix(train.raw,ncol=561) #format with correct num of cols
train.labels <- scan('UCI HAR Dataset/train/y_train.txt')
train.subjects <- scan('UCI HAR Dataset/train/subject_train.txt')

test.raw <- scan('UCI HAR Dataset/test/X_test.txt') #quicker and less problems than read.table
test.m <- matrix(test.raw,ncol=561) #format with correct num of cols
test.labels <- scan('UCI HAR Dataset/test/y_test.txt')
test.subjects <- scan('UCI HAR Dataset/test/subject_test.txt')

features <- read.table('UCI HAR Dataset/features.txt')
activity.dict <- read.table('UCI HAR Dataset/activity_labels.txt')

#make dataframes
train <- data.frame(train.m)
colnames(train) <- features$V2 #give the variables the correct names
train$label <- train.labels
train$subject <- train.subjects

test <- data.frame(test.m)
colnames(test) <- features$V2 #give the variables the correct names
test$label <- test.labels
test$subject <- test.subjects

#merge training and test
accel <- rbind(train,test)

# name activies and label data well
accel$activity <- gsub('1',activity.dict$V2[1],as.character(accel$label))
for (i in 2:6) {
    accel$activity <- gsub(as.character(i),activity.dict$V2[i],accel$activity)
}

#extract mean and sd
#which features are mean or std?
features.stats <- features[(grepl('mean\\(\\)',features$V2) | grepl('std\\(\\)',features$V2)),]

#subset accel data with the mean & std cols, and subject & activity
accel.stats <- accel[c(as.character(features.stats$V2),'subject','activity')]

#clean the names; remove '()' and '-', cap mean and std for camelCase
features.stats$V2 <- gsub('\\(\\)','',features.stats$V2)
features.stats$V2 <- gsub('-','',features.stats$V2)
features.stats$V2 <- gsub('mean','Mean',features.stats$V2)
features.stats$V2 <- gsub('std','Std',features.stats$V2)

colnames(accel.stats) <- c(as.character(features.stats$V2),'subject','activity')

# get average of each variable for each activity & subject
#construct a dataset out of it
accel.stats.melt <- melt(accel.stats, id=c('subject','activity'))
accel.tidy <- dcast(accel.stats.melt, subject+activity~variable, fun.aggregate=mean)

#output this new dataset
write.csv(accel.tidy,'accel_tidy.txt',eol='\r\n')