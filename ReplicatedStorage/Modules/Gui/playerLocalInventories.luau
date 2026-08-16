--intended to be called in local scripts


local playerLocalInventories = {}


function playerLocalInventories.updatePlayerInventory(data)
	
	print(data)
	--update player inventory
	local playerInventoryGUI = game.Players.LocalPlayer.PlayerGui.PlayerInventory
	
	-- reset inventory gui
	for i, v in playerInventoryGUI.Frame.ScrollingFrame:GetChildren() do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end
	
	-- fill inventory gui
	for i, v in data["Inventory"] do
		local listedItem = playerInventoryGUI.Frame.Item:Clone()
		listedItem.Name = i
		listedItem.Text = v
		listedItem.Visible = true
		listedItem.Parent = playerInventoryGUI.Frame.ScrollingFrame
	end
	
	-- update player equipment
	local playerEquipment = game.Players.LocalPlayer.PlayerGui.PlayerEquipment
	local equipmentList = {"PrimaryWeapon"}
	for i, v in equipmentList do
		playerEquipment.Frame[v].ItemName.Text = data["Equipped"][v]
	end
end

-- intended for when the rest site ends, so the inventories dont get in the way of combat.
function playerLocalInventories.hideAllInventories()
	local localGUI = game.Players.LocalPlayer.PlayerGui
	
	localGUI.PlayerEquipment.Enabled = false
	localGUI.PlayerInventory.Enabled = false
	localGUI.PartyInventory.Enabled = false
end

return playerLocalInventories
