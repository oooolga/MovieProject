#!/usr/bin/env sh
#/pkgs/caffe/bin/caffe.bin device_query -gpu 2
/pkgs/caffe/bin/caffe.bin train --solver=./solver.prototxt 
