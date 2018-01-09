def loadData(filename, path = "/home/asmitapoddar/a1/warm/"):
	import numpy as np
	
    data = []
    y = []
    users=set()
    items = set()
    with open(path+filename) as f:
        for line in f:
            (coordinates,instrumentalness, liveness,speechiness, danceability,valence,loudness, tempo, acousticness, energy, mode, key, artist_id, place, geo, tweet_lang, track_id, created_at, lang, time_zone, entities, user_id, iid, rating) = line.split('\t')
            
			# Preparation of the training data. Enter the attributes which you want to use to train the FM, here.
			data.append({"user_id":str(user_id), "track_id":str(track_id), "tz":tempo})
            
			y.append(float(rating))
            users.add(user_id)
            items.add(track_id)
    return (data, np.array(y), users, items)