# #nowplaying-RS: A Benchmark Dataset for Context Aware Music Recommendation

Here, you can find the codes for implementation of the experiments conducted on the #nowplaying-RS dataset.   
We have used Factorization Machines[1] to perform the music recommendation experiments.  

More details about the dataset and its contents can be found at http://dbis-nowplaying.uibk.ac.at/  

## Data

Since the #nowplaying-RS is an implicit dataset, the train-test splits provided contain Listening Events (LEs) with positive ratings. However, for model training and evaluation of Factorization Machines, negative examples are needed. Here, we provide the scripts that have been used to creating the final training and test sets that can be input to the FM.

## Environment
Python 3.5
R 3.4.3

## Dependencies  
- numpy    
- sklearn    
- pyfm  
- pandas  
- math  
- time   

- plyr  
- dplyr 
- data.table  
- Stack

## Creating Final Training and Test Sets
1. [Seq](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/main.py): The main file from which the other scripts are called.

## Code
The following scripts, stored in this repository, have been developed for the dataset.
1. [main.py](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/main.py): The main file from which the other scripts are called.  
2. [group.py](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/group.py): The test set is ordered according to the user_id. However, this is optional as the test set provided has already been ordered according to user_id. 
3. [load.py](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/load.py): Shows how to load the dataset. You can enter the attributes with which you want to train the Factorization Machine here. (In this file, the attributes user_id + track_id + tempo have been used to train the FM).  
4. [runFM.py](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/runFM.py): Training of the Factorization Machine takes place and prediction.
5. [calcMRR.py](https://github.com/asmitapoddar/nowplaying-RS-Music-Recommendation-FM/blob/master/calcMRR.py): Calculation of Mean Reciprocal Rank (MRR).

## Usage

###### 1. Downloading the dataset.
You can download the datasets and uncompress the archives using the following commands:
```
wget http://dbis-nowplaying.uibk.ac.at/wp-content/uploads/nowplayingrs.zip
wget http://dbis-nowplaying.uibk.ac.at/wp-content/uploads/nowplayingrs_train_test.zip
unzip nowplayingrs_train_test.zip
```
###### 2. Cloning the repoitory.
``
git clone https://github.com/asmitapoddar/nowplaying-RS-Music-Reco-FM.git
cd nowplaying-RS-Music-Reco-FM
```
###### 3. Installing the dependencies as have been mentioned above.  

###### 4. Running the code.
```
python3.5 main.py
```
Please make sure that the code files and the downloaded datasets are in the same folder, and the path to the datasets have been set correctly.

[1]Steffen Rendle. 2012. Factorization Machines with libFM. ACM Trans. Intell. Syst. Technol. 3, 3, Article 57 (May 2012), 22 pages. DOI=http://dx.doi.org/10.1145/2168752.2168771
