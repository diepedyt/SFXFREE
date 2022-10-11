repeat wait() until game:IsLoaded()

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Free Auto Enchant", HidePremium = false, SaveConfig = false, IntroText = "Made By Roge#4087", ConfigFolder = "OrionTest"})

_G.Settings = {
    EnchantsToRollFor = {" ","None"},
    AutoEnchant = false,
    RollIfHaveEnoughGems = false,
    RollWhenGems = 0,
    EnchantsToLock = {" ","None"}
}



local Tab = Window:MakeTab({
	Name = "Auto-Enchant",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Main = Tab:AddSection({
	Name = "Main"
})


Main:AddToggle({
	Name = "Auto Enchant",
	Default = _G.Settings.AutoEnchant,
	Callback = function(Value)
		_G.Settings.AutoEnchant = Value
	end    
})

Main:AddToggle({
	Name = "Auto Lock Enchants",
	Default = _G.Settings.AutoLock,
	Callback = function(Value)
		_G.Settings.AutoLock = Value
	end    
})

Main:AddToggle({
	Name = "Only Roll When Free/Enough Gems",
	Default = _G.Settings.RollIfHaveEnoughGems,
	Callback = function(Value)
		_G.Settings.RollIfHaveEnoughGems = Value
	end    
})

Tab:AddTextbox({
	Name = "Enough Gems Input",
	Default = _G.Settings.RollWhenGems,
	TextDisappear = false,
	Callback = function(Value)
        if tonumber(Value) then
		    _G.Settings.RollWhenGems = tonumber(Value)
        end
	end	  
})



local enchants = {""}

for i,v in ipairs(require(game:GetService("ReplicatedStorage").SharedLibrary.Enchants).List) do
    if not table.find(enchants,v.Name) then
        table.insert(enchants,v.Name)
    end
end

table.remove(enchants,1)

local Main = Tab:AddSection({
	Name = "Settings"
})


local enchants1 = Main:AddParagraph("Enchants To Stop On",table.concat(_G.Settings.EnchantsToRollFor,"\n"))


Main:AddDropdown({
	Name = "Enchants To Stop On",
	Default = "None",
	Options = enchants,
	Callback = function(Value)
		if table.find(_G.Settings.EnchantsToRollFor,Value) then
            table.remove(_G.Settings.EnchantsToRollFor,table.find(_G.Settings.EnchantsToRollFor,Value))
        else
            table.insert(_G.Settings.EnchantsToRollFor,Value)
        end
        enchants1:Set(table.concat(_G.Settings.EnchantsToRollFor,"\n"))
	end    
})


Main:AddButton({
	Name = "Reset List",
	Callback = function()
        _G.Settings.EnchantsToRollFor = {""}
      	enchants1:Set("")
  	end    
})

local enchants1 = Main:AddParagraph("Enchants To Lock",table.concat(_G.Settings.EnchantsToLock,"\n"))


Main:AddDropdown({
	Name = "Enchants To Lock",
	Default = "None",
	Options = enchants,
	Callback = function(Value)
		if table.find(_G.Settings.EnchantsToLock,Value) then
            table.remove(_G.Settings.EnchantsToLock,table.find(_G.Settings.EnchantsToLock,Value))
        else
            table.insert(_G.Settings.EnchantsToLock,Value)
        end
        enchants1:Set(table.concat(_G.Settings.EnchantsToLock,"\n"))
	end    
})


Main:AddButton({
	Name = "Reset List",
	Callback = function()
        _G.Settings.EnchantsToLock = {""}
      	enchants1:Set("")
  	end    
})

task.spawn(function()

    function canEnchant(sword)
        if not _G.Settings.AutoEnchant then return false end

        function check1()
            if _G.Settings.RollIfHaveEnoughGems then
                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.ReEnchanter.Holder.Background.Contents.Price.Text:match("FREE") then return true end
                if true then
                    if game:GetService("ReplicatedStorage").Data[game.Players.LocalPlayer.Name].Stats.Gems.Value > _G.Settings.RollWhenGems then
                        return true
                    else
                        return false
                    end
                else 
                    return false
                end
            else
                return true
            end
        end

        function check2()
            if _G.Settings.EnchantsToRollFor ~= {" "} and _G.Settings.EnchantsToRollFor ~= {" ","None"} then
                if sword:FindFirstChild("Config") then
                    for i = 1,4 do
                        local a = "Enchant"..i
                        if table.find(_G.Settings.EnchantsToRollFor, sword.Config:FindFirstChild(a).Value:split("[")[2]:split(",")[1]:split("\"")[2]) then
                            return false
                        end
                    end
                    return true
                end
            else
                return false
            end
        end

        function lockEnchants()
            if _G.Settings.AutoLock and (_G.Settings.EnchantsToLock ~= {" ","None"} and _G.Settings.EnchantsToLock ~= {" "}) then
                if sword:FindFirstChild("Config") then

                    if game:GetService("ReplicatedStorage"):WaitForChild("Data"):WaitForChild(game.Players.LocalPlayer.Name).Stats.Locks.Value <= 0 then
                        repeat 
                            game:GetService("ReplicatedStorage").Framework.RemoteFunction:InvokeServer(0,"EnchanterServer","BuyLock",{})
                            task.wait(1)
                        until game:GetService("ReplicatedStorage"):WaitForChild("Data"):WaitForChild(game.Players.LocalPlayer.Name).Stats.Locks.Value >= 1
                    end
                
                    for i = 1,4 do
                        local a = "Enchant"..i
                        if table.find(_G.Settings.EnchantsToLock, sword.Config:FindFirstChild(a).Value:split("[")[2]:split(",")[1]:split("\"")[2]) then
                                game:GetService("ReplicatedStorage").Framework.RemoteFunction:InvokeServer(0,"EnchanterServer","ApplyLocks",{i,1})
                            break
                        end
                    end

                end
            end
        end

        if check1() and check2() then
            lockEnchants()
            return true
        end

    end

    while task.wait() do
        task.wait(1)
        if _G.Settings.AutoEnchant and game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"]:WaitForChild("Enchanter").Item.Value ~= nil and canEnchant(game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"].Enchanter.Item.Value) then
            game:GetService("ReplicatedStorage").Framework.RemoteFunction:InvokeServer(0,"EnchanterServer","Buy",{})
        end
    end

end)


OrionLib:Init()