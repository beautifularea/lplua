lua_newtable(L);
int top = lua_gettop(L);

for (std::map::iterator it = mymap.begin(); it != mymap.end(); ++it) {
    const char* key = it->first.c_str();
    const char* value = it->second.c_str();
    lua_pushlstring(L, key, it->first.size());
    lua_pushlstring(L, value, it->second.size());
    lua_settable(L, top);
}
