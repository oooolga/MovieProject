#!/usr/bin/env sh
# Create the imagenet lmdb inputs
# N.B. set the path to the imagenet train + val data dirs

DATA=/ais/gobi4/characters/Data/LFWcrop/lfwcrop_color
EXAMPLE=/ais/gobi4/characters/Data/LFWcrop/lfwcrop_color/caffe_model
TOOLS=/pkgs/caffe/bin

rm -rf $EXAMPLE/*_lmdb
rm -rf ./*_lmdb

DATA_ROOT=$DATA/faces/

# Set RESIZE=true to resize the images to 256x256. Leave as false if images have
# already been resized using another tool.
RESIZE=true
if $RESIZE; then
  RESIZE_HEIGHT=256
  RESIZE_WIDTH=256
else
  RESIZE_HEIGHT=0
  RESIZE_WIDTH=0
fi

if [ ! -d "$DATA_ROOT" ]; then
  echo "Error: TRAIN_DATA_ROOT is not a path to a directory: $TRAIN_DATA_ROOT"
  echo "Set the TRAIN_DATA_ROOT variable in create_imagenet.sh to the path" \
       "where the ImageNet training data is stored."
  exit 1
fi

echo "Creating train1 lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset.bin \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/train1.txt \
    ./train1_lmdb

echo "Creating train2 lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset.bin \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/train2.txt \
    ./train2_lmdb

echo "Creating train lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset.bin \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/train.txt \
    ./train_lmdb

echo "Creating test1 lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset.bin \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/test1.txt \
    ./test1_lmdb

echo "Creating test2 lmdb..."

GLOG_logtostderr=1 $TOOLS/convert_imageset.bin \
    --resize_height=$RESIZE_HEIGHT \
    --resize_width=$RESIZE_WIDTH \
    $DATA_ROOT \
    $DATA/test2.txt \
    ./test2_lmdb

cp -r ./*_lmdb $EXAMPLE
echo "Done."
