import caffe
import os
from PIL import Image
import numpy as np
import glob

import pdb

MODEL_FILE = './deploy.prototxt'
PRETRAINED =  './snapshots/_iter_40000.caffemodel.h5'
PRED_PATH = '/ais/gobi4/characters/Data/IMDB_processed/'
MEAN_FILE_PATH = './mean.npy'

OUT_FILE = PRED_PATH.split('/')[-2]
OUT_FILE = OUT_FILE + '_predict.txt'
DETAIL_REPORT = False

caffe.set_mode_gpu()

mean_tensor = np.load(MEAN_FILE_PATH).mean(1).mean(1)

net = caffe.Classifier(MODEL_FILE, PRETRAINED, image_dims=(256,256), mean=mean_tensor,
	input_scale=None, raw_scale=255.0, channel_swap=(2,1,0))


predict_images = glob.glob(PRED_PATH + '*.jpg')

with open(OUT_FILE, 'w') as f:
	for predict_image in predict_images:
		#pdb.set_trace()
		image = caffe.io.load_image(predict_image)
		prob = net.predict([image], True)

		cls_id = np.argmax(prob)

		image_name = predict_image.split('/')[-1]
		f.write(image_name + ' Pred_cls:' + str(cls_id) + ' Cls_P:' +\
			'face:' + "{0:.2f}".format(prob[0][1]) + ' non-face:' + \
			"{0:.2f}".format(prob[0][0]) + '\n')
