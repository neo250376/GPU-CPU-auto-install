#!/bin/bash

echo "Installing Cuda...........Please wait" 

sleep 3

wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
sudo chmod +x cuda_9.2.148_396.37_linux
sudo bash cuda_9.2.148_396.37_linux --silent --toolkit
export PATH="$PATH:/usr/local/cuda-9.2/bin"

sudo chmod 777 /etc/ld.so.conf
sudo echo "/usr/local/cuda-9.2/lib64" >> /etc/ld.so.conf
sudo ldconfig

echo "Installing Cryptogone's GPU miner...........Please wait"

sleep 5

sudo apt-get install git
git clone https://bitbucket.org/cryptogone/arionum-gpu-miner.git
cd arionum-gpu-miner

./setup_libs.sh linux 

./setup_submodules.sh 

./gen_prj.sh linux

./make_release_linux.sh

cd rel/v1.5.1-linux

echo '# please change pool address, wallet address and worker ID to yours
# adjust -b & -t value as described in the README and FAQ
worker="OvErLoDe"
pool="http://arionum.rocks"
wallet="65AkkjBs2arwbikYVDh3B57aeehzpVp9Xw69tgewj8y8stx9FjajNhxR5Y3D9vzjYGgPGzuXbf7xSKn1C2i2DxFY"
threads="4"
batches="240"

# set this to false if you do not want miner to auto relaunch after crash
relaunch_miner_on_crash="true"

while :
do
    # -u means use all device, you can also use -d to specify list of devices (ex: -d 0,2,5)
    ./arionum-cuda-miner -u -b "$batches" -t "$threads" -p "$pool" -a "$wallet" -i "$worker"
    
    if [ "$relaunch_miner_on_crash" = "true" ]; then
        echo "miner crashed, relaunching in 5 seconds ..."
        sleep 5
    else
        break
    fi
done' > run.sh
sudo chmod +x run.sh
tmux new-session -d -s GPU './run.sh'

echo "Installing Dan's Java miner.......Please wait"

sleep 5

cd
set -x #echo off
sudo apt-get update
sudo apt-get install openjdk-8-jdk maven git gcc make -y
sudo apt-get install build-essential -y
cd 
git clone git://github.com/Programmerdan/arionum-java
cd arionum-java/arionum-miner
git checkout master
touch config.cfg
sudo chmod 755 config.cfg
echo "pool
http://arionum.rocks
65AkkjBs2arwbikYVDh3B57aeehzpVp9Xw69tgewj8y8stx9FjajNhxR5Y3D9vzjYGgPGzuXbf7xSKn1C2i2DxFY
`nproc`
standard
true
`hostname`" > config.cfg
mvn clean package
sudo chmod +x build-argon.sh
./build-argon.sh
sudo chmod +x run.sh
tmux new-session -d -s CPU './run.sh'

echo "To access the GPU miner use - tmux attach -t GPU"

echo " "

echo "To access the CPU miner use - tmux attach -t CPU"

echo " "

echo "Installation complete.................."

sleep 3
