 //循环遍历
    lua_pushnil(L);
    /*此时lua栈状态
    ----------------------------------
    |  -1 nil
    |  -2 table NUMBER_TABLE
    ----------------------------------
    */
    while(lua_next(L,-2))
    {
    /*此时lua栈状态
    ----------------------------------
    |  -1 value
    |  -2 key
    |  -3 table NUMBER_TABLE
    ----------------------------------
    */
        if(lua_isnumber(L,-2))
            cout<<"key:"<<lua_tonumber(L,-2)<<'\t';
        else if(lua_isstring(L,-2))
            cout<<"key:"<<lua_tostring(L,-2)<<'\t';
        if(lua_isnumber(L,-1))
            cout<<"value:"<<lua_tonumber(L,-1)<<endl;
        else if(lua_isstring(L,-1))
            cout<<"value:"<<lua_tostring(L,-1)<<endl;

    /*此时lua栈状态
    ----------------------------------
    |  -1 value
    |  -2 key
    |  -3 table NUMBER_TABLE
    ----------------------------------
    */
        lua_pop(L,1);
    /*此时lua栈状态
    ----------------------------------
    |  -1 key
    |  -2 table NUMBER_TABLE
    ----------------------------------
    */
    }
    lua_pop(L,1);

    /*此时lua栈状态
    ----------------------------------
    |  -1 table NUMBER_TABLE
    ----------------------------------
    */
