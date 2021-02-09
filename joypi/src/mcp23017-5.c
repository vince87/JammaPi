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
 */
#include <linux/i2c.h>
#include <linux/slab.h>
#include "mcp23017.h"

#define MCP23017_IODIRA    0x00
#define MCP23017_IODIRB    0x01
#define MCP23017_IPOLA     0x02
#define MCP23017_IPOLB     0x03
#define MCP23017_GPINTENA  0x04
#define MCP23017_GPINTENB  0x05
#define MCP23017_DEFVALA   0x06
#define MCP23017_DEFVALB   0x07
#define MCP23017_INTCONA   0x08
#define MCP23017_INTCONB   0x09
#define MCP23017_IOCONA    0x0A
#define MCP23017_IOCONB    0x0B
#define MCP23017_GPPUA     0x0C
#define MCP23017_GPPUB     0x0D
#define MCP23017_INTFA     0x0E
#define MCP23017_INTFB     0x0F
#define MCP23017_INTCAPA   0x10
#define MCP23017_INTCAPB   0x11
#define MCP23017_GPIOA     0x12
#define MCP23017_GPIOB     0x13
#define MCP23017_OLATA     0x14
#define MCP23017_OLATB     0x15

#define MAX_MCP23017_CLIENTS 8

struct MCP23017
{
	struct i2c_adapter *adapter;
	struct i2c_client *client[MAX_MCP23017_CLIENTS];
};

struct MCP23017 *mcp23017_init(void)
{
	int i;
	struct MCP23017 *m = kzalloc(sizeof(struct MCP23017), GFP_KERNEL);
	if(m) {
		m->adapter = i2c_get_adapter(0);
		for(i = 0; i < MAX_MCP23017_CLIENTS; ++i) {
			m->client[i] = i2c_new_dummy_device(m->adapter, 0x20 + i);
		}
	}

	return m;
}

void mcp23017_set_iodira(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_IODIRA, pins);
}

void mcp23017_set_iodirb(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_IODIRB, pins);	
}

void mcp23017_set_gppua(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_GPPUA, pins);
}

void mcp23017_set_gppub(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_GPPUB, pins);
}

uint8_t mcp23017_get_gpioa(struct MCP23017 *m, uint8_t id)
{
	return i2c_smbus_read_byte_data(m->client[id], MCP23017_GPIOA);
}

uint8_t mcp23017_get_gpiob(struct MCP23017 *m, uint8_t id)
{
	return i2c_smbus_read_byte_data(m->client[id], MCP23017_GPIOB);
}

void mcp23017_set_olata(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_OLATA, pins);
}

void mcp23017_set_olatb(struct MCP23017 *m, uint8_t id, uint8_t pins)
{
	i2c_smbus_write_byte_data(m->client[id], MCP23017_OLATB, pins);
}

void mcp23017_free(struct MCP23017 *m)
{
	int i;
	for(i = 0; i < MAX_MCP23017_CLIENTS; ++i) {
		i2c_unregister_device(m->client[i]);
	}
	i2c_put_adapter(m->adapter);
	kfree(m);
}
