#=================================================================================
#Load data
#=================================================================================
setwd("/Users/sisihe/Desktop/Sisi_Personal/Course/Coursera/DataScientist/CleanData/Week4/HW/Assignment")

x_test<-read.table("./Dataset/test/X_test.txt",header=FALSE,na.strings="",stringsAsFactors = F)
#2947 561
y_test<-read.table("./Dataset/test/y_test.txt",header=FALSE,na.strings="",stringsAsFactors = F)
#test labels: 1 walking, 2 walking_upstairs, 3 walking_downstairs, 4 sitting, 5 standing, 6 laying
s_test<-read.table("./Dataset/test/subject_test.txt",header=FALSE,na.strings="",stringsAsFactors = F)

features<-read.table("./Dataset/features.txt",header=FALSE,na.strings="",stringsAsFactors = F)

x_train<-read.table("./Dataset/train/X_train.txt",header=FALSE,na.strings="",stringsAsFactors = F)
#7352  561
y_train<-read.table("./Dataset/train/y_train.txt",header=FALSE,na.strings="",stringsAsFactors = F)
#7352 1
s_train<-read.table("./Dataset/train/subject_train.txt",header=FALSE,na.strings="", stringsAsFactors = F)
#=================================================================================
#Label data with column names,combine subject id, activity type with collected data
#combine test dataset and trian dataset 
#=================================================================================
colnames(x_test)<-features[,2]
colnames(y_test)<-"activity_type"
colnames(s_test)<-"subject_id"
colnames(x_train)<-features[,2]
colnames(y_train)<-"activity_type"
colnames(s_train)<-"subject_id"

test<-cbind(s_test,y_test,x_test)
train<-cbind(s_train,y_train,x_train)
data<-rbind(test,train)

#=================================================================================
#Extract only the measurements on the mean and standard deviation for each measurement
#=================================================================================
data_mean_std<-data[,c(1,2,grep("mean\\(\\)|std\\(\\)",colnames(data)))]

#=================================================================================
#label acitivity with descriptive names, output data as data_mean_std.csv
#=================================================================================
data_mean_std$activity_type<-as.factor(data_mean_std$activity_type)
levels(data_mean_std$activity_type)<-c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying")

write.csv(data_mean_std,file="data_mean_std.csv",row.names=F)

#=================================================================================
#average of each variable for each activity and each subject
#=================================================================================

data_new<-data_mean_std
levels(data_new$activity_type)<-1:6
data_new$activity_type<-as.integer(data_new$activity_type)

split_data<-split(data_new,data_new$subject_id)

result<-data.frame()
for (i in 1:30) {
        data<-data.frame(split_data[i])
        colnames(data)<-colnames(data_new)
        
        data_1<-split(data,data$activity_type)
        
        for (i in 1:6){
                data_2<-data.frame(data_1[i])
                colnames(data_2)<-colnames(data_new)
                result<-rbind(result,sapply(data_2,mean))
        }
}
colnames(result)<-colnames(data_new)
result$activity_type<-as.factor(result$activity_type)
levels(result$activity_type)<-c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying")

write.table(result,file="avg_data.txt",row.names=F)
