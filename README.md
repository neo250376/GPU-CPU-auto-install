# GPU-CPU-auto-install (Thanks to Cryptogone for his assistance)

These scripts are primarily intended for GCP Nvidia P100 and V100 graphics instances. If you wish to use the user install then you will need to use the correct thread and batch size for your own graphics cards.

Please refer to https://bitbucket.org/cryptogone/arionum-gpu-miner for more information on different graphics cards settings.

Installation instructions.

If you are installing the GPU and CPU miner manually, download Install_GPU_CPU_user.sh.

sudo chmod +x Install_GPU_CPU_user.sh

./Install_GPU_CPU_user.sh

You will then be prompted for information such as pool address (must be http://address format), wallet address, worker name, threads and batch size.

If you wish to automatically setup a GCP instance, then copy the raw data from Install_GPU_CPU_auto.sh and paste it into the GCP automation box when creating your VM.

After installing, whether using your own computer or a VM you can access the GPU miner by using the following commands -

tmux attach -t GPU (you may need sudo) - this will open tmux with the GPU miner showing.
tmux attach -t CPU (you may need sudo) - this will open tmux with the CPU miner showing.

Press CTRL+B then "d" to exit tmux. Both miners will run in the background and you can disconnect from your VM's ssh connection and they will both continue running.
