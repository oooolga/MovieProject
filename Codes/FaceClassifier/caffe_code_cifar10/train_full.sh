#!/usr/bin/env sh

TOOLS=/pkgs/caffe/bin

$TOOLS/caffe.bin train \
    --solver=./cifar10_full_solver.prototxt

read input

# reduce learning rate by factor of 10
$TOOLS/caffe.bin train \
    --solver=./cifar10_full_solver_lr1.prototxt \
    --snapshot=./snapshots/cifar10_full_iter_60000.solverstate.h5
read input

# reduce learning rate by factor of 10
$TOOLS/caffe.bin train \
    --solver=./cifar10_full_solver_lr2.prototxt \
    --snapshot=./snapshots/cifar10_full_iter_65000.solverstate.h5
read input
