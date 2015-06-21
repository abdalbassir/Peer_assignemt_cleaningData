
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


require("data.table")


# Load activity labels
activity_labels <- read.table("../UCI HAR Dataset/activity_labels.txt")[, 2]


# Load data column names
features <- read.table("../UCI HAR Dataset/features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extract_features <- grepl("mean|std", features)

# Load X_test, y_test and subject_test data.
X_test <- read.table("../UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("../UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("../UCI HAR Dataset/test/subject_test.txt")

# names the data according to features
names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_test = X_test[, extract_features]

# Load activity labels
y_test[, 2] = activity_labels[y_test[, 1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# create a new column to indicate test data
test_column = as.data.table(rep(as.factor("TEST"), nrow(y_test)))
names(test_column) = c("Type")

# Bind data
test_data <- cbind(test_column, as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("../UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("../UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("../UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"


# create a new column to indicate test data
train_column = as.data.table(rep(as.factor("TRAIN"), nrow(y_train)))
names(train_column) = c("Type")


# Bind data
train_data <- cbind(train_column, as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

# write the tidy_data
write.table(data, file = "tidy_data.txt", row.name = FALSE)
