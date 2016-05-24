import caffe
import os
from PIL import Image
#from cifar10format import *
import numpy as np
#import cv2 as cv 

#import warnings
#warnings.filterwarnings("ignore")
import pdb

MODEL_FILE = './cifar10_full.prototxt'
PRETRAINED =  './snapshots/cifar10_iter_60000.caffemodel.h5'
TEST_PATH = '/ais/gobi4/characters/Data/afw/'
MEAN_FILE_PATH = './mean.npy'

caffe.set_mode_gpu()
#net = caffe.Net(MODEL_FILE, PRETRAINED, caffe.TEST)

mean_tensor = np.load(MEAN_FILE_PATH).mean(1).mean(1)
#pdb.set_trace()
#mean_tensor = mean_tensor.mean(1).mean(1)  # average over pixels to obtain the mean (BGR) pixel values
#print 'mean-subtracted values:', zip('BGR', mean_tensor)

#data_shape = net.blobs['data'].shape

#transformer = caffe.io.Transformer({'data': data_shape})

#transformer.set_mean('data', mean_tensor)
#transformer.set_transpose('data', (2,0,1))
#transformer.set_raw_scale('data', 255) 
#transformer. ('data', (2,1,0))
pdb.set_trace()
net = caffe.Classifier(MODEL_FILE, PRETRAINED, image_dims=(256,256), mean=mean_tensor,
	input_scale=None, raw_scale=255.0, channel_swap=(2,1,0))

pred = []
truth = []

with open(TEST_PATH+'val.txt', 'r') as f:
	for line in f:
		
		filename = line.strip().split()[0]
		label = int(line.strip().split()[1])

		#image = cv.imread(TEST_PATH + 'val/' + filename)

		#pdb.set_trace()
		image = caffe.io.load_image(TEST_PATH + 'val/' + filename)
		prob = net.predict([image], True)
		#image = img2CIFARFormat(image)

		#pdb.set_trace()
		#np_image = np.asarray(image)

		#input_tensor = transformer.preprocess('data', image)
		#

		#net.blobs['data'].reshape(1, *input_tensor.shape)
		#net.blobs['data'].data[...] = input_tensor

		#response = net.forward()
		#prob = response['prob'][0]
		cls_id = np.argmax(prob)

		truth.append(label)
		pred.append(cls_id)
		print(prob)
		print(filename + '\tprediction: ' + str(cls_id) + '\treal: ' + str(label))
		#pdb.set_trace()

from sklearn.metrics import classification_report
target_names = ['face', 'non-face']
print(classification_report(truth, pred, target_names=target_names))
