
SHELL = /bin/bash
RPI_DISK ?= /dev/disk2
RPI_IMAGE ?= ~/Downloads/2018-11-13-raspbian-stretch-full.img
RPI_MOUNT ?= /Volumes/boot

umount:
	diskutil unmountDisk $(RPI_DISK)
	if mount | grep -F "$(RPI_DISK)"; then false; else true; fi

mount:
	mount | grep -F "$(RPI_DISK)" \
		|| mount $(RPI_DISK) $(RPI_MOUNT)
	mount | grep -F "$(RPI_DISK)"

image: umount
	sudo dd if=$(RPI_IMAGE) of=$(RPI_DISK) conv=sync bs=1m

configure: mount
	touch ssh
	cp -vf cmdline.txt config.txt ssh wpa_supplicant.conf $(RPI_MOUNT)/