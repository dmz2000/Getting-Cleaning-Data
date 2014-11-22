libary(dplyr)

# Read in the activity labels/mapping
activity.labels <- read.table("activity_labels.txt")

# Read in the training data set, activity labels, and subjects
train.data <- read.table("./train/X_train.txt")
train.labels <- read.table("./train/y_train.txt")
train.subjects <- read.table("./train/subject_train.txt")

# Read in the testing data set, activity labels, and subjects
test.data <- read.table("./test/X_test.txt")
test.labels <- read.table("./test/y_test.txt")
test.subjects <- read.table("./test/subject_test.txt")

# Read in the features vector
features <- read.table("features.txt", stringsAsFactors=FALSE)

# Adding column names to testing and training data
colnames(train.data) <- features[, 2]
colnames(test.data) <- features[, 2]

# Keeping only columns that are mean or standard deviation - with mean()/std()
train.data.1 <- train.data[, union(grep("mean()", names(train.data), fixed=TRUE), 
                       grep("std()", names(train.data)), fixed=TRUE)]
test.data.1 <- test.data[, union(grep("mean()", names(train.data), fixed=TRUE), 
                                 grep("std()", names(train.data)), fixed=TRUE)]

# Bind together subjects, activity labels and datasets
train.data.lab <- cbind(train.subjects, train.labels, train.data.1)
test.data.lab <- cbind(test.subjects, test.labels, test.data.1)

# Merging the training and testing datasets together
merged.data <- rbind(test.data.lab, train.data.lab)
names(merged.data)[1] <- "Subjects"  #Renaming column

# Replacing activity numbers with actual labels - creates tidy dataset
merged.data.1 <- merge(activity.labels, merged.data, by="V1", all.y=TRUE)
names(merged.data.1)[names(merged.data.1)=="V2"] <- "Activities"
tidy.data <- subset(merged.data.1, select = -c(V1)) #Dropping the uneeded col
tidy.data$Activities <- factor(tidy.data$Activities, levels=activity.labels[, 2])

# Relabeling the tidy dataset to be more descriptive
for (colname in colnames(tidy.data)){
  if (substr(colname, 1, 1)=='t' & grepl("mean()", colname)){
    names(tidy.data)[names(tidy.data)==colname] <- paste("MeanTime", gsub("-mean()", "", substring(colname, 2), fixed=TRUE), sep=".")
  } else if (substr(colname, 1, 1)=='f' & grepl("mean()", colname)) {
    names(tidy.data)[names(tidy.data)==colname] <- paste("MeanFreq", gsub("-mean()", "", substring(colname, 2), fixed=TRUE), sep=".")
  } else if (substr(colname, 1, 1)=='t' & grepl("std()", colname)){
    names(tidy.data)[names(tidy.data)==colname] <- paste("StdTime", gsub("-std()", "", substring(colname, 2), fixed=TRUE), sep=".")
  } else if (substr(colname, 1, 1)=='f' & grepl("std()", colname)) {
    names(tidy.data)[names(tidy.data)==colname] <- paste("StdFreq", gsub("-std()", "", substring(colname, 2), fixed=TRUE), sep=".")
  } 
}

# Create second tidy dataset with the average of each variable for each activity and subject 
tidy.means <-
  tidy.data %>% 
    group_by(Activities, Subjects) %>%
    summarise_each(funs(mean)) %>%
    arrange(Subjects, Activities)
#Adding the Mean prefix to each variable  
names(tidy.means)[-c(1:2)] <- paste("Mean", names(tidy.means)[-c(1:2)], sep=".")

# Export 
write.table(tidy.means, "tidy_means.txt", row.names = FALSE)
