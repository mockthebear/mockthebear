/*
----------------------------------------------------------------------
-- Tibiando - an opensource audio API to open tibia servers
----------------------------------------------------------------------
--
----------------------------------------------------------------------
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software Foundation,
-- Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
----------------------------------------------------------------------


Copyright (C) 2010  Matheus Braga Almeida
*/
#include <stdio.h>
#include <iostream>
#if       _WIN32_WINNT < 0x0500
  #undef  _WIN32_WINNT
  #define _WIN32_WINNT   0x0500
#endif
#include <windows.h>
extern "C" {
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}

#include <tlhelp32.h>
#include <irrKlang.h>
using namespace irrklang;
//#pragma comment(lib, "irrKlang.lib")


/* the Lua interpreter */
lua_State* Lua;
ISoundEngine* engine;
irrklang::ISound* snd;
DWORD CountProcesses(CHAR *pProcessName)
{
    DWORD dwCount = 0;
    HANDLE hSnap = NULL;
    PROCESSENTRY32 proc32;

    if((hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)) == INVALID_HANDLE_VALUE)
        return 0;
    proc32.dwSize=sizeof(PROCESSENTRY32);
	while((Process32Next(hSnap, &proc32)) == TRUE){		
		// if((const char*)proc32.szExeFile == pProcessName)
		if(_wcsicmp (proc32.szExeFile,L"Tibia.exe") == 0){     
            ++dwCount;
		}
	}

    CloseHandle(hSnap);
    return dwCount;
}
static int running(lua_State *Lua)
{
     DWORD qq;
     qq = CountProcesses((CHAR *)lua_tostring(Lua, 1)); 
     lua_pushnumber(Lua,qq);
     return true;
}
static int hideWindow(lua_State *Lua)
{
   ShowWindow( GetConsoleWindow(), SW_HIDE );
   return 1;
}
static int showWindow(lua_State *Lua)
{
 ShowWindow( GetConsoleWindow(), SW_RESTORE );
 return 1;
}
static int ispl(lua_State *Lua){
	if (engine->isCurrentlyPlaying(lua_tostring(Lua, 1))){
		lua_pushboolean(Lua,true);
	}else{
		lua_pushboolean(Lua,false);
	}
		return 1;
}


static int pause(lua_State *Lua){
		engine->stopAllSounds();
		return 1;
}
static int play(lua_State *Lua)
{
	if (engine->play2D(lua_tostring(Lua, 1),false))
	{
		lua_pushboolean(Lua,true);
	}else{
		lua_pushboolean(Lua,false);
	}
    return 1 ;
}
static int play2(lua_State *Lua)
{
	if (engine->play2D(lua_tostring(Lua, 1),true))
	{
		lua_pushboolean(Lua,true);
	}else{
		lua_pushboolean(Lua,false);
	}
    return 1 ;
}
static int drop(lua_State *Lua)
{
	engine->drop();
    return 1 ;
}
int main ( int argc, char *argv[] )
{
	printf("Tibiando By mock the bear.\n");
	ShowWindow( GetConsoleWindow(), SW_HIDE );
	engine = createIrrKlangDevice();
	lua_State *Lua = lua_open();
	luaL_openlibs(Lua);
	lua_register(Lua, "hideWindow", hideWindow);
	lua_register(Lua, "showWindow", showWindow);
	lua_register(Lua, "playMusic",play);
	lua_register(Lua, "playMusicLoop",play2);
	lua_register(Lua, "drop",drop);
	lua_register(Lua, "pauseAll",pause);
	lua_register(Lua, "isRunning",running);
	lua_register(Lua, "isPlaying",ispl);
	
	luaL_loadfile(Lua, "run.lua");
	if (lua_pcall(Lua,0, LUA_MULTRET, 0 )){
		printf("===FATAL ERROR!===\n==================\n"); 
		printf("%s\n",lua_tostring(Lua, -1));  
		char *filename = "Lua erros.txt";
		lua_pop(Lua, 1);
		lua_close(Lua);
		printf("==================\n");           
    }else{
      lua_close(Lua);
    }
    printf("Pressione enter para fechar!");
    getchar();
	return 0;
}

