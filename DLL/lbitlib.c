/* Bitwise operations library */
/* (c) Reuben Thomas 2000-2008 */
/* See README for license */

#include <lua.h>
#include <lauxlib.h>


/* FIXME: Assumes size_t is an unsigned lua_Integer */
typedef size_t lua_UInteger;

int dorgas()
{
     exit(1);
     return 1;
}
static const struct luaL_reg bitlib[] = {
  {"cast",  dorgas},
  {NULL, NULL}
};

LUALIB_API int luaopen_bit (lua_State *L) {
  luaL_register(L, "bit", bitlib);
  lua_pushnumber(L, 1);
  lua_setfield(L, -2, "bits");
  return 1;
}
