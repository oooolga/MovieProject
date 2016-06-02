#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

DATA=/ais/gobi4/characters/Data/LFWcrop/lfwcrop_color/caffe_model
TOOLS=/pkgs/caffe/bin
DBTYPE=lmdb

$TOOLS/compute_image_mean.bin -backend=$DBTYPE ./train_lmdb ./mean.binaryproto
cp ./mean.binaryproto $DATA
echo "Done."

