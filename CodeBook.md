The run_analysis.R script reads the wearable computing data into tables, then tidies and merges the tables. 
The first step is to decide how to keep file locations consistent. Even my Github desktop sync points to the same 
subdirectory structure as used in the Course Project assignment description.

(1) Merges the training and the test sets to create one data set
read.table does indeed longer to run for X datatsets, which are 66MB and 26.5MB raw text files, but it works adequately. 

I recycle the temp variables here for some memory mamagement. The requested tables are saved as tableX, tableY and tableSubject.

(2) Extracts only the measurements on the mean and standard deviation for each measurement
Very tricksy! The provided file features.txt lists 561 feautures, but most of it is bogus or otherwise unusable data.
Reviewing features.txt and from the courses Discussions, I decided to use grep to search for the pattern for 
'mean()' or 'std()' values from second column V2.

These selected features are saved to indexUsuableFeatures table. 
Next, using indexUsableFeatures on tableX subsets to a 10299 by 66 dimension table. I also assign names in this table 
from features.txt. Note that I am making a major assumption here that these features are being assigned accurately.

(3) Uses descriptive activity names to name the activities in the data set
This is straightforward -- just take the 6 activity names from the activity_labels.txt.
An important choice made here to standardize activity names in lowercase, which will be needed for merging the tables. 

Assign the descriptive activity names by Activity# in tableY, then name this column "activity".

(4) Appropriately labels the data set with descriptive variable names
After last column naming and setting to lowercase activity names, we merge the X, Y, Subject tables.
The resulting merged table is stored as tidyTable. 

(5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
There are 6 activities and 30 (numerically numbered) subjects. There will be 1 average value for each 6X30 categories, so an output table with 180 rows for each of the 68 data types/categories. 

Simple for-loop object-oriented programming code used to calculate avaerages for each row. 
The resulting table 'result' is saved in the working directory as tidyTableAverages.csv. 



