#! /bin/bash

# Installation of Nvidia Driver v390


sleep 3

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt install nvidia-390 -y

# Start Nvidia driver and enable nvidia-smi

sudo modprobe nvidia

# Install gcc6

sudo apt-get install gcc-6 g++-6 -y

# Tell system that gcc6 is the default

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 50
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 50

# Installation of Cuda Toolkit - Silent

cd ~

sleep 3

wget https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.85_387.26_linux
sudo chmod +x cuda_9.1.85_387.26_linux
sudo bash cuda_9.1.85_387.26_linux --silent --toolkit

# Create sym links to enable Cuda to be recognised by Cryptogone's miner

export PATH=/usr/local/cuda-9.1/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

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

# Revert back to gcc7

sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 50
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 50

sleep 3

