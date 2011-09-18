/*
Luaduino 1.0 GLPL license

Copyright © 20011 Matheus Braga - Matheus.mtb7@gmail.com

Please do not remove the credits.
*/
#define LUA_LUADUINO_VERSION    "1.0.0"
#include "SerialClass.h"
#define LUA_LIB
extern "C" {
	#include "lua.h"
	#include "lauxlib.h"
}
#include "stdio.h"
#include <iostream>
using namespace std;
Serial* arduino;
static int conectArduino(lua_State *Lua){
	arduino = new Serial((char *)lua_tostring(Lua, 1));
	lua_pushboolean(Lua,arduino->IsConnected());
	lua_pushstring(Lua,arduino->getErrorMessage());
	return 2;
}

static int isConected(lua_State *Lua){
	lua_pushboolean(Lua,arduino->IsConnected());
	return 1;
}

static int getErrorMessage_(lua_State *Lua){
	lua_pushstring(Lua,arduino->getErrorMessage());
	return 1;
}

static int arduinoWriteData(lua_State *Lua){
	char *name = (char *)lua_tostring(Lua, 1);
	lua_pop(Lua, 1);
	int size = lua_tonumber(Lua, 0);
	lua_pushboolean(Lua,arduino->WriteData(name, size));
	return 1;
}

static int arduinoReadData(lua_State *Lua){
	int size = lua_tonumber(Lua, 1);
	if (size == -1){
        size = arduino->GetLenInQueue();
	}
	char msg[size];
    int reading = arduino->ReadData(msg,size);
    lua_pushstring(Lua,msg);
    lua_pushnumber(Lua,reading);
	return 2;
}
static int arduinoGetLenInQueue(lua_State *Lua){
    lua_pushnumber(Lua,arduino->GetLenInQueue());
	return 1;
}

static const struct luaL_Reg luaduino_funcs[] = {
    {"conectArduino",conectArduino},
    {"isConected",isConected},
    {"getErrorMessage",getErrorMessage_},
    {"writeData",arduinoWriteData},
    {"readData_",arduinoReadData},

    {"getLenInQueue",arduinoGetLenInQueue},
    { NULL, NULL },
};

extern "C" int __declspec(dllexport) luaopen_luaduino(lua_State *L)
{
	luaL_register(L, "luaduino", luaduino_funcs);
	const char* todo = "luaduino.readData = function(size)\n"
	"local s,len = luaduino.readData_(size)\n"
	"if len >= 0 then\n"
	"return s:sub(1,len),len\n"
	"else\n"
	"return nil,len\n"
	"end\n"
	"end\n";
	luaL_loadstring(L, todo);
	lua_pcall(L,0, LUA_MULTRET, 0 );
	return 1;
}

