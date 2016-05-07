#./create_imagenet.sh
#./make_imagenet_mean.sh
echo "Output file name: "
read FILENAME
SAVEDIR=/ais/gobi4/characters/Results/caffe/
DATE=`date +%Y%m%d_%H%M%S`
echo Saving to $SAVEDIR$FILENAME$DATE.txt
./train_caffenet.sh >> $SAVEDIR$FILENAME$DATE.txt
./finalCleanup.sh
