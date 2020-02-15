/*
    Raspberry PI MCP23017 joystick driver
    Copyright (C) 2015 Sound Tang
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Modificato per adattarsi alla jammapi
 */
#include <linux/module.h>
#include <linux/workqueue.h>
#include <linux/kernel.h>
#include <linux/input.h>
#include <linux/init.h>
#include <linux/mutex.h>
#include <linux/slab.h>
#include "mcp23017.h"

#define DRIVER_DESC "JoyPi MCP23017 Joystick"

MODULE_AUTHOR("");
MODULE_DESCRIPTION(DRIVER_DESC);
MODULE_LICENSE("GPL");

#define JOYPI_MAX_DEVICES 2

struct JoyPi
{
	struct input_dev *dev[JOYPI_MAX_DEVICES];
	struct workqueue_struct *workqueue;
	struct delayed_work work;
	char name[JOYPI_MAX_DEVICES][64];
	char phys[JOYPI_MAX_DEVICES][32];

	struct MCP23017 *io_expander;

	unsigned long next_poll_jiffies;

	int used;
	struct mutex sem;
};

static struct JoyPi *joy;

// MCP23017 joypi pin mapping
//     +--+
//   8 |OO| 7
//   9 |OO| 6
//  10 |OO| 5
//  11 |OO| 4
//  12 |OO| 3
//  13 |OO| 2
//  14 |OO| 1
//  15 |OO| 0
// VCC |OO|
// GND |OO|
//     |OO| RST
// SDA |OO| A2
// SCL |OO| A1
//     |OO| A0
//     +--+

enum JoystickPins
{
	JOY_AXIS       = 0,
	JOY_UP         = 0,
	JOY_DOWN       = 1,
	JOY_LEFT       = 2,
	JOY_RIGHT      = 3,
 
	JOY_BUTTONS    = 4,
	JOY_SELECT     = 4,
	JOY_START      = 5,
	JOY_COIN       = 6,
	JOY_ALT        = 7,
	JOY_BUTTON0    = 8,
	JOY_BUTTON1    = 9,
	JOY_BUTTON2    = 10,
	JOY_BUTTON3    = 11,
	JOY_BUTTON4    = 12,
	JOY_BUTTON5    = 13,
	JOY_BUTTON6    = 14,
	JOY_BUTTON7    = 15,

	MAX_JOYBUTTONS = 16
};

// available buttons
static const uint16_t g_button_map[MAX_JOYBUTTONS] = {
	0, 0, 0, 0, BTN_BASE3, BTN_BASE4, BTN_BASE5, BTN_BASE6, 
	BTN_TRIGGER, BTN_THUMB, BTN_THUMB2, BTN_TOP, BTN_TOP2, BTN_PINKIE, BTN_BASE, BTN_BASE2 
};
static const uint16_t g_button_mask[MAX_JOYBUTTONS] = { 
	0x0001, 0x0002, 0x0004, 0x0008, 0x0010, 0x0020, 0x0040, 0x0080, // GPIOB
	0x8000, 0x4000, 0x2000, 0x1000, 0x0800, 0x0400, 0x0200, 0x0100  // GPIOA
};

#define POLL_INTERVAL (HZ/100) /* 10 ms */

static void joypi_timer(struct work_struct *private);
static int joypi_open(struct input_dev *dev);
static void joypi_close(struct input_dev *dev);

int __init joypi_init(void)
{
	int err = 0;
	int i, j;

	printk(KERN_INFO "[JOYPI] Initialize.\n");
	joy = (struct JoyPi *)kzalloc(sizeof(struct JoyPi), GFP_KERNEL);
	if(!joy) {
		pr_err("Failed to allocate memory for joypi.");
		goto fail0;	
	}

	mutex_init(&joy->sem);

	joy->io_expander = mcp23017_init();
	if(!joy->io_expander) {
		pr_err("Failed to initialize mcp23017 i2c.");
		goto fail1;
	}

	for(i = 0; i < JOYPI_MAX_DEVICES; ++i)
	{
		struct input_dev *input_dev = joy->dev[i] = input_allocate_device();

		// set all pins to input
		mcp23017_set_iodira(joy->io_expander, i, 0xFF);
		mcp23017_set_iodirb(joy->io_expander, i, 0xFF);
		// enable pullups
		mcp23017_set_gppua(joy->io_expander, i, 0xFF);
		mcp23017_set_gppub(joy->io_expander, i, 0xFF);

		snprintf(joy->name[i], sizeof(joy->name[i]), "JoyPi Joystick %d", i);
		snprintf(joy->phys[i], sizeof(joy->phys[i]), "input%d", i);

		input_dev->name = joy->name[i];
		input_dev->phys = joy->phys[i];
		
		input_dev->id.bustype = BUS_I2C;
		input_dev->id.vendor = 0xDEAD;
		input_dev->id.product = 0;
		input_dev->id.version = 0x0100;

		input_set_drvdata(input_dev, joy);

		input_dev->open = joypi_open;
		input_dev->close = joypi_close;

		input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
		input_set_abs_params(input_dev, ABS_X, -1, 1, 0, 0);
		input_set_abs_params(input_dev, ABS_Y, -1, 1, 0, 0);

		for(j = JOY_BUTTONS; j < MAX_JOYBUTTONS; ++j) {
			set_bit(g_button_map[j], input_dev->keybit);
		}

		err = input_register_device(input_dev);
		if (err) goto fail2;
	}

	return 0;
fail2:
	for(i = 0; i < JOYPI_MAX_DEVICES; ++i)
	{
		if(joy->dev[i]) input_free_device(joy->dev[i]);
	}
	mcp23017_free(joy->io_expander);
fail1:
	kfree(joy);
	joy = NULL;
fail0:
	return err;
}

void __exit joypi_exit(void)
{
	int i;
	if(joy) {
		for(i = 0; i < JOYPI_MAX_DEVICES; ++i)
		{
			if(joy->dev[i]) input_unregister_device(joy->dev[i]);
		}
		mcp23017_free(joy->io_expander);
		kfree(joy);
	}

	printk(KERN_INFO "[JOYPI] Shutdown.\n");
}


static void joypi_timer(struct work_struct *work)
{
	struct JoyPi *joy = (struct JoyPi *)((char *)work - offsetof(struct JoyPi, work));
	int i, j, a, b, v;
	long delay;
	unsigned long flags;

	for(i = 0; i < JOYPI_MAX_DEVICES; ++i)
	{
		struct input_dev *dev = joy->dev[i];

		// report axis
		uint8_t buttons_b = mcp23017_get_gpiob(joy->io_expander, i); // up, down, left, right.. etc..
		uint8_t buttons_a = mcp23017_get_gpioa(joy->io_expander, i);

		uint16_t buttons = ((uint16_t)buttons_b << 8) | buttons_a;

		a = !(buttons & g_button_mask[JOY_LEFT]);
		b = !(buttons & g_button_mask[JOY_RIGHT]);
		input_report_abs(dev, ABS_X, b - a);

		a = !(buttons & g_button_mask[JOY_UP]);
		b = !(buttons & g_button_mask[JOY_DOWN]);
		input_report_abs(dev, ABS_Y, b - a);


		for(j = JOY_BUTTONS; j < MAX_JOYBUTTONS; ++j)
		{
			v = !(buttons & g_button_mask[j]);
			input_report_key(dev, g_button_map[j], v);
		}

		input_sync(dev);
	}

	local_irq_save(flags);
	joy->next_poll_jiffies += POLL_INTERVAL;
	if(jiffies > joy->next_poll_jiffies)
	{
		joy->next_poll_jiffies += ((jiffies - joy->next_poll_jiffies) / POLL_INTERVAL) * POLL_INTERVAL + POLL_INTERVAL;
	}
	delay = joy->next_poll_jiffies - jiffies;

	local_irq_restore(flags);

	queue_delayed_work(joy->workqueue, &joy->work, delay);
}

static int joypi_open(struct input_dev *dev)
{
	struct JoyPi *joy = (struct JoyPi *)input_get_drvdata(dev);
	int err;

	err = mutex_lock_interruptible(&joy->sem);
	if(err) return err;

	if (!joy->used++) {
		joy->workqueue = create_singlethread_workqueue("joypi");
		INIT_DELAYED_WORK(&joy->work, joypi_timer);
		queue_delayed_work(joy->workqueue, &joy->work, 0);
		joy->next_poll_jiffies = jiffies + POLL_INTERVAL;
	}

	mutex_unlock(&joy->sem);

	printk(KERN_INFO "[JOYPI] Opened.\n");
	return 0;
}

static void joypi_close(struct input_dev *dev)
{
	struct JoyPi *joy = (struct JoyPi *)input_get_drvdata(dev);

	mutex_lock(&joy->sem);
	if (!--joy->used) {
		cancel_delayed_work_sync(&joy->work);
		flush_workqueue(joy->workqueue);
		destroy_workqueue(joy->workqueue);
	}
	mutex_unlock(&joy->sem);

	printk(KERN_INFO "[JOYPI] Closed.\n");
}

module_init(joypi_init);
module_exit(joypi_exit);
