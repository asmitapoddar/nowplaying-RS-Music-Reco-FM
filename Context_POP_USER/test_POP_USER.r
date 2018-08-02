library(plyr)
library(dplyr)
library(data.table)
library(Stack)

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
temp$lang = as.character(temp$lang)
temp$hashtag = as.character(temp$hashtag)
temp$tweet_lang = as.character(temp$tweet_lang)

for (i in 1:length(user))
{
	#Get LEs of the particular user
	lis = filter( test, test$user_id ==user[i])
	
	#Creating 9 negative samples for each positive sample of the 'user_id'
	notlis = do.call("rbind", replicate(9, lis, simplify = FALSE))
	
	#Get vector of the languages that the user hasn't used
	notlang = setdiff(test$lang, lis$lang)
	notlang = rep(notlang,length.out=nrow(notlis))
	
	#Get vector of the hashtags that the user hasn't used
	nothash = setdiff(test$hashtag, lis$hashtag)
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
#Discarding the temporary LE that was used at the beginning of creating the test set
temp = temp[2:nrow(temp),]

#Merging the positive and negative LEs to create the final test set
test_all = Stack(test, temp)
#Writing the final test set (to be input to FM) to file
write.table(test_all, 'test_final_POP_USER.txt', quote = FALSE, col.names= FALSE, row.names = FALSE, sep = '\t')
