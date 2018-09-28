# GPU-CPU-auto-install

Installation instructions.

If you are installing the GPU and CPU miner manually, download Install_GPU+CPU_user.sh.

sudo chmod +x Install_GPU+CPU_user.sh

./Install_GPU+CPU_user.sh

If you wish to automatically setup a GCP instance, then copy the raw data from Install_GPU+CPU_auto.sh and paste it into the GCP automation box when creating your VM.

After installing, whether using your own computer or a VM you can access the GPU miner by using the following commands -

tmux attach -t GPU (you may need sudo) - this will open tmux with the GPU miner showing
tmux attach -t CPU (you may need sudo) - this will open tmux with the CPU miner showing

Press CTRL+B then "d" to exit tmux. Both miners will run in the background and you can disconnect from your VM's ssh connection and they will both continue running
