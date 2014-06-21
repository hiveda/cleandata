files in samsung data folder "UCI HAR Dataset":

features.txt > id and name of features in the data (1)
activity_labels.txt > id and name of activities (2)

test-data:
test\\subject_test.txt > subject-id's
test\\x_test.txt > measured data for every feature
test\\y_test.txt > activity-id

train-data:
train\\subject_train.txt > subject-id's
train\\x_train.txt > measured data for every feature
train\\y_train.txt > activity-id

(1) Features-list is used to generate widths-vector for read.fwf.
    Set all width to -16 => don't read.
    Set all width to 16 for feature witm mean or std in the name => read this data 

subject, x and y data is merged/appended using rbind

(2) activity labels are added using activity-id in x-data
