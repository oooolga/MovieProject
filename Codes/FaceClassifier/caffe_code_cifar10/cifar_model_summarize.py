import caffe
import os

import numpy as np

#import warnings
#warnings.filterwarnings("ignore")

MODEL_FILE = '/ais/gobi4/characters/Results/caffe_cifar10/default_20160511_1208/cifar10_full.prototxt'
PRETRAINED =  '/ais/gobi4/characters/Results/caffe_cifar10/default_20160511_1208/snapshots/cifar10_full_iter_70000.caffemodel.h5'
TEST_PATH = '/ais/gobi4/characters/Data/afw/'
MEAN_FILE_PATH = '/ais/gobi4/characters/Data/afw/caffe_model/mean.npy'

caffe.set_mode_gpu()
net = caffe.Net(MODEL_FILE, PRETRAINED, caffe.TEST)

data_shape = net.blobs['data'].shape
print 'input data shape: (%d, %d, %d ,%d)' % (data_shape[0], data_shape[1], data_shape[2], data_shape[3])

transformer = caffe.io.Transformer({'data': data_shape})
transformer.set_mean('data', np.load(MEAN_FILE_PATH).mean(1).mean(1))
transformer.set_transpose('data', (2,0,1))
transformer.set_channel_swap('data', (2,1,0))

mean_tensor = np.load(MEAN_FILE_PATH)
print mean_tensor.shape

pred = []
truth = []

with open(TEST_PATH+'val.txt', 'r') as f:
	for line in f:
		filename = line.strip().split()[0]
		label = int(line.strip().split()[1])
		image = caffe.io.load_image(TEST_PATH + 'val/' + filename)
		transformed_image = transformer.preprocess('data', image)

		net.blobs['data'].data[...] = transformed_image
		output = net.forward()
		output_prob = output['prob'][0]

		truth.append(output_prob.argmax())
		pred.append(label)
		print(filename + '\tprediction: ' + str(truth[-1]) + '\treal: ' + str(label))

from sklearn.metrics import classification_report
target_names = ['face', 'non-face']
print(classification_report(truth, pred, target_names=target_names))
