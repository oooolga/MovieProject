#rm -rf ./train_lmdb
#rm -rf ./val_lmdb

#rm -f mean.binaryproto

SAVEDIR=/ais/gobi4/characters/Results/caffe/
for file in *.caffemodel;
do
	cp $file $SAVEDIR
	rm -rf $file
done 

for file in *.solverstate
do
	cp $file $SAVEDIR
	rm -rf $file
done
