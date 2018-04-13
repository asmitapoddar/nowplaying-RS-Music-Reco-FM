#!/usr/bin/python 

import numpy as np
from sklearn.feature_extraction import DictVectorizer
from pyfm import pylibfm
import pandas as pd
import math
import time

import load
import runFM
import calcMRR

## # import group
## # The users in the test set have been grouped according to user_id so that MRR of every group of users can be calculated.
## # This module has been provided for reference. 
## # The test set provided has already been grouped by user_id so it is not necessary to perform this step.
## group.arrange("test_100_10K.txt");

# Loading the training and test datasets
print('Loading data...')
(train_data, y_train, train_users, train_items)=load.loadData("train_final_POP_RND.txt")
(test_data, y_test, test_uers, test_items) = load.loadData("test_final_POP_RND.txt")

# Running Factorization Machine
print('Running FM...')
preds = runFM.FM(train_data, test_data, y_train)

# Evaluation: Calculating the Mean Reciprocal Rank(MRR)
print('Calculating MRR...')
calcMRR.MRR(preds)
