#!/usr/bin/env sh

TOOLS=/pkgs/caffe/bin

#$TOOLS/caffe.bin train \
#    --solver=./solver.prototxt \
#    -gpu 3

#read input
#cp snapshots/_iter_40000.caffemodel.h5 snapshots_iter_40000.caffemodel.h5

read input
# reduce learning rate by factor of 10
#$TOOLS/caffe.bin train \
#    --solver=./solver_lr1.prototxt \
#    --snapshot=./snapshots/_iter_40000.solverstate.h5 \
#    -gpu 3

#rm -f snapshots_iter_40000.caffemodel.h5
#read input

# reduce learning rate by factor of 10
cp snapshots/_iter_45000.caffemodel.h5 snapshots_iter_45000.caffemodel.h5
$TOOLS/caffe.bin train \
    --solver=./solver_lr2.prototxt \
    --snapshot=./snapshots/_iter_45000.solverstate.h5 \
    -gpu=3
rm -f snapshots_iter_45000.caffemodel.h5
