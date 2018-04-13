library(plyr)
library(dplyr)
library(data.table)
library(Stack)

train = read.csv('/Train-Test Splits/Context/train.csv', header = TRUE)

#Order LEs by 'user_id'
setDT(train)[,freq := .N, by = "user_id"]
train = train[order(freq, decreasing = T),]

#Positive LEs are given a rating 1
train$rating=1

#Get the unique user_ids and their frequencies
unique_user_id = with(train,aggregate(freq ~ user_id,FUN=function(x){unique(x)}))
frequen = unique_user_id$freq
frequen = sort(frequen, decreasing = TRUE)
user = unique(train$user_id)

train$freq = NULL

#Creating a training set with one temporary positive LE to start with
temp = train[1,]

for (i in 1:length(user))
{
	#Get the tracks which the user has already listened to
	tracks_listened = train$track_id[which(train$user_id==user[i])]
	
	#Get those tracks in the dataset, which the user has not previously listened to
	notlisten_df = filter( train, !train$track_id %in% tracks_listened)
	
	#To make sure that number of rows in 'notlisten_df' >= the number of negative LEs per user that need to be added
	notlisten_df = Stack(notlisten_df, notlisten_df)
	notlisten_df = Stack(notlisten_df, notlisten_df)
	
	#Negative LEs are given a rating 0
	notlisten_df$rating = 0
	
	notlisten_df$user_id = user[i]
	
	#Creating 9 negative samples for each positive sample of the 'user_id'
	partdf = head(notlisten_df,(frequen[i]*9))
	
	#Stacking the negative samples for each user
	temp = Stack(temp, partdf)
	print(i)
}

#Discarding the temporary LE that was used at the beginning of creating the training set
temp = temp[2:nrow(temp),]

#Merging the positive and negative LEs create the final training set
train_all = Stack(train, temp)
#Writing the final training set (to be input to FM) to file
write.table(train_all, 'train_final_context_POP_RND.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')

