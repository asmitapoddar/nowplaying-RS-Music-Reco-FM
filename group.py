def arrange(filename, path = "/home/asmitapoddar/a1/warm/"):

	import pandas as pd
	df = pd.read_csv(path+filename, sep = '\t', header = None)
	df.columns = ['coordinates','instrumentalness', 'liveness','speechiness', 'danceability','valence','loudness',
				  'tempo','acousticness','energy','mode', 'key', 'artist_id','place','geo','tweet_lang','track_id',
				  'created_at', 'lang', 'time_zone','entities', 'user_id', 'id', 'rating']
	
	df.groupby('user_id').count()
	df.to_csv('test_100_10K_sorted.txt', sep = '\t', header = False, index = False)
