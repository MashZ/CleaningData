## Keeping file locations consistent, Github sync points to the same subdirectory structure
##   used in the Peer Assignment description.

## 1. Merges the training and the test sets to create one data set
tempTrain <- read.table("train/X_train.txt")
tempTest <- read.table("test/X_test.txt")
tableX <- rbind(tempTrain, tempTest)

tempTrain <- read.table("train/Y_train.txt")
tempTest <- read.table("test/Y_test.txt")
tableY <- rbind(tempTrain, tempTest)

tempTrain <- read.table("train/subject_train.txt")
tempTest <- read.table("test/subject_test.txt")
tableSubject <- rbind(tempTrain, tempTest)


## 2. Extracts only the measurements on the mean and standard deviation for each measurement
tableFeatures <- read.table("features.txt")
indexUsableFeatures <- grep("-mean\\(\\)|-std\\(\\)", tableFeatures$V2)

## Next, using indexUsableFeatures on tableX subsets to a 10299 by 66 dimension table. 
tableX <- tableX[, indexUsableFeatures]

## Assign names from features.txt. I have a major assumption here that these features are being assigned accurately.
names(tableX) <- tableFeatures[indexUsableFeatures, 2]


## 3. Uses descriptive activity names to name the activities in the data set
## Important choice made here to standardize activity names in lowercase, which wll be needed for merging the tables. 
activities <- read.table("activity_labels.txt")
activities$V2 <- gsub("_", "", tolower(as.character(activities$V2)))

## Assign the descriptive activity names by Activity# in tableY, then name this column "activity"
tableY[, 1] <- activities[tableY[, 1], 2]
names(tableY) <- "activity"


## 4. Appropriately labels the data set with descriptive variable names
## After last column naming and setting to lowercase activity names, we merge the X, Y, Subject tables.  
names(tableX) <- gsub("\\(|\\)", "", names(tableX))
names(tableX) <- tolower(names(tableX))
names(tableSubject) <- "subject"
tidyTable <- cbind(tableSubject, tableY, tableX)


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## There are 6 activities and 30 (numerically numbered) subjects. There will be 1 average value for each 6X30 categories, so an output table with 180 rows for each of the 68 data types/categories. 
numActivities <- length(activities$V2)
numSubjects <- length(unique(tableSubject$subject))
numCols <- length(tidyTable)
result <- tidyTable[1 : (numActivities * numSubjects), ]

row = 1
for ( s in 1:numSubjects) {
    for (a in 1:numActivities) {
        result[row, 1] = uniqueSubjects[s]
        result[row, 2] = activities[a, 2]
        tmp <- tidyTable[tidyTable$subject==s & tidyTable$activity==activities[a, 2], ]
        result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
        row = row + 1
    }
}
write.table(result, "tidyTableAverages.csv", row.name = FALSE)