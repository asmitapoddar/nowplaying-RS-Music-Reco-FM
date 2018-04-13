library(plyr)
library(dplyr)
library(data.table)
library(Stack)

train = read.csv('/Train-Test Splits/Sequence/train_SEQ.csv', header = TRUE)
test = read.csv('/Train-Test Splits/Sequence/test_SEQ.csv', header = TRUE)

#Get those LEs, for which the users who have a minimum sequence of 2 LEs in the dataset
test = test %>% group_by(user_id) %>% filter(n()>1)

#Order LEs by 'user_id'
setDT(test)[,freq := .N, by = "user_id"]
test = test[order(freq, decreasing = T),]

user = unique(test$user_id)
test$rating=1
test$freq = NULL
test$track_id = as.character(test$track_id)

#Creating a test set with one temporary positive LE to start with
temp = test[1,]
temp$current_track = 'a'
temp$previous_track = 'a'

for (i in 1:length(user))
{
	part = test[which(test$user_id==user[i]),]
	#Not including the first LE since the previous track of this LE is not known
	part = part[2:nrow(part),]
	
	listen_track = test$track_id[which(test$user_id==user[i])]
	curr_track = listen_track[2:(length(listen_track))]
	prev_track = listen_track[1:(length(listen_track)-1)]
	part$current_track = curr_track
	part$previous_track = prev_track
	
	#Creating 9 negative samples for each positive sample of the 'user_id'
	neg = do.call("rbind", replicate(9, part, simplify = FALSE))
	
	#Finding tracks in the test set which the user has not listened to in both the training  and test sets
	#and using those tracks to create the negative samples
	train_listened = train_full$track_id[which(train_full$user_id==user[i])]
	notlisten_track = setdiff(c(train_full$track_id, test_full$track_id), c(listen_track, train_listened))
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
test_all = temp[2:nrow(temp),]
#Writing the final training set (to be input to FM) to file
write.table(test_all, 'test_final_seq.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')
