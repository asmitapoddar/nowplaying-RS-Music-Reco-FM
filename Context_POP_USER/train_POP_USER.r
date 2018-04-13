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
temp$lang = as.character(temp$lang)
temp$hashtag = as.character(temp$hashtag)
temp$tweet_lang = as.character(temp$tweet_lang)

for (i in 1:length(user))
{
	#Get LEs of the particular user
	lis = filter( train, train$user_id ==user[i])
	
	#Creating 9 negative samples for each positive sample of the 'user_id'
	notlis = do.call("rbind", replicate(9, lis, simplify = FALSE))
	
	all_lang = as.character(train$lang)
	lang = as.character(lis$lang)
	#Get vector of the languages that the user hasn't used
	notlang = setdiff(train$lang, lis$lang)
	notlang = rep(notlang,length.out=nrow(notlis))
	
	all_hashtag = as.character(train$hashtag)
	hash = as.character(lis$hashtag)
	#Get vector of the hashtags that the user hasn't used
	nothash = setdiff(train$hashtag, lis$hashtag)
	nothash = rep(nothash,length.out=nrow(notlis))
	
	notlis$lang = notlang 
	notlis$hashtag = nothash
	notlis$tweet_lang = notlang 
	#Negative LEs are given a rating 0
	notlis$rating = 0
	
	#Stacking the negative samples for each user
	temp = Stack(temp, notlis)
	print(i)
}
#Discarding the temporary LE that was used at the beginning of creating the training set
temp = temp[2:nrow(temp),]

#Merging the positive and negative LEs to create the final training set
train_all = Stack(train, temp)
#Writing the final training set (to be input to FM) to file
write.table(train_all, 'train_final_POP_USER.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')