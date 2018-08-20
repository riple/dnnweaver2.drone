TELLO_YOLO_HOME=/home/jspark/mac.Projects/tello.yolo.code
cd $TELLO_YOLO_HOME
sudo apt-get install -y python-dev python-virtualenv pkg-config
sudo sudo apt-get install -y libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt-get install ffmpeg
sudo apt-get install --only-upgrade ffmpeg
sudo apt-get install -y graphviz
pip2.7 install --upgrade --user av cython image pandas graphviz
cd $TELLO_YOLO_HOME/TelloPy; ./setup27.sh
cd $TELLO_YOLO_HOME/driver/darkflow; ./setup27.sh 
pip2.7 install --upgrade --user --ignore-installed https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.10.0-cp27-none-linux_x86_64.whl

