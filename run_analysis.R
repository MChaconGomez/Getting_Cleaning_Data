###################################################################
###################################################################
# 1- Merges the training and the test sets to create one data set.
###################################################################
###################################################################

library(dplyr)
library(plyr)

# read the train and test data
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create x_data and y_data
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

# create subject
subject_data <- rbind(subject_train, subject_test)

###################################################################
###################################################################
# 2- Extracts only the measuresments on the mean and standard 
#    deviation for each measurement.
###################################################################
###################################################################


features <- read.table("features.txt")

# get only columns with mean() or std() in their names
# we will use the regular expression to get the mean and std columns.
select_feautures <- grep("-(mean|std)\\(\\)", features[, 2])

# We filter the x_data 
x_data <- x_data[, select_feautures]

# correct the column names
names(x_data) <- features[select_feautures, 2]

###################################################################
###################################################################
# 3- Uses descriptive activity names to name the activities in the
#    data set.
###################################################################
###################################################################

activities <- read.table("activity_labels.txt")


y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

###################################################################
###################################################################
# 4- Appropriately labels the data set with descriptive variable
#   names. 
###################################################################
###################################################################

names(subject_data) <- "subject"

# union all data
all_data <- cbind(x_data, y_data, subject_data)

###################################################################
###################################################################
# 5 - From the data set in step 4, creates a second, independent 
#     tidy data set with the average of each variable for each 
#     activity and each subject.. 
###################################################################
###################################################################
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)

