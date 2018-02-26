#include <iostream>  
#include <string>
   
extern "C"  
{  
    #include <lua.h>
    #include <lauxlib.h>  
    #include <lualib.h>
}  

int main()  
{  
    lua_State *L = luaL_newstate();  
       
    lua_pushstring(L, "I am so cool~");   
    lua_pushnumber(L,20);  
   
    if( lua_isstring(L,1)){             
        cout<<lua_tostring(L,1)<<endl;  
    } 
    
    if( lua_isnumber(L,2)){  
        cout<<lua_tonumber(L,2)<<endl;  
    }  

    lua_close(L);  
}
