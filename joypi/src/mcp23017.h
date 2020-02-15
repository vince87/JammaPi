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
#ifndef MCP23017_H
#define MCP23017_H

#include <linux/types.h>

struct MCP23017;

struct MCP23017 *mcp23017_init(void);
void mcp23017_set_iodira(struct MCP23017 *m, uint8_t id, uint8_t pins);
void mcp23017_set_iodirb(struct MCP23017 *m, uint8_t id, uint8_t pins);
void mcp23017_set_gppua(struct MCP23017 *m, uint8_t id, uint8_t pins);
void mcp23017_set_gppub(struct MCP23017 *m, uint8_t id, uint8_t pins);
uint8_t mcp23017_get_gpioa(struct MCP23017 *m, uint8_t id);
uint8_t mcp23017_get_gpiob(struct MCP23017 *m, uint8_t id);
void mcp23017_set_olata(struct MCP23017 *m, uint8_t id, uint8_t pins);
void mcp23017_set_olatb(struct MCP23017 *m, uint8_t id, uint8_t pins);
void mcp23017_free(struct MCP23017 *m);

#endif
