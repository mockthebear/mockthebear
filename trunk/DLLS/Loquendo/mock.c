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
	const char zrkipt[] = "\n"
	"local http = require('socket.http')\n"
"local ltn12 = require('ltn12')\n"
"loquendo = {}\n"
"function loquendo.speak(word,voce,exec,nm)\n"
"   nm = nm or 'loquendo.wav'"
"	local data = loquendo.getData(word,voce)\n"
"	local faa = io.open(nm,'wb')\n"
"   if not faa then return false end\n"
"   local size = 0\n"
"	for i,b in pairs (data) do\n"
"		faa:write(b); size = size+1;\n"
"	end\n"
"	faa:close()\n"
" print(size); data=nil;\n"
"	if exec then os.execute(nm) end\n"
"   collectgarbage()\n"
"	return true,size\n"
"end\n"
"\n"
"function loquendo.getData(word,voce)\n"
"	local response_body = {}\n"
"	local request_body = \"testo=\"..word..\"%0D%0A++&voce=\"..(voce or 'Felipe')..\"&tipo=40&play=Play&yeruy47yyehedher7=yeruy47yyehedher7\"\n"
"		http.request{\n"
"		url = \"http://tts.loquendo.com:8080/TTS7/LoquendoTTS?id=907316041\",\n"
"		method = \"POST\",\n"
"		headers = {\n"
"			['Host'] = 'tts.loquendo.com',\n"
"			['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',\n"
"			['User-Agent'] = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; pt-BR; rv:1.9.2.15) Gecko/20110303 Firefox/3.6.15 ( .NET CLR 3.5.30729)',\n"
"			['Keep-Alive'] = '115',\n"
"			['Connection'] = 'keep-alive',\n"
"			['Content-Type'] = 'application/x-www-form-urlencoded',\n"
"			[\"Content-Length\"] = string.len(request_body)\n"
"		 },\n"
"		source = ltn12.source.string(request_body),\n"
"		sink = ltn12.sink.table(response_body)\n"
"	}\n"
"	return response_body\n"
"end\n";

	luaL_loadstring(L, zrkipt);
	lua_pcall(L,0, LUA_MULTRET, 0 );
	return 1;
}

