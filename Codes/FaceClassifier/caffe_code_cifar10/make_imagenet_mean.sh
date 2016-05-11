#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

EXAMPLE=/ais/gobi4/characters/Data/afw/
DATA=/ais/gobi4/characters/Data/afw/caffe_model
TOOLS=/pkgs/caffe/bin
DBTYPE=lmdb

$TOOLS/compute_image_mean.bin -backend=$DBTYPE ./cifar10_train_lmdb ./mean.binaryproto
cp ./mean.binaryproto $DATA
echo "Done."
