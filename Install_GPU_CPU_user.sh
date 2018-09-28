#! /bin/bash

# Set colours for text input and output

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

# Record user data for miner information

echo "${yellow}Welcome to the automated GPU+CPU miner, written by OvErLoDe (with thanks to Crytogone)${reset}"

echo " "

sleep 3

read -p "${yellow}Please enter the pool address you wish to point your miners to: ${reset}" pool

echo " "

read -p "${yellow}Please enter your wallet addres: ${reset}" wallet

echo " "

read -p "${yellow}Please enter your worker name: ${reset}" worker

echo " "

read -p "${yellow}Please enter the number of threads (For P100 and V100 cards recommended is 4): ${reset}" threads

echo " "

read -p "${yellow}Please enter the batch size (For P100 and V100 cards recommended is 240): ${reset}" batches

echo " "

# Installation of Nvidia Driver v396

echo "${green}Installing Nvidia 396 Driver........Please wait${reset}"
#echo "Installing Nvidia 396 Driver............Please wait"
echo " "

sleep 3

sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
sudo apt install nvidia-396 -y

# Start Nvidia driver and enable nvidia-smi

sudo modprobe nvidia

# Installation of Cuda Toolkit - Silent

cd ~

echo " "

echo "${green}Installing Cuda..........Please wait${reset}"
#echo "Installing Cuda...........Please wait" 
echo " "

sleep 3

wget https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda_9.2.148_396.37_linux
sudo chmod +x cuda_9.2.148_396.37_linux
sudo bash cuda_9.2.148_396.37_linux --silent --toolkit

# Create sym links to enable Cuda to be recognised by Cryptogone's miner

export PATH=/usr/local/cuda-9.2/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# Installation of Cryptogone's miner

echo "${green}Installing Cryptogone's GPU miner.............Please wait${reset}"
#echo "Installing Cryptogone's GPU miner...........Please wait"
echo " "

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
# worker="OvErLoDe"
# pool="http://arionum.rocks"
# wallet="65AkkjBs2arwbikYVDh3B57aeehzpVp9Xw69tgewj8y8stx9FjajNhxR5Y3D9vzjYGgPGzuXbf7xSKn1C2i2DxFY"
# threads="4"
# batches="240"

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

echo " "

echo "${green}Installing Dan's Java miner...............Please wait${reset}"
#echo "Installing Dan's Java miner.......Please wait"
echo " "

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

echo " "

echo "${yellow}To access the GPU miner use - tmux attach -t GPU (you may need to use sudo)${reset}"
#echo "To access the GPU miner use - tmux attach -t GPU (you may need to run as sudo)"

echo " "

echo "${yellow}To access the CPU miner use - tmux attach -t CPU (you may need to use sudo)${reset}"
#echo "To access the CPU miner use - tmux attach -t CPU (you may need to run as sudo)"

echo " "

echo "${red}If you find that the miner does not run, then please edit the file 'mine.sh' and lower the batch size${reset}"

echo " "

echo "${green}Installation complete....please support future development by donating to 65AkkjBs2arwbikYVDh3B57aeehzpVp9Xw69tgewj8y8stx9FjajNhxR5Y3D9vzjYGgPGzuXbf7xSKn1C2i2DxFY${reset}"

sleep 3

