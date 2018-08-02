library(plyr)
library(dplyr)
library(data.table)
library(Stack)

train = read.csv('/Train-Test Splits/Context/train.csv', header = TRUE)
test = read.csv('/Train-Test Splits/Context/test.csv', header = TRUE)

#Order LEs by 'user_id'
setDT(test)[,freq := .N, by = "user_id"]
test = test[order(freq, decreasing = T),]

#Get the unique user_ids and their frequencies
unique_user_id = with(test,aggregate(freq ~ user_id,FUN=function(x){unique(x)}))
frequen = unique_user_id$freq
frequen = sort(frequen, decreasing = TRUE)
user = unique(test$user_id)

#Positive LEs are given a rating 1
test$rating=1

test$freq = NULL

#Creating a test set with one temporary positive LE to start with
temp = test[1,]
for (i in 1:length(user))
{
	#Get the tracks which the user has already listened to
	tracks_listened_test = test$track_id[which(test$user_id==user[i])]
	tracks_listened_train = train$track_id[which(train$user_id==user[i])]
	tracks_listened = c(tracks_listened_test, tracks_listened_train)
	
	#Get those tracks in the dataset, which the user has not previously listened to
	notlisten_df = filter( test, !(test$track_id %in% tracks_listened && train$track_id %in% tracks_listened))
	
	#To make sure that number of rows in 'notlisten_df' >= the number of negative LEs per user that need to be added
	notlisten_df = Stack(notlisten_df, notlisten_df)
	notlisten_df = Stack(notlisten_df, notlisten_df)
	
	#Negative LEs are given a rating 0
	notlisten_df$rating = 0
	notlisten_df$user_id = user[i]
	
	#Creating 9 negative samples for each positive sample of the 'user_id'
	partdf = head(notlisten_df,(frequen[i]*9))
	
	#Stacking the negative samples for each user
	temp = Stack(temp, partud)
	print(i)
}

#Discarding the temporary LE that was used at the beginning of creating the test set
temp = temp[2:nrow(temp),]

#Merging the positive and negative LEs to create the final test set
test_all = Stack(test, temp)

#Writing the final test set (to be input to FM) to file
write.table(test_all, 'test_final_POP_RND.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')







