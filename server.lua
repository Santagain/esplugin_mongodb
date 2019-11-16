-- Make sure you set this convar:
-- set es_enableCustomData 1

AddEventHandler('es_db:doesUserExist', function(identifier, callback)
	exports.DatabaseAPI:findOne({ collection = "users", query = { identifier = identifier } }, function (success, users)
		if not success then
			print("ERRO AO VERIFICAR SE O USUARIO EXISTE: "..tostring(users))
			return
		end
        if users[1] then
			callback(true)
        else
			callback(false)
		end
	end)
end)
 
AddEventHandler('es_db:retrieveUser', function(identifier, callback)
	local Callback = callback
	exports.DatabaseAPI:findOne({ collection = "users", query = { identifier = identifier } }, function (success, users)
		if not success then
			print("ERRO AO OBTER DATA DO USUARIO VIA STEAMHEX: "..tostring(users))
			return
		end
        if users[1] then
			callback(users[1])
        else
			callback(false)
		end
	end)
end)

AddEventHandler('es_db:createUser', function(identifier, license, cash, bank, callback)
	local user = {
		identifier = identifier,
		money = cash or 0,
		bank = bank or 0,
		xp = 0,
		skin = null,
		job = "unemployed",
		job_grade = 0,
		loadout =  null,
		position = null,
		status =  null,
		firstname = "",
		lastname = "",
		dateofbirth = "=",
		sex = "M",
		height = "",
		last_property = null,
		pet = null,
		jail = 0,
		Pin = 1234,
		warrant = "No",
		skills = null,
		phone_number = null,
		tattoos = null,
		is_dead = 0,
		license = license or null,
		group = 'user',
		permission_level = 0
	}
    exports.DatabaseAPI:insertOne({ collection="users", document = user }, function (success, result, insertedIds)
        if not success then
            print("[MongoDB] [ESBridge] ERRO AO CRIAR USUARIO: "..tostring(result))
            return
        end
        print("[MongoDB] [ESBridge] USUARIO CRIADO. ID UNICA: "..tostring(insertedIds[1]))
        callback()
    end)
end)

AddEventHandler('es_db:retrieveLicensedUser', function(license, callback)
	exports.DatabaseAPI:findOne({ collection = "users", query = { license = license } }, function (success, users)
		if not success then
			print("[MongoDB] [ESBridge] ERRO AO OBTER DATA DO USUARIO VIA ROCKSTAR LICENSE: "..tostring(users))
			return
		end
        if users[1] then
			callback(users[1])
        else
			callback(false)
		end
	end)
end)

AddEventHandler('es_db:doesLicensedUserExist', function(license, callback)
	exports.DatabaseAPI:findOne({ collection = "users", query = { license = license } }, function (success, users)
		if not success then
			print("[MongoDB] [ESBridge] ERRO AO OBTER DATA DO USUARIO VIA ROCKSTAR LICENSE: "..tostring(users))
			return
		end
        if users[1] then
			callback(true)
        else
			callback(false)
		end
	end)
end)

AddEventHandler('es_db:updateUser', function(identifier, new, callback)
	Citizen.CreateThread(function()
		local params = {identifier = identifier}
		local obj = {}
		for k,v in pairs(new) do
			if (type(k) == 'string') then
				params[k] = v
				obj[k] = v	
			end
		end
		exports.DatabaseAPI:updateOne({ collection="users", query = { identifier = identifier }, update = { ["$set"] = obj } })
		if callback then
			callback(true)
		end
	end)
end)