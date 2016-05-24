#!/usr/bin/env sh

TOOLS=/pkgs/caffe/bin

$TOOLS/caffe.bin train \
    --solver=./solver.prototxt \
    -gpu 3

#read input
cp snapshots/iter_60000.caffemodel.h5 snapshots_iter_60000.caffemodel.h5

read input
# reduce learning rate by factor of 10
$TOOLS/caffe.bin train \
    --solver=./solver_lr1.prototxt \
    --snapshot=./snapshots/iter_60000.solverstate.h5

#rm -f snapshots_iter_60000.caffemodel.h5
read input

# reduce learning rate by factor of 10
cp snapshots/iter_65000.caffemodel.h5 snapshots_iter_65000.caffemodel.h5
$TOOLS/caffe.bin train \
    --solver=./cifar10_full_solver_lr2.prototxt \
    --snapshot=./snapshots/iter_65000.solverstate.h5
rm -f snapshots_iter_65000.caffemodel.h5
