#./create_imagenet.sh
#./make_imagenet_mean.sh
echo "Output file name: "
read FILENAME
SAVEDIR=/ais/gobi4/characters/Results/caffe/
DATE=`date +%Y%m%d_%H%M%S`
mkdir $SAVEDIR$DATE
cp solver.prototxt $SAVEDIR$DATE
cp train_val.prototxt $SAVEDIR$DATE
cp deploy.prototxt $SAVEDIR$DATE

echo Saving to $SAVEDIR$DATE/$FILENAME.txt
./train_caffenet.sh >> $SAVEDIR$DATE/$FILENAME.txt

SAVEDIR=$SAVEDIR$DATE
for file in *.caffemodel;
do
        cp $file $SAVEDIR
        rm -rf $file
done 

for file in *.solverstate
do
        cp $file $SAVEDIR
        rm -rf $file
done

#./finalCleanup.sh
