run_analysis <- function(source="UCI HAR Dataset") {
  ## load libraries
  library(plyr)
  library(reshape2)
  
  ## Read common data
  f <- read.table(paste(source,"\\features.txt",sep=""),sep=" ",col.names=c("id","feature"))
  a <- read.table(paste(source,"\\activity_labels.txt",sep=""),sep=" ",col.names=c("id","activity"))
  
  ## only read mean and std values > prepare widths-vector w to extract only relevant data
  w <- rep(-16,nrow(f))
  fs <- subset(f, grepl("mean|std",feature,ignore.case=TRUE))
  w[fs$id] = 16;
  
  ## read test data
  test_subj <- read.table(paste(source,"\\test\\subject_test.txt",sep=""),sep=" ",col.names=c("id")) 
  test_meas <- read.fwf(paste(source,"\\test\\x_test.txt",sep=""),widths=w,col.names=fs$feature) #,n=1000
  test_act <- read.table(paste(source,"\\test\\y_test.txt",sep=""),sep=" ",col.names=c("id"))
  
  ## read train data
  train_subj <- read.table(paste(source,"\\train\\subject_train.txt",sep=""),sep=" ",col.names=c("id")) 
  train_meas <- read.fwf(paste(source,"\\train\\x_train.txt",sep=""),widths=w,col.names=fs$feature) #,n=1000
  train_act <- read.table(paste(source,"\\train\\y_train.txt",sep=""),sep=" ",col.names=c("id"))
  
  # merge test and train data > append using rbind
  subj <- rbind(test_subj,train_subj);
  data <- rbind(test_meas,train_meas);
  act <- rbind(test_act,train_act);
  
  # combine all data into 1 dataframe
  data$subject <- subj$id
  data$act <- act$id
  
  # melt down data set and get mean for every combination of activity and subject
  m <- melt(data, id.vars=c("act", "subject"))
  summ <- ddply(m, c("act", "subject", "variable"), summarise,mean = mean(value))
  
  # unmelt again to get the mean-values back into culumns)
  td <- dcast(summ,act + subject ~ variable, value.var="mean")
  
  # add activity-labels, using id
  t <- merge(a,td,by.x="id",by.y="act")
  
  # write tidy dataset to file
  write.table(format(t,digits=5),"tidy1.txt",sep=",",row.names=FALSE)
}
