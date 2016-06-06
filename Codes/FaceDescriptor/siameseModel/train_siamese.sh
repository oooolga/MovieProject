#!/usr/bin/env sh

TOOLS=/pkgs/caffe/bin
LOG_DIR=./snapshots/run2/siamese.log

$TOOLS/caffe.bin train --solver=./siamese_solver.prototxt -gpu 2 2>&1 | tee $LOG_DIR
