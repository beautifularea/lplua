--[[ 数据结构:
{
　　"result":{
　　　　"engine_result":"tesSUCCESS",
　　　　"ContractAddress":"jxxxxxxp",
　　　　"balance":"1000",
　　　　"currency":"z",
		"approve" : {
			"arg" : {
			"owner" : "jxxxxj",
			"value" : "10"},
			"arg" : {
			"owner" : "jxxxxj1",
			"value" : "11"},
				
		}
　　}
}
--]]
--
--
--获取代币名词
result = {}
function Init(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
end

local function name()
	result['state'] = 1
	result['res']   = 'Zombie'
	return result
end

function foo(...)
	result = name()
	return result
end

--
--
--获取symbol
result = {}
local function symbol()
	result['state'] = 1
	result['res'] = 'Z'
	return result
end

function Init(...)
	result['state'] = 1
	result['res'] = 'success'
	return result
end

function foo(...)
	result = symbol()
	return result
end

--
--
--获取decimals
result = {}
local function decimals()
	result['state'] = 1
	result['res']   = '18'
	return result
end

function Init(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
end

function foo(...)
	result = decimals()
	return result
end

--
--
--发行僵尸币：总量 10 ** 18
result = {}; 
function Init(...) 
	--[僵尸币]发行总数
	local decimals    = 18
	local totalSupply = 10 ** decimals
	local address     = '6a66665070683739325270336a31516776596b6a397074646b48416f4c7355415148'
	a = {}
	for k, v in ipairs({...})
	do
		a[k] = v
	end

	result = scStateStorage(address, totalSupply, "totalSupply")  

	return result  
end;  

function foo(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
end

--
--
--查询僵尸币totalSupply
result = {}
local function totalSupply(...)
	local a = {}
	for k,v in ipairs({...})
	do
		a[k] = v
	end

	result = scStateGet(a[1],a[2],a[4],a[5])
	return ret
end

function Init(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
end

function foo(...)
	result = totalSupply(...)
	return result
end

--
--
--查询balance
--参数： 待查询的地址 , "balance"
result = {}
local function balanceOf(...)
	a = {}
	for k,v in ipairs({...})
	do
		a[k] = v
	end

	result = scStateGet(a[1], a[2])
	return result
end

function Init(...)
	result['state'] = 1
	result['res']   = 'success'

	return result
end

function foo(...)
	result = balanceOf(...)
	return result
end

--
--
--交易 transfer
--参数：owner, spender, value
result = {}
function Init(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
end

local function transfer( ... )
	a = {}
	for k,v in ipairs({...})
	do
		a[k] = v
	end

	local ownerAddress   = a[1]
	local spenderAddress = a[2]
	local value          = a[3]

	local balance = 'balance'
	local approve = 'approve'

	result = scStateGet(ownerAddress, balance) --owner balance
	local ownerBalance = result['res']

	result = allowance(ownerAddress, spenderAddress)
	local ownerApprovedValue = result['res']
	if (ownerBalance + ownerApprovedValue < value); then
		result['state'] = 0
		result['res']   = 'Insufficient amount'
		return result
	else
		result = blanceOf(spenderAddress)
		local spenderBalance = value + result['res']
		result = scStateStorage(spenderAddress, spenderBalance, balance)

		result = balanceOf(ownerAddress)
		local ownerBalance = result['res'] - value
		result = scStateStorage(ownerAddress, ownerBalance, balance)
		return result
	end
end

function foo(...)
	result = transfer(...)
	return result
end

--
--
--授权
--参数: ownerAddress, spenderAddress, value
result = {} 
function Init(...) 
    result['state'] = 1 
    result['res']   = 'success' 
    return result 
end 
 
local function getBalance(obj)
    str = serialize(obj)
    s, e = string.find(str, 'ContractState')
    if(e) then
        ss, ee = string.find(str, ',')
        if(ee) then
            local xx = string.sub(str, e+1, ee-1)
            return tonumber(xx)
        end
    end

    return 0
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
 
function parseStringToTable(ret) 
    local str = serialize(ret)
    s,e = string.find(str, 'ContractState') 
    if(e) then
        ss, ee = string.find(str, ',') 
        if(ee) then        
            str = string.sub(str, s+e+3, ss-1) 
        else
            return {}
        end
    else
        return {}
    end

    local x = Split(str, ',') 
 
    local table_ = {} 
    for i=1, #x do 
        sss, eee = string.find(x[i], ':') 
        local key = string.sub(x[i], 1, sss-1) 
        local value = string.sub(x[i], sss, #x) 
        table_[key] = value 
    end 
 
    return table_ 
end 
 
function serialize(obj) 
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
 
function approve(...) 
    a = {} 
    for k,v in ipairs({...}) 
    do 
        a[k] = v 
    end 
 
    local ownerAddress   = a[1] 
    local spenderAddress = a[2] 
    local value          = a[3]

    local ret = scStateGet(ownerAddress, 'balance', a[5], a[6])
    local ownerBalance = getBalance(ret)
    if (ownerBalance >= tonumber(value)) then  

        result = scStateGet(ownerAddress, 'approve', a[5], a[6])
        local table_ = parseStringToTable(result)
        table_[spenderAddress] = value

        local ownerApproveState = serialize(table_)

        result = scStateStorage(ownerAddress, 'approve', ownerApproveState, a[5],a[6])

        return result 
    else
        result['state'] = 0
        result['res'] = 'Insufficient amount to approve'

        return result
    end
end

function foo(...) 
    result = approve(...) 
    return result 
end

--
--

--查询授权额度
--参数: ownerAddress, spenderAddress
result = {}
function Init(...)
	result['state'] = 1
	result['res']   = 'success'
	return result
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

function serialize(obj) 
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

function parseStringToTable(ret) 
    local str = serialize(ret)
    s,e = string.find(str, 'ContractState') 
    if(e) then
        ss, ee = string.find(str, ',') 
        if(ee) then        
            str = string.sub(str, s+e+3, ss-1) 
        else
            return {}
        end
    else
        return {}
    end

    local x = Split(str, ',') 
 
    local table_ = {} 
    for i=1, #x do 
        sss, eee = string.find(x[i], ':') 
        if(eee) then
        	local key = string.sub(x[i], 1, sss-1) 
        	local value = string.sub(x[i], sss, #x) 

      	    table_[key] = value 
      	end
    end 
 
    return table_ 
end 

function allowance(...)
	a = {}
	for k,v in ipairs({...})
	do
		a[k] = v
	end

	local ownerAddress   = a[1]
	local spenderAddress = a[2]
	local approve        = 'approve'
	result = scStateGet(ownerAddress, approve, a[4], a[5])

	local approvetable = parseStringToTable(result)

	for k,v in approvetable do
		if (k == spenderAddress) then
			result['state'] = 1
			result['res']   = v

			return result
		end
	end

	return result
end

function foo(...)
	result = allowance(...)
	return result
end






