#!/bin/bash

if [ $# -ne 4 ]; then
	echo "Usage: ./driver.sh <drone|webcam> <tf-cpu|tf-gpu|dnnweaver2> <tf-weight.pickle> <dnnweaver2-wegiht.pickle>"
	exit
fi

CAM_SRC=$1
YOLO_ENGINE=$2
TF_WEIGHT_PICKLE=$3
DW2_WEIGHT_PICKLE=$4

if [[ "$CAM_SRC" = *"webcam"* ]]; then
	rmmod uvcvideo
	modprobe uvcvideo nodrop=1 timeout=10000 quirks=0x80
fi

python driver.py $CAM_SRC $YOLO_ENGINE $TF_WEIGHT_PICKLE $DW2_WEIGHT_PICKLE

