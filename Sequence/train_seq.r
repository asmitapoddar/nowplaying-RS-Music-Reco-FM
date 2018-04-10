library(plyr)
library(dplyr)
library(data.table)
library(Stack)

train = read.csv('/Train-Test Splits/Sequence/train_SEQ.csv', header = TRUE)

#Get those LEs, for which the users who have a minimum sequence of 2 LEs in the dataset
train = train %>% group_by(user_id) %>% filter(n()>1)

#Order LEs by 'user_id'
setDT(train)[,freq := .N, by = "user_id"]
train = train[order(freq, decreasing = T),]
train$rating=1

user_freq = with(tr,aggregate(freq ~ user_id,FUN=function(x){unique(x)}))
x = user_freq$freq
x = sort(x, decreasing = TRUE)
user = unique(train$user_id)

train$freq = NULL
train$track_id = as.character(train$track_id)

#Creating a training set with one temporary positive LE to start with
temp = train[1,]
temp$current_track = 'a'
temp$previous_track = 'a'

for (i in 1:length(user))
{
	part = train[which(train$user_id==user[i]),]
	#Not including the first LE since the previous track of this LE is not known 
	part = part[2:nrow(part),]
	
	listen_track = train$track_id[which(train$user_id==user[i])]
	curr_track = listen_track[2:(length(listen_track))]
	prev_track = listen_track[1:(length(listen_track)-1)]
	part$current_track = curr_track
	part$previous_track = prev_track
	
	#Creating 9 negative samples for each positive sample for the 'user_id'
	neg = do.call("rbind", replicate(9, part, simplify = FALSE))
	
	#Finding tracks in the training set which the user has not listened to 
	#and using those tracks to create the negative samples
	notlisten_track = setdiff(train$track_id, listen_track)
	notlisten_track = rep(notlisten_track,length.out=nrow(neg))
	neg$current_track = notlisten_track 
	
	#Negative LEs are given a rating 0
	neg$rating = 0
	
	#Merging the positive and negative LEs for the particular user
	peruser = Stack(part, neg)
	#Merging the positive and negative LEs peruser to create the training set
	temp = Stack(temp, peruser)
	print(i)
}

#Discarding the temporary LE that was used at the beginning of creating the final training set
temp = temp[2:nrow(temp),]
#Writing the final training set (to be input to FM) to file
write.table(temp, 'train_final_seq.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')

