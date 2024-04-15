from datetime import datetime

now = datetime.now()
print(str(now) + ": import libraries")
from csv import writer
import numpy as np
import random
from sklearn.metrics import mean_absolute_error, mean_squared_error, root_mean_squared_error, r2_score
from sklearn.ensemble import RandomForestRegressor
now = datetime.now()
print(str(now) + ": imports done")

NUM_OF_TRAINING_DATA = 200

MIN_SIM = 2773333.333
MAX_SIM = 10400000.0

def normalize(n):
  return ((n - MIN_SIM) / (MAX_SIM - MIN_SIM))

def denormalize(n):
  return (n * (MAX_SIM - MIN_SIM) + MIN_SIM)
 

def get_random_items(max_value, length):
	items = []
	while len(items) != length:
		number = random.randint(0, max_value)
		if number not in items:
			items.append(number)
	return items

def average(l):
	if len(l) == 0:
		return float('inf')
	return sum(l) / len(l)

def rf(embedding_name, embeddings, measurements, sample):
    now = datetime.now()
    num_of_training_data = len(sample)
    print(str(now) + ": start with " + embedding_name + " embedding, and sampling size " + str(num_of_training_data))

    # get embeddings and measurements of classifier training data
    train_reg_x_list = []
    train_reg_y_list = []
    for s in sample:
    	train_reg_x_list.append(embeddings[s])
    	train_reg_y_list.append(measurements[s])
    
    # transform classifier training data into numpy arrays
    train_reg_x = np.array(train_reg_x_list)
    train_reg_y = np.array(train_reg_y_list)

    # initialise regressor
    #reg = RandomForestRegressor(criterion='mae')
    reg = RandomForestRegressor(criterion='absolute_error')
    
    # train regressor and predict
    now = datetime.now()
    print(str(now) + ": train regressor...")
    reg.fit(train_reg_x, train_reg_y)
    now = datetime.now()
    print(str(now) + ": trained")
    
    test_x = embeddings[5000:40000]
    test_y = measurements[5000:40000]
    reg_preds = reg.predict(test_x) 
    
    mae = mean_absolute_error(test_y, reg_preds)
    mse = mean_squared_error(test_y, reg_preds)
    rmse = root_mean_squared_error(test_y, reg_preds)
    r2 = r2_score(test_y, reg_preds)
            
    return mae, mse, rmse, r2
    
def prepare_data(embeddings, measurements):
    e = np.array(embeddings)
    ml = []
    for m in measurements:
        ml.append(normalize(m[0]))
    m = np.array(ml)
    return e, m

from LDP_embedding import embeddings, measurements
embedding_name = "rf-LDP"

header = ['Embedder', 'Training Data', 'MAE', 'MSE', 'RMSE', 'r2']

with open(embedding_name + '_results.csv', 'a') as f_object:
    writer_object = writer(f_object)
    writer_object.writerow(header)
    f_object.close()


training_data = NUM_OF_TRAINING_DATA
e, m = prepare_data(embeddings, measurements)

sample = range(0, training_data)
mae, mse, rmse, r2 = rf(embedding_name, e, m, sample)

results = [embedding_name, str(training_data), str(mae), str(mse), str(rmse), str(r2)]

with open(embedding_name + '_results.csv', 'a') as f_object:
    writer_object = writer(f_object)
    writer_object.writerow(results)
    f_object.close()

