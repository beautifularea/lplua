#include <iostream>
#include <lua.hpp>
#include <string>

int main()
{
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);
    int x = luaL_dostring(L, "result = {} function Init() result['state'] = 333311102 result['res'] = 'success' return result end");
    if(x)
    {
        std::cout << "x  = " << x << std::endl;
    }

    lua_getglobal(L, "Init");
    if(lua_pcall(L, 0,1,0))
    {
        std::cout << "call 2 error" << std::endl;
    }

    lua_getglobal(L, "result");
    lua_pushstring(L, "state");
    lua_gettable(L, 1);
    if(lua_isboolean(L, -1))
    {
        std::cout << "is number" << std::endl;
    }
    std::cout << "value = " << lua_tostring(L, -1) << std::endl;
}
