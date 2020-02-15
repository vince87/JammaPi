obj-m += joypi.o
joypi-objs := $(addprefix src/,joypi.o mcp23017.o)
all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
install:
	cp joypi.ko /lib/modules/$(shell uname -r)/kernel/drivers/input/joystick
	depmod -a
