def MRR(preds):
	import pandas as pd
	import numpy as np
	import math
	
	df = pd.read_csv('test_100_10K_sorted.txt', sep = '\t', header = None)
	df.columns = ['coordinates','instrumentalness', 'liveness','speechiness', 'danceability','valence','loudness', 'tempo','acousticness','energy','mode', 'key', 'artist_id','place','geo','tweet_lang','track_id','created_at', 'lang', 'time_zone','entities', 'user_id', 'id', 'rating']

	unique_users = df['user_id'].value_counts()
	
	# limit_beg and limit_end are the indices where the first user_id begins and ends respectively.
	limit_beg = 0
	limit_end = unique_users.iloc[0]
	
	# Making a vector of the ratings for both the test data and the predicted data. (Column 24 contains the ratings).
	test1 = df.iloc[limit_beg:limit_end,23].values
	pred1 = preds[limit_beg:limit_end]
	
	# Lists of each user's predicted ratings are appended to a list(rs).
	rs = []
	rs.append(pred1)
		
	cumulative_sum = np.cumsum(unique_users)	
	len_cum = len(cumulative_sum)
	
	# Looping through all the users in the test set 
	for i in range(0,len_cum-2):
		limit_beg = cumulative_sum.iloc[i]
		limit_end = cumulative_sum.iloc[i+1]
		test1 = df.iloc[limit_beg:limit_end,23].values
		pred1 = preds[limit_beg:limit_end]
		rs.append(pred1)
	
	# Calculating MRR [MRR is 1/(rank of relevant item in the predicted list)].
	print("MRR:")
	rs = (np.asarray(r).nonzero()[0] for r in rs)
	print(np.mean([1. / (r[0] + 1) if r.size else 0. for r in rs])) 
	print('------End of program------_')