#   This script details the tidying of the UCI HAR datasets
#   The result will be a series of steps for merging and tidying the data an an independent tidy
#   dataset that will will contain the average measurement for each activity for each subject

#   The script is accompanied by a Code Book that details the codes for the different factor levels and a ReadMe
#   that discusses the assignment and the approaches I've taken.

#   Step one import data sets and create one large tidy data set

#   Get column names for measurements, keep first column for dummy variable for merge
features <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/features.txt", quote="\"", comment.char="")

#   Measurements
test_measurements <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
#   put correct column names on measurements
colnames(test_measurements) <-features[,2]
#   Add dummy variable
dummy <-1:2947
test_measurements <-cbind(dummy, test_measurements) 

#   Subject ID
ID_test <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
#   Label ID vector
colnames(ID_test) <-c("ID") 
#   Add dummy column for merge
ID_test <-cbind(dummy, ID_test)

#   Activity vector
Activity <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
#   Label Activity vector
colnames(Activity) <-c("activity")
#   Add dummy column for merge
Activity <- cbind(dummy, Activity)

#   make complete test data set with cbind, ID, Activity, test_measurments
#   *****merge only does two at a time ******
 testrun <- merge(ID_test, Activity, by = "dummy", all=TRUE)
 finaltest <-merge(testrun, test_measurements, by = "dummy", all= TRUE)

#   Now for trial data, no need to change merge column
#   dummy for merging the training data
newdm <- 1:7352
 
#   Subject ID
ID_train <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
#   Label ID
colnames(ID_train) <-c("ID")
ID_train <-cbind(newdm, ID_train)

#   Activity
Activity <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
colnames(Activity) <-c("activity")
Activity<-cbind(newdm, Activity)

#   Training Measurements
train_measurements <- read.table("~/Data Science Course/Data Sets/TIdyDataProject/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
#   Add columnnames
colnames(train_measurements) <-features[,2]
train_measurements <-cbind(newdm, train_measurements)

# merging ID and activity
trainrun <- merge(ID_train, Activity, by = "newdm", all = TRUE)
finaltrain <- merge(trainrun, train_measurements, by = "newdm", all = TRUE)

#   removing the dummy columns
finaltrain$newdm <- NULL
finaltest$dummy <- NULL

#   combining the two
UCImeasurements <- rbind(finaltest, finaltrain)


# Step two, extracting the mean and std 

# extraction just the body data
MeanMeasB <-data.frame(UCImeasurements[,1:2], UCImeasurements[ , grepl( "tBodyAcc. *mean()" , names(UCImeasurements) ) ])
STDMeasB <-data.frame(UCImeasurements[,1:2], UCImeasurements[ ,grepl( "tBodyAcc. *std()", names(UCImeasurements) )])

#   merge 
#   dummy variable for merge
lastdum <- 1:10299
MeanMeasB <-cbind(lastdum, MeanMeasB)
STDMeasB <-cbind(lastdum, STDMeasB)

# merge data frames to one with ID, Activity, means and standard deviations
MSTD_MeasB <- merge(MeanMeasB, STDMeasB, by = "lastdum", all = TRUE)
# tidy up data frame
colnames(MSTD_MeasB)[2] <- c("ID")
colnames(MSTD_MeasB)[3] <- c("activity")
MSTD_MeasB$lastdum <- NULL
MSTD_MeasB$ID.y <- NULL
MSTD_MeasB$activity.y <- NULL

#   Step 3 Appropriately label the activities.
MSTD_MeasB$activity<- sub("1", "Walking", MSTD_MeasB$activity)
MSTD_MeasB$activity<- sub("2", "Walking_Upstairs", MSTD_MeasB$activity)
MSTD_MeasB$activity<- sub("3", "Walking_Downstairs", MSTD_MeasB$activity)
MSTD_MeasB$activity<- sub("4", "Sitting", MSTD_MeasB$activity)
MSTD_MeasB$activity<- sub("5", "Standing", MSTD_MeasB$activity)
MSTD_MeasB$activity<- sub("6", "Lying_Down", MSTD_MeasB$activity)
# The reason I substituted Lying_Down for Laying has to do with the transitive quality of the latter, which is a grammar
# issue that bugged me enough to correct.


#    Step 4 Appropriately labels the data set with descriptive variable names.
#   extract list of column names for means and std data frame
#   expanded explanations of the names is part of the COdeBook
#   find way to clean up the variable names

#   first remove the extraneous . . . 
pattern <- c("\\.\\.\\.")
names(MSTD_MeasB) <- gsub(pattern, "", names(MSTD_MeasB))
names(MSTD_MeasB)
#   remove the sole .
pattern <- c("\\.")
names(MSTD_MeasB) <- gsub(pattern, "_", names(MSTD_MeasB))

# extracting  the gravity data
MeanMeasG <-data.frame(UCImeasurements[,1:2], UCImeasurements[ , grepl( "tGravityAcc. *mean()" , names(UCImeasurements) ) ])
STDMeasG <-data.frame(UCImeasurements[,1:2], UCImeasurements[ ,grepl( "tGravityAcc. *std()", names(UCImeasurements) )])

#   merge 
#   dummy variable for merge
lastdum <- 1:10299
MeanMeasG <-cbind(lastdum, MeanMeasG)
STDMeasG <-cbind(lastdum, STDMeasG)

# merge data frames to one with ID, Activity, means and standard deviations
MSTD_MeasG <- merge(MeanMeasG, STDMeasG, by = "lastdum", all = TRUE)
# tidy up data frame
colnames(MSTD_MeasG)[2] <- c("ID")
colnames(MSTD_MeasG)[3] <- c("activity")
MSTD_MeasG$lastdum <- NULL
MSTD_MeasG$ID.y <- NULL
MSTD_MeasG$activity.y <- NULL

#   Step 3 Appropriately label the activities.
MSTD_MeasG$activity<- sub("1", "Walking", MSTD_MeasG$activity)
MSTD_MeasG$activity<- sub("2", "Walking_Upstairs", MSTD_MeasG$activity)
MSTD_MeasG$activity<- sub("3", "Walking_Downstairs", MSTD_MeasG$activity)
MSTD_MeasG$activity<- sub("4", "Sitting", MSTD_MeasG$activity)
MSTD_MeasG$activity<- sub("5", "Standing", MSTD_MeasG$activity)
MSTD_MeasG$activity<- sub("6", "Lying_Down", MSTD_MeasG$activity)
# see Above


#   first remove the extraneous . . . 
pattern <- c("\\.\\.\\.")
names(MSTD_MeasG) <- gsub(pattern, "", names(MSTD_MeasG))
names(MSTD_MeasG)
#   remove the sole .
pattern <- c("\\.")
names(MSTD_MeasG) <- gsub(pattern, "_", names(MSTD_MeasG))

#    final merge
fdum <- 1:10299
MSTD_MeasB <- cbind(fdum, MSTD_MeasB)
MSTD_MeasG <- cbind(fdum, MSTD_MeasG)
New_BG <- merge(MSTD_MeasB, MSTD_MeasG, by = "fdum", all = TRUE)

#    tidy var names
colnames(New_BG)[2] <- c("ID")
colnames(New_BG)[3] <- c("activity")
New_BG$fdum <- NULL
New_BG$ID.y <- NULL
New_BG$activity.y <- NULL
pattern <- c("^t")
names(New_BG) <- gsub(pattern, "Time_", names(New_BG))

#   more name cleaning
pattern <- c("X")
names(New_BG) <- gsub(pattern, "_XAxis", names(New_BG))
pattern <- c("Y")
names(New_BG) <- gsub(pattern, "_YAxis", names(New_BG))
pattern <- c("Z")
names(New_BG) <- gsub(pattern, "_ZAxis", names(New_BG))


#   Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# this sounds like a group by dplyr sort of thing.

library(dplyr)
# remember syntax!!
bodyout <- New_BG %>%
  mutate(ID=as.factor(ID)) %>% 
  group_by(ID,activity) %>%
  summarise_all(mean) %>%
  as.data.frame
 
write.table(bodyout, "summarybody.txt", sep=",", row.names = FALSE)
