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

if __name__ == '__main__':
	from globalVariables import *
	import pdb

	train_data, train_label = setData(TRAIN_SAME_FILE, 1, TRAIN_DIFF_FILE, 0)
	test_data, test_label = setData(TEST_SAME_FILE, 1, TEST_DIFF_FILE, 0)

	pdb.set_trace()