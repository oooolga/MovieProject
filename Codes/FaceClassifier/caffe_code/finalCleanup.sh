rm -rf ./train_lmdb
rm -rf ./val_lmdb

rm -f mean.binaryproto

SAVEDIR=/ais/gobi4/characters/Results/caffe/
cp ./caffenet_train_iter_1500.caffemodel $SAVEDIR
cp ./caffenet_train_iter_1500.solverstate $SAVEDIR

rm -rf ./caffenet_train_iter_1500.caffemodel
rm -rf ./caffenet_train_iter_1500.solverstate