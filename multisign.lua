#!/usr/local/bin/lua

local function hash(sourceAddress, address)
    local hashValue = sourceAddress..address
    return hashValue
end

local function Split(szFullString, szSeparator)
local nFindStartIndex = 1
local nSplitIndex = 1
local nSplitArray = {}
while true do
   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
   if not nFindLastIndex then
    nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
    break
   end
   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
   nSplitIndex = nSplitIndex + 1
end
return nSplitArray
end

local function serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{"
    for k, v in pairs(obj) do
        lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
        for k, v in pairs(metatable.__index) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ","
        end
    end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end

local function unpack(obj)
    local str = serialize(obj['res'])

    str = string.gsub(str, '\\', '')
    str = string.gsub(str, '\"', '')
    str = string.gsub(str, '%]', '')
    str = string.gsub(str, '%[', '')

    print('str = '..str)
    local x = Split(str, ',')

    local table_ = {}
    for i=1, #x do
        sss, eee = string.find(x[i], '=')
        print(sss , eee)
        if(eee) then
            local key = string.sub(x[i], 1, eee-1)
            local value = string.sub(x[i], eee+1, #x[i])
            
            print('key = '..key)
            print('value = '..value)

            table_[key] = value
        end
    end

    return table_
end

defaultParam = {'0','TDstAccountID', 'TEnginePointer', 'TTxn', 'TEnginePointerHash', 'TTxnHash'}
local function isDefaultParams(v)
    for i = 1, #defaultParam do
        if(v == defaultParam[i]) then
            return true
        end
    end

    return false
end

local function isExistInSignedTable(t, h)
    local str
    for k,v in pairs(t) do
        if (k == h) then
            str = str..k
        end
    end

    return str
end

local function asASignerAddressIsInvokePayment(t, sourceAddress, address)
    local hashValue = hash(sourceAddress, address)

    local v = t[hashValue]
    if(v ~= nil) then
	return true
    else
	t[hashValue] = '0'
	return false
    end
end

local function constructSignTable(t)
    local sourceAddress = t['0']

    local needToSignedTable = {}
    for k,v in pairs(t) do
	local address = t[k]
        if (isDefaultParams(k) == false) then
            local address = t[k]
            local hashValue = hash(sourceAddress, address)
            needToSignedTable[hashValue] = address
        end
    end

    return needToSignedTable
end

local function updatePaidTransactionTable(t, paidTable)
    local serializePaidTransactionTableToString = serialize(paidTable)

    local sourceAddress = t['0']

    local firstParam = t['TDstAccountID']
    local secondParam = hash(firstParam, sourceAddress)
    
    local value = serializePaidTransactionTableToString;

    t['0'] = firstParam
    t['1'] = secondParam
    t['2'] = value

    result = scStateStorage(t)

    return result
end

result = {}
function Init(t)
    local alreadySignedTable = constructSignTable(t)

    local serializedAlreadySignedTableToString = serialize(alreadySignedTable)

    local firstParam = t['TDstAccountID']
    local secondParam = firstParam
    local value = serializedAlreadySignedTableToString

    t['0'] = firstParam
    t['1'] = secondParam
    t['2'] = value

    result = scStateStorage(t)

    return result
end

local function getSignedTable(t)
    local firstParam = t['TDstAccountID']
    local secondParam = firstParam

    t['0'] = firstParam
    t['1'] = secondParam

    local signedTable = scStateGet(t)
    
    return signedTable
end

local function getPaidTransactionTable(t)
    local sourceAddress = t['0']

    local firstParam  = t['TDstAccountID']
    local secondParam = hash(firstParam, sourceAddress)

    t['0'] = firstParam
    t['1'] = secondParam

    local paidTable = scStateGet(t)
    return paidTable
end

function foo(t)
    local paidTable = {}

    local sourceAddress = t['0']
    local signedAddress = t['1']

    local signedTable = getSignedTable(t)

    local str = serialize(signedTable['res'])
    
    str = string.gsub(str, '\\', '')
    str = string.gsub(str, '\"', '')
    str = string.gsub(str, '%]', '')
    str = string.gsub(str, '%[', '')
    str = string.gsub(str, '\"', '')

    local x = Split(str, ',')
    local table_ = {}
    for i=1, #x do
        sss, eee = string.find(x[i], '=')
        print(sss , eee)
        if(eee) then
            local key = string.sub(x[i], 1, eee-1)
            local value = string.sub(x[i], eee+1, #x[i])

            table_[key] = value
        end
    end

    local hashValue = hash(sourceAddress, signedAddress)

    if(table_[hashValue] == nil) then
        result['state'] = 0
        result['res'] = 'address not on signedTable!'..' sourceAddress = '..sourceAddress..' signedAddress = '..signedAddress..' hashValue = '..hashValue..' signedTable = '..serialize(table_)
        return result
    end

    local paidTable = getPaidTransactionTable(t)

    str = serialize(paidTable['res'])
    
    str = string.gsub(str, '\\', '')
    str = string.gsub(str, '\"', '')
    str = string.gsub(str, '%]', '')
    str = string.gsub(str, '%[', '')
    str = string.gsub(str, '\"', '')

    x = Split(str, ',')
    for i=1, #x do
        sss, eee = string.find(x[i], '=')
        print(sss , eee)
        if(eee) then
            local key = string.sub(x[i], 1, eee-1)
            local value = string.sub(x[i], eee+1, #x[i])
            
            print('key = '..key)
            print('value = '..value)

            table_[key] = value
        end
    end

    local ready = asASignerAddressIsInvokePayment(table_, sourceAddress, signedAddress)
    if(ready) then
        result['state'] = 1
        result['res'] = 'already paid once.'

        return result
    else
        updatePaidTransactionTable(t, paidTable)
	
	      result['state'] = 1
	      result['res'] = 'signed success'
    end

    return result
end
