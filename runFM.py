def FM(train_data, test_data, y_train):
	import numpy as np
	from sklearn.feature_extraction import DictVectorizer
	from pyfm import pylibfm
	import pandas as pd
	import math
	import time
	
	start_time = time.time()

	# Transforms lists of feature-value mappings to one-hot encoded vectors
	v=DictVectorizer()
	X_train = v.fit_transform(train_data)
	X_test = v.transform(test_data)

	# Build and train a Factorization Machine
	fm = pylibfm.FM(num_factors = 5, num_iter = 10, verbose = True, task = "regression", initial_learning_rate = 0.1, learning_rate_schedule = "optimal")

	fm.fit(X_train, y_train)
	preds = fm.predict(X_test)
		
	# Time taken for training (seconds)
	print("--- %s seconds : Time taken for training ---" % (time.time() - start_time))	
	
	np.savetxt('predictions.txt', preds)
	return preds