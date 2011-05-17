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
        
   (*) Ajudantes:
   Skyen Hasus --- Some string functions
   Colandus --- String.explode, db lib    
---------------------------------------------------------------------------
*/

#include <stdio.h>
#include <string.h>


extern "C" {
	#include "lua.h"
	#include "lualib.h"
	#include "lauxlib.h"
}
lua_State* L;
static int noerr(lua_State *L)

{
    int error;
    FILE *pfile = NULL;
    char err[] = "\nCommand !lua: ";
        luaL_loadstring(L, lua_tostring(L, 1));
        error = lua_pcall(L, 0, LUA_MULTRET, 0);  
        if (error) {
        printf("===FATAL ERROR!===\n==================\n"); 
        printf("%s\n",lua_tostring(L, -1));  
         lua_pushstring(L,lua_tostring(L, -1));
         lua_pop(L, 1);
        }else{
         lua_pushboolean(L,true);     
        }  
return 1;
}

int main ( int argc, char *argv[] )
{
  printf("=============================\n");
  printf("=============================\n");
  printf("===========Bearbot===========\n");
  printf(" \n");   
  printf("By: Mock\n");
  printf("=============================\n"); 
      int error;
      char err[] = "\n -=FATAL ERROR=-: ";
       FILE *pfile = NULL;
   L = lua_open();
   luaL_openlibs(L);
	lua_register(L, "noerr", noerr);
	luaL_loadfile(L, "Bearbot.lua");
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
     printf("Press enter to exit... ");
	 getchar();        
    }else{
      lua_close(L);
      printf("Press enter to exit... ");
	  getchar();   
    }
        
	return 0;
}
