/*
-------------------------------------------------------------------------
  Copyright (c) 2009, Matheus Braga (mock_otnet@hotmail.com)
  All rights reserved.

  Redistribução do codigo fonte ou binários, com ou sem a modificação,
  é permitida contanto que as seguintes circunstâncias
  sejão segidas:

      * As redistribuções do código fonte devem conter os creditos
        citados acima.
      * Ao repassar algo modificado deve-se incluir um documento
        de texto informando o que foi modificado.
      * Não alterar os creditos, nem o nome de qualquer pessoa que
        tenha ajudado em algo sem permissao.
      * Não postar conteudo compilado diferente da source modifcada,
        e sempre que postar algo modificado postar junto o codigo fonte.
---------------------------------------------------------------------------
*/

#include <stdio.h>
#include <string.h>
#include <windows.h>
#include <iostream>


extern "C" {
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}


static int hideWindow(lua_State *L)
{
       ShowWindow( GetConsoleWindow(), SW_HIDE );
}
static int showWindow(lua_State *L)
{
 ShowWindow( GetConsoleWindow(), SW_RESTORE );
}
int main ( int argc, char *argv[] )
{
	printf("=============================\n");
	printf("=============================\n");
	printf("By: Mock\n");
	printf("Opening run.wlua\n");
	printf("=============================\n");
      int error;
      char err[] = "\n -=FATAL ERROR=-: ";
       FILE *pfile = NULL;
	lua_State *L = lua_open();
	luaL_openlibs(L);
	lua_register(L, "hideWindow", hideWindow);
	lua_register(L, "showWindow", showWindow);
	luaL_loadfile(L, "run.wlua");
	error = lua_pcall(L,0, LUA_MULTRET, 0 );
	if (error)
	{
     printf("===FATAL ERROR!===\n==================\n");
     printf("%s\n",lua_tostring(L, -1));
     char *filename = "Lua erros.txt";
     pfile = fopen(filename, "a+");
     if(pfile == NULL)
     {
      printf("Error opening %s for writing.", filename);
      }
      else
      {
     strcat(err, lua_tostring(L, -1));
      fputs(err, pfile);
      fclose(pfile);
      }
     lua_pop(L, 1);
     lua_close(L);
     printf("==================\n");
    }else{
      lua_close(L);


    }
    //printf("Pressione enter para fechar!");
   // getchar();
	return 0;
}
