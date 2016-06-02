from globalVariables import *

def setData(*arg):
	'''
	setData(file_path, label, file_path, label, ...) -> list, list

	Return a list of extracted data from file_paths and their labels.
	Precondition: len(arg) == 2x
	'''
	data = []
	label = []

	for i in range(len(arg)//2):
		filename = arg[2*i]
		label_i = arg[2*i+1]
		with open(filename, 'r') as f:
			curr_data = f.read().split('\r\n')
			curr_data = filter(bool, curr_data)
			data = data + curr_data
			label = label + [label_i for i in range(len(curr_data))]
	
	return data, label

def writeData(writeFiles, data, label, randomize=True):
	'''
	writeData(list, list, list, bool) -> None

	Return whether it could successfully writing to writeDir.
	'''
	if randomize:
		import random
		ind = range(len(data))
		random.shuffle(ind)
		shuffled_data = [data[i] for i in ind]
		shuffled_label = [label[i] for i in ind]
		label = shuffled_label; data = shuffled_data

	with open(writeFiles[0], 'w') as f1:
		with open(writeFiles[1], 'w') as f2:
			with open(writeFiles[-1], 'w') as f:
				for d_i in range(len(data)):
					d = data[d_i].split(' ')
					f1.write(d[0] + DATA_SUFFIX + ' ' + str(label[d_i]) + '\n')
					f.write(d[0] + DATA_SUFFIX + ' ' + str(label[d_i]) + '\n')
					f2.write(d[1] + DATA_SUFFIX + ' ' + str(label[d_i]) + '\n')
					f.write(d[1] + DATA_SUFFIX + ' ' + str(label[d_i]) + '\n')




if __name__ == '__main__':
	
	import pdb

	train_data, train_label = setData(TRAIN_SAME_FILE, 1, TRAIN_DIFF_FILE, 0)
	test_data, test_label = setData(TEST_SAME_FILE, 1, TEST_DIFF_FILE, 0)

	writeData([DATA_DIR+'train1.txt', DATA_DIR+'train2.txt', DATA_DIR+'train.txt'],
		train_data, train_label)
	writeData([DATA_DIR+'test1.txt', DATA_DIR+'test2.txt', DATA_DIR+'test.txt'],
		test_data, test_label)