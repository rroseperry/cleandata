Tidy data set for Week Four Project, Cleaning Data 24 October 2018

This data set provides the mean for each activity variable, by subject for the original filtered data from the UCI HAR data set, avaialble at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones. 

It was produced by the run_analysis  R script. This script merges and cleans the initial data files, following the decisions I've outlined below, The summary data set can be read into R using df <- read.csv("~/summarybody.txt").

After the initial merging of the test and trial data, the primary challenge with these data is the decision of which variables to extract. I decided to choose the original filters for body and gravity acceleration because all the subsequent variables are either transforms of these data or derived from them.

I decided on a wide form for the tidied data because there is no, imo, defensible way to lump the different axes of movement. Nor did it make sense to attemtp to recombine the body and gravity data. This decision is supported by the discussion at this link, https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/ and a reading of Wickham's Tidy Data paper.

The complete set of files are: the run_analysis script, the extracted means labeled, summarybody.txt, a CodeBook, explaining the factor variables, and this Readme.



