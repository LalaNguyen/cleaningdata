# Course Project - Getting & Cleaning Data
# Files Structure
- data : folder to store source data
- codebook.Rmd/codebook.md/codebook.html : Details Description of variables in tidydata.txt
- run_analysis.R : R script that obtains the data and create tidydata.txt
- tidydata.txt : A clean version of source data

# Data Source
The file is broken down into pieces where: 
- X represents Features of the data
- Y represents related Activity of the User
- subject represents the person who performs the activity

# R Scripts
run_analysis.R does the following:

1. It first downloads the file from given url and extract it
2. Secondly, it merges correspondingly Features-train/test, Activity-train/test, Subject-train/test and produce large datasets
3. Thirdly, it looks for features name inside features.txt and grep the mean & std features. Using the selected features, it creates another small subset including on mean & std value.
4. Fourthly, it replaces activities with the corresponding name in subset.
5. Fifthly, it finds and replace some descriptive variables name with gsub.
6. Finally, it creates a second, independent tidy data set with the average of each variable for each activity and each subject.
