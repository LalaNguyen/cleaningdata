# Download the file into data folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,  destfile = "./data/uci.zip", method="curl")
# Unzip the file
unzip(zipfile = "./data/uci.zip")
## 1. Merge two datasets into large set using rbind
# Load subjects test/train and bind them
sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjects <- rbind(sub_train, sub_test)
names(subjects) <- c("Subject")

# Load features test/train and bind them
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
features <- rbind(x_train, x_test)
df <- read.table(file = "./data/UCI HAR Dataset/features.txt")
names(features ) <- df$V2

# Load activities test/train and bind them
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
activities <- rbind(y_train,y_test)
names(activities) <- c("Activities")
# Merge all data into large datasets
datasets <- cbind(subjects,features,activities)

## 2. Extracts measurement from features.txt
# Grep column that has value  "mean()" and "std()"
sub_df<-df$V2[grep("mean\\(\\)|std\\(\\)", df$V2)]
select_col <- c(as.character(sub_df),"Activities","Subject")
# Take subset from data frame
subsets <- subset(datasets, select = select_col)

## 3. Uses descriptive activity names to name the activities in the data set
act <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt")
names(act)<-c("Activities","Label")
library(plyr)
# Join 2 data frames based on Activities
p <- join(x = subsets, y = act, by="Activities", match="all")
# Replace the old Activities to new value
subsets$Activities <- p$Label

## 4. Appropriately labels the data set with descriptive variable names. 
# Replace t with time
# Replace Acc with Acceleration
# Replace Mag with Magnitude
# Replace f with frequency
name <- gsub("^t","time",select_col)
name <- gsub("Acc","Acceleration",name)
name <- gsub("Mag","Magnitude",name)
name <- gsub("^f","frequency",name)
# Replace name of subsets
names(subsets) <- name

# 5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
data <- aggregate(.~Activities+Subject, data = subsets, mean)
# Write to table
write.table(data, file = "tidydata.txt",row.name=FALSE)

