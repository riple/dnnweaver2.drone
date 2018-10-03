#
# x86 Ubuntu 16.04/18.04 
#

sudo apt-get install -y python-dev python-virtualenv pkg-config
sudo apt-get install -y libavformat-dev libavcodec-dev libavdevice-dev libavutil-dev libswscale-dev libavresample-dev
sudo add-apt-repository ppa:jonathonf/ffmpeg-3
sudo apt-get install ffmpeg
sudo apt-get install --only-upgrade ffmpeg
sudo apt-get install -y graphviz cython

python2.7 -m pip install --upgrade --user av cython image pandas graphviz

# tellopy
git clone https://github.com/hanyazou/TelloPy.git
cd Tellopy; python2.7 setup.py bdist_wheel; python2.7 -m pip uninstall -y tellopy; python2.7 -m pip install --upgrade --user dist/tellopy*.whl

# darkflow
git clone https://github.com/thtrieu/darkflow.git
cd darkflow; python2.7 setup.py build_ext --inplace; python2.7 -m pip install --upgrade --user -e .; python2.7 -m pip install --upgrade --user .

# tensorflow
python2.7 -m pip install --upgrade --user --ignore-installed https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.10.0-cp27-none-linux_x86_64.whl

