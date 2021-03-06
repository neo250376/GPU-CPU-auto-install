#! /bin/bash

# Installation of Nvidia Driver v396


sleep 3

wget http://uk.download.nvidia.com/tesla/396.44/NVIDIA-Linux-x86_64-396.44.run
sudo chmod +x NVIDIA-Linux-x86_64-396.44.run
sudo ./NVIDIA-Linux-x86_64-396.44.run --silent

# Start Nvidia driver and enable nvidia-smi

sudo modprobe nvidia

# Installation of Cuda Toolkit - Silent

cd ~

sleep 3

wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
sudo chmod +x cuda_9.2.148_396.37_linux
sudo bash cuda_9.2.148_396.37_linux --silent --toolkit

# Create sym links to enable Cuda to be recognised by Cryptogone's miner

export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Installation of Cryptogone's miner

sleep 5

sudo apt-get install git
git clone https://bitbucket.org/cryptogone/arionum-gpu-miner.git
cd arionum-gpu-miner

./setup_libs.sh linux 

./setup_submodules.sh 

./gen_prj.sh linux

./make_release_linux.sh

cd rel/v1.5.1-linux

# Creation of miner configuration file

echo '#! /bin/bash

# please change pool address, wallet address and worker ID to yours
# adjust -b & -t value as described in the README and FAQ
worker="OvErLoDe"
pool="http://arionum.rocks"
wallet="WALLET_ADDRESS"
threads="4"
batches="238"

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
done' > mine.sh
sudo chmod +x mine.sh
tmux new-session -d -s GPU './mine.sh'

# Installation of Dan's Java miner

sleep 5

cd

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
WALLET_ADDRESS
`nproc`
standard
true
`hostname`" > config.cfg
mvn clean package
sudo chmod +x build-argon.sh
./build-argon.sh
sudo chmod +x run.sh
tmux new-session -d -s CPU './run.sh'

sleep 3

