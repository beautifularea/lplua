    lua_State* L = luaL_newstate();
    lua_openlibs(L);
    
    luaL_dostring(L, "function Init() result = {} result['state'] = 4321 result['res'] = 'DONE' return result end");
    lua_getglobal(L, "Init");
    if(lua_pcall(L, 0,1,0))
    {
        std::cout << "call 2 error" << std::endl;
    }

    lua_pushnil(L);
    while(lua_next(L, -2) != 0)
    {
        if(lua_isnumber(L, -1))
        {
            std::cout << "number value = " << lua_tonumber(L, -1) << std::endl;
        }
        else if (lua_isstring(L, -1))
        {
            std::cout << "string value = " << lua_tostring(L, -1) << std::endl;
        }

        lua_pop(L, 1);
    }
    
    /*
    {
      lua_pushstring(L, "state");
      lua_gettable(L, -2);
      std::cout << "state = " << lua_tostring(L, -1) << std::endl;
      lua_pop(L, -1);
      
      //在取res的时候，get nil，-2位置中已经不是table了！WHY???
      lua_pushstring(L, "res");
      lua_gettable(L, -2);
      std::cout << "res = " << lua_tonumber(L, -1) << std::endl;
      lua_pop(L, -1);
    }
    */

    lua_close(L);
    
    
