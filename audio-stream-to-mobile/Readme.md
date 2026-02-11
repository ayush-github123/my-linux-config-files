# What is this Project?

The bluetooth card of my pc is faulty and hence does not work. My earbud does not connect to it and hence it wasn't connecting to my earbud.
Here comes L2M - Listen2Me !!

# How it works

It uses pipewire.c to capture audio packets via pipewire and then open a udp connection through which the audio packets are transferred to the connected device.

# TODO

The implementation is very minimal - no thourough thought process has been put in this project - this was just a necessity.
Later on I can research about it and then write some GOOD CODE.

# How to use it

1. Clone the Project using:
	```
	git clone https://github.com/ayush-github123/my-linux-config-files.git
	```

2. Simply change the PROJECT_DIR inside the audio.sh file to the path of where the project has been cloned. You can edit the file using nano or nvim or simple VSC.
	```bash
	nano audio.sh
	```
	OR
	```shell
	nvim audio.sh
	```
	OR
	```shell
	code audio.sh
	```
3. make audio.sh executable:
	```bash
	chmod +x <path>
4. run the shell script file:
	```bash
	./audio.sh
	```
