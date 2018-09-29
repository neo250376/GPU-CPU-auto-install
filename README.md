# Cryptogone/ProgrammerDan's Miner Auto Install Scripts
(Thanks to Cryptogone for his assistance)

If you would like to use this on Ubuntu 18.04 please use the file Install_GPU_CPU_auto18.04.sh and copy past the contents into the GCP automation box.

These scripts will install both Cryptogone's GPU miner v1.5.1 and ProgrammerDan's Java miner v0.2.6.1

These scripts are primarily intended for GCP Nvidia P100 and V100 graphics instances. If you wish to use the user install then you will need to use the correct thread and batch size for your own graphics cards. Due to "wget" speeds from Nvidia's servers, please allow up to 10 minutes for the script to install fully. Always check with "top" that "Java" and "arionum_miner" are running.

Installation instructions.

If you are installing the GPU and CPU miner manually on your own rig, download Install_GPU_CPU_user.sh.

1. wget https://github.com/neo250376/GPU-CPU-auto-install/blob/master/Install_GPU_CPU_user.sh

2. sudo chmod +x Install_GPU_CPU_user.sh

3. ./Install_GPU_CPU_user.sh

You will then be prompted for information such as pool address (must be http://address format), wallet address, worker name, threads and batch size.

Please refer to https://bitbucket.org/cryptogone/arionum-gpu-miner for more information on different graphics cards settings.

If you wish to automatically setup a GCP instance, then copy the raw data from Install_GPU_CPU_auto.sh and paste it into the GCP automation box when creating your VM. REMEMBER TO CHANGE THE POOL ADDRESS ETC. TO YOUR OWN SETTINGS FOR BOTH THE GPU MINER AND CPU MINER!!

After installing, whether using your own computer or a VM you can access the GPU or CPU miner by using the following commands -

tmux attach -t GPU (you may need sudo) - this will open tmux with the GPU miner showing.
tmux attach -t CPU (you may need sudo) - this will open tmux with the CPU miner showing.

Press CTRL+B then "d" on it's own to exit tmux. Both miners will run in the background and you can disconnect from your VM's ssh connection and they will both continue running.
