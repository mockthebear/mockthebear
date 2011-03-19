#define LUA_MOCK_VERSION	"1.0.1"

#define LUA_LIB


	#include "lua.h"
	#include "lauxlib.h"


#include "stdio.h"





static int chupz(lua_State *L)
{
	getchar();
  return 1;
}

static const struct luaL_Reg bit_funcs[] = {
  { "chupz",	chupz },
  { NULL, NULL },
};



LUALIB_API int luaopen_mock(lua_State *L)
{

	luaL_register(L, "mock", bit_funcs);
	return 1;
}

