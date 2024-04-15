import csv
from csv import writer
import json
import numpy as np
import random
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch_geometric.data import Data, Dataset
from torch_geometric.loader import DataLoader
from torch_geometric.nn import GCNConv, GINConv, SAGEConv, GATConv, global_mean_pool
from torch.utils.data import random_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, root_mean_squared_error, r2_score

from datetime import datetime

training_graph_path = "graphs/"
csv_path = training_graph_path + "data.csv"
PORTS = ["Cap", "Door", "Internal", "Mixed"]
MIN_SIM = 2773333.333
MAX_SIM = 10400000.0

training_data = 5000
train_test_split = 0.8

hc1 = 128 # hidden channels 1
hc2 = 64  # hidden channels 2


def normalize(n):
  return ((n - MIN_SIM) / (MAX_SIM - MIN_SIM))

def denormalize(n):
  return (n * (MAX_SIM - MIN_SIM) + MIN_SIM)
 
def average(l):
	if len(l) == 0:
		return float('inf')
	return sum(l) / len(l)
  
def format_int(n):
    if n < 10:
        return "0000" + str(n)
    if n < 100:
        return "000" + str(n)
    if n < 1000:
        return "00" + str(n)
    if n < 10000:
        return "0" + str(n)
    return str(n)

def get_bucket(m, buckets):
	for i in range(len(buckets)):
		epsilon = buckets[i+1][0]
		if m < epsilon:
			return i

def get_graph_data(filename):
    with open(filename, 'r') as json_file:
        #print(filename)
        graph_data = json.load(json_file)
        rooms = []
        edge_index = torch.tensor([], dtype=torch.long)
        x = torch.tensor([], dtype=torch.float)
        
        for room in graph_data["rooms"]:
            name = room["name"]
            area = (room["length"] * room["width"]) / 1476.0
            port = PORTS.index(room["specific port"])
            l = [[area,1,0,0,0], [area,0,1,0,0], [area,0,0,1,0], [area,0,0,0,1]]
            
            rooms.append(name)
            node_attr = l[port]
            new_room = torch.tensor([node_attr])
            new_x = torch.cat((x, new_room))
            x = new_x
        
        for edge in graph_data["links"]:
            source = rooms.index(edge["source"])
            target = rooms.index(edge["target"])
            new_link = torch.tensor([[source, target], [target, source]])
            new_edge_index = torch.cat((edge_index, new_link))
            edge_index = new_edge_index
        
    data = Data(x=x, edge_index=edge_index.t().contiguous())
    return data

def create_graph_list():
    graphs = []   
    for i in range(40000):
        graphs.append(get_graph_data(training_graph_path + "house" + format_int(i) + ".json"))
        if i % 5000 == 0:
            print(i)
    print(str(len(graphs)) + " graphs read")
    return graphs

def get_simulation_results():
    sims = []
    with open(csv_path, 'r') as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        next(csv_reader, None) # skip header(?)
        for row in csv_reader:
            sims.append(normalize(float(row[1])))
    return sims

def set_batch_size(training_data):
    if training_data < 50:
        return 16
    elif training_data < 200:
        return 32
    elif training_data < 500:
        return 64
    else:
        return 128

def train(model, train_loader, val_loader):
    # Define your loss function and optimizer
    #criterion = nn.MSELoss()
    criterion = nn.L1Loss()
    optimizer = torch.optim.Adam(model.parameters(), lr=0.001)

    # Training loop
    num_epochs = 1000
    for epoch in range(num_epochs):
        model.train()
        for data_i in train_loader:
            optimizer.zero_grad()
            out = model(data_i)
        
            # Reshape the predicted output tensor to match the shape of the target tensor
            # Assuming data_i.y is 1D, adjust as needed
            loss = criterion(out.view(-1), data_i.y)  
        
            loss.backward()
            optimizer.step()

        # Validation loop
        model.eval()
        with torch.no_grad():
            val_loss = 0
            for data_i in val_loader:
                out = model(data_i)
                val_loss += criterion(out.view(-1), data_i.y).item()

        # Print or log validation loss
        print(f'Epoch {epoch + 1}/{num_epochs}, Validation Loss: {val_loss / len(val_loader)}')
        
    return model

def make_predictions(model, test_dataset):
    preds = []
    for i_data in test_dataset: 
        model.eval()
    
        with torch.no_grad():
            predicted_output = model(i_data)

        pred = predicted_output[0][0]
        preds.append(pred)
    return preds        

def eval_preds(preds, sims):      
    mae = mean_absolute_error(sims, preds)
    mse = mean_squared_error(sims, preds)
    rmse = root_mean_squared_error(sims, preds)
    r2 = r2_score(sims, preds)
    
    return mae, mse, rmse, r2


class GraphDataset(Dataset):
    def __init__(self, graph_list, y_values):
        self.graph_list = graph_list
        self.y_values = y_values
    
    def __len__(self):
        return len(self.graph_list)
    
    def __getitem__(self, idx):
        graph = self.graph_list[idx]
        y_value = self.y_values[idx]
        data = Data(x = graph['x'], edge_index = graph['edge_index'], y = torch.tensor(y_value, dtype=torch.float))
        return data
    
    def get(self, idx):
        return self.__getitem__(idx)
    
    def len(self, idx):
        return self.__len__()

class GCN(nn.Module):
    def __init__(self, in_channels, hidden_channels1, hidden_channels2, out_channels):
        super(GCN, self).__init__()
        self.conv1 = GCNConv(in_channels, hidden_channels1)
        self.conv2 = GCNConv(hidden_channels1, hidden_channels2)
        self.conv3 = GCNConv(hidden_channels2, out_channels)

    def forward(self, data):
        x, edge_index = data.x, data.edge_index

        x = F.relu(self.conv1(x, edge_index))
        x = F.relu(self.conv2(x, edge_index))
        x = F.relu(self.conv3(x, edge_index))

        # Global pooling (e.g., mean pooling) to aggregate over all nodes
        x = global_mean_pool(x, data.batch)
        #x = torch.max(x, dim=0, keepdim=True).values

        return x

class GIN(nn.Module):
    def __init__(self, in_channels, hidden_channels1, hidden_channels2, out_channels):
        super(GIN, self).__init__()
        self.conv1 = GINConv(nn.Sequential(
            nn.Linear(in_channels, hidden_channels1),
            nn.ReLU(),
            nn.Linear(hidden_channels1, hidden_channels1),
            nn.ReLU()
        ))
        self.conv2 = GINConv(nn.Sequential(
            nn.Linear(hidden_channels1, hidden_channels2),
            nn.ReLU(),
            nn.Linear(hidden_channels2, hidden_channels2),
            nn.ReLU()
        ))
        self.conv3 = GINConv(nn.Sequential(
            nn.Linear(hidden_channels2, out_channels),
            nn.ReLU(),
            nn.Linear(out_channels, out_channels),
            nn.ReLU()
        ))

    def forward(self, data):
        x, edge_index = data.x, data.edge_index

        x = F.relu(self.conv1(x, edge_index))
        x = F.relu(self.conv2(x, edge_index))
        x = F.relu(self.conv3(x, edge_index))

        # Global pooling (e.g., mean pooling) to aggregate over all nodes
        x = global_mean_pool(x, data.batch)

        return x

class GraphSAGE(nn.Module):
    def __init__(self, in_channels, hidden_channels1, hidden_channels2, out_channels):
        super(GraphSAGE, self).__init__()
        self.conv1 = SAGEConv(in_channels, hidden_channels1)
        self.conv2 = SAGEConv(hidden_channels1, hidden_channels2)
        self.conv3 = SAGEConv(hidden_channels2, out_channels)

    def forward(self, data):
        x, edge_index = data.x, data.edge_index

        x = F.relu(self.conv1(x, edge_index))
        x = F.relu(self.conv2(x, edge_index))
        x = F.relu(self.conv3(x, edge_index))

        # Global pooling (e.g., mean pooling) to aggregate over all nodes
        x = global_mean_pool(x, data.batch)

        return x
        
class GAT(nn.Module):
    def __init__(self, in_channels, hidden_channels1, hidden_channels2, out_channels):
        super(GAT, self).__init__()
        self.conv1 = GATConv(in_channels, hidden_channels1, heads=1, concat=False)
        self.conv2 = GATConv(hidden_channels1 * 1, hidden_channels2, heads=1, concat=False)
        self.conv3 = GATConv(hidden_channels2 * 1, out_channels, heads=1, concat=False)

    def forward(self, data):
        x, edge_index = data.x, data.edge_index

        x = F.relu(self.conv1(x, edge_index))
        x = F.relu(self.conv2(x, edge_index))
        x = F.relu(self.conv3(x, edge_index))

        # Global pooling (e.g., mean pooling) to aggregate over all nodes
        x = global_mean_pool(x, data.batch)

        return x


gl = create_graph_list()
sims = get_simulation_results()
full_dataset = GraphDataset(gl, sims)

graph = full_dataset.__getitem__(1)
print(graph)
print("number of graphs:\t\t",len(full_dataset))
print("number of node features:\t",full_dataset.num_node_features)
print("number of edge features:\t",full_dataset.num_edge_features)

header = ['GNN', 'Training Data', 'MAE', 'MSE', 'RMSE', 'r2']
with open('GNN_results.csv', 'a') as f_object:
    writer_object = writer(f_object)
    writer_object.writerow(header)
    f_object.close()

       
train_gl = gl[0:training_data]
train_sims = sims[0:training_data]
training_dataset = GraphDataset(train_gl, train_sims)

train_size = int(train_test_split * training_data)
val_size = training_data - train_size
train_dataset, val_dataset = random_split(training_dataset, [train_size, val_size])

batch_size = set_batch_size(training_data)
train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False)

pre_training_time = datetime.now()

model = GCN(in_channels=5, hidden_channels1=hc1, hidden_channels2=hc2, out_channels=1)
model = train(model, train_loader, val_loader)

post_training_time = datetime.now()
print("Pre Training Time: " + str(pre_training_time))
print("Post Training Time: " + str(post_training_time))

test_gl = gl[5000:40000]
test_sims = sims[5000:40000]
test_dataset = GraphDataset(test_gl, test_sims)

preds = make_predictions(model, test_dataset)

mae, mse, rmse, r2 = eval_preds(preds, test_sims)
print(str(training_data) + " -> " + str(mae))

results = ['GAT', str(training_data), str(mae), str(mse), str(rmse), str(r2)]

with open('GNN_results.csv', 'a') as f_object:
    writer_object = writer(f_object)
    writer_object.writerow(results)
    f_object.close()
