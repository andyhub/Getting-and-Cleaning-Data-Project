library(data.table)
library(dplyr)

featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
featuresMerged <- rbind(featuresTest, featuresTrain)
featureNames <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
colnames(featuresMerged) <- t(featureNames[2])
filteredColumns <- c(grep(".*Mean.*|.*Std.*", names(featuresMerged), ignore.case=TRUE))
featuresMerged <- featuresMerged[,filteredColumns]

activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
activityMerged <- rbind(activityTest, activityTrain)
colnames(activityMerged) <- "Activity"
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
activityMerged$Activity <- as.character(activityMerged$Activity)
for (i in 1:6){
    activityMerged$Activity[activityMerged$Activity == i] <- as.character(activityLabels[i,2])
}

subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjectMerged <- rbind(subjectTest, subjectTrain)
colnames(subjectMerged) <- "Subject"
subjectMerged$Subject <- as.factor(subjectMerged$Subject)

filteredData <- cbind(featuresMerged, activityMerged, subjectMerged)

names(filteredData)<-gsub("Acc", "Accelerometer", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("Gyro", "Gyroscope", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("BodyBody", "Body", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("Mag", "Magnitude", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("^t", "Time", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("^f", "Frequency", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("tBody", "TimeBody", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("-mean()", "Mean", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("-std()", "STD", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("-freq()", "Frequency", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("angle", "Angle", names(filteredData), ignore.case = TRUE)
names(filteredData)<-gsub("gravity", "Gravity", names(filteredData), ignore.case = TRUE)

filteredData <- data.table(filteredData)

tidyData <- aggregate(. ~Subject + Activity, filteredData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)