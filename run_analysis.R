
install.packages("reshape"); library(reshape)
require(reshape2)
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Load activity labels 
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
## Load features - column names
features <- read.table("./UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## Extract only the column names containing mean and standard deviation values
featuresSelect <- grep(".*mean.*|.*std.*", features[,2])
featuresSelect.names <- features[featuresSelect,2]
featuresSelect.names = gsub('-mean', 'Mean', featuresSelect.names)
featuresSelect.names = gsub('-std', 'Std', featuresSelect.names)
featuresSelect.names <- gsub('[-()]', '', featuresSelect.names)

## Load the data sets using selected columns
train <- read.table("./UCI HAR Dataset/train/X_train.txt")[featuresSelect]
trainActivities <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_set <- cbind(trainSubjects, trainActivities, train)
test <- read.table("./UCI HAR Dataset/test/X_test.txt")[featuresSelect]
testActivities <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_set<- cbind(testSubjects, testActivities, test)

## combine data sets 
combined <- rbind(train_set, test_set)
colnames(combined) <- c("subject", "activity", featuresSelect.names)

## transform activities & subjects into factors
combined$activity <- factor(combined$activity, levels = activityLabels[,1], labels = activityLabels[,2])
combined$subject <- as.factor(combined$subject)
combined.melted <- melt(combined, id = c("subject", "activity"))
combined.mean <- dcast(combined.melted, subject + activity ~ variable, mean)

## Write the tidy data set
write.table(combined.mean, "tidy.txt", row.names=FALSE, quote=FALSE)













