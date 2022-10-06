repeat wait() until game:IsLoaded()

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

if not LPH_OBFUSCATED then 
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
    LPH_JIT_MAX = function(...) return (...) end;
end

local function tw(input, studspersecond, offset)



        if _G.GoingToPad == true and input.Name ~= "MatchmakingPad" then
            return
        end

        local distanceInStuds = 0

        if game.Players.LocalPlayer.Character and input then
            pcall(function()
                distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - input.Position).Magnitude
            end)
        end
    
        if distanceInStuds > 1000 then return end



    local char = game:GetService("Players").LocalPlayer.Character;
    local input = input or error("input is nil")
    local studspersecond = studspersecond or 1000
    local offset = offset or CFrame.new(0,0,0)
    local vec3, cframe

 
    if typeof(input) == "table" then
        vec3 = Vector3.new(unpack(input)); cframe = CFrame.new(unpack(input))
    elseif typeof(input) ~= "Instance" then
        return error("wrong format used")
    end;
    
    Time = (char.HumanoidRootPart.Position - (vec3 or input.Position)).magnitude/studspersecond
    local twn = game.TweenService:Create(char.HumanoidRootPart, TweenInfo.new(Time,Enum.EasingStyle.Linear), {CFrame = (cframe or input.CFrame) * offset})
    twn:Play()
    twn.Completed:Wait()
 end

_G.SendNotification = LPH_NO_VIRTUALIZE(function(title,text)
    OrionLib:MakeNotification({
        Name = tostring(title),
        Content = tostring(text),
        Image = "rbxassetid://4483345998",
        Time = 2
    })
end)

function getStudLength(target)
    if game.Players.LocalPlayer.Character and target then
        distanceInStuds = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - target.Position).Magnitude
    end
    return distanceInStuds
end

function getYourDungeon()
    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:FindFirstChild("VV") and v:FindFirstChild("VV").Value == game.Players.LocalPlayer.Name then
            return v
        end
    end
end

if not game:GetService("Workspace"):FindFirstChild("a") then
    local a = Instance.new("Part",game:GetService("Workspace"))
    a.Size = Vector3.new(10,5,10)
    a.CFrame = (CFrame.new(-10958.4316, 103.607559, -17797.5742) * CFrame.new(0,20,0)) * CFrame.new(0,-7,0)
    a.Transparency = 0
    a.Anchored = true
    a.Name = "a"
end

function tpToDungeonEntrance()

    if getStudLength(game:GetService("Workspace"):FindFirstChild("a")) > 100 and not getYourDungeon() and not _G.EnteringDungeon then
        repeat
            pcall(function()
                if _G.Settings.Tween then
                    tw(game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"].DungeonTP.Focus, 20,CFrame.new(0,13,0))
                    task.wait(1)
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"].DungeonTP.Focus.CFrame * CFrame.new(0,3,0)
                end
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"].DungeonTP.Focus, 0)
                firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace")[game.Players.LocalPlayer.Name.."'s Base"].DungeonTP.Focus, 1)
            end)
            task.wait(1)
        until game:GetService("Workspace").Maps["Magma Hills"].FortressDoor:FindFirstChild("Brick") and getStudLength(game:GetService("Workspace"):FindFirstChild("a")) < 100
    end

    task.wait(1)

    if getStudLength(game:GetService("Workspace"):FindFirstChild("a")) < 100 and not getYourDungeon() and not _G.EnteringDungeon then
        pcall(function()
            if _G.Settings.Tween then
                tw({-10958.4316, 103.607559, -17797.5742},10,CFrame.new(0,20,0))
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10958.4316, 103.607559, -17797.5742) * CFrame.new(0,20,0)
            end 
        end)
    end

end


if not isfolder("SFX") then
    makefolder("SFX")
end

if not isfolder("SFX/"..game.Players.LocalPlayer.Name) then
    makefolder("SFX/"..game.Players.LocalPlayer.Name)
end 

function updateTotalGem()
    pcall(function()
        local j
        local HS = game:GetService("HttpService")
        if writefile then
            d = HS:JSONEncode(game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainGui"):WaitForChild("TopHolder"):WaitForChild("Gems"):WaitForChild("Price").Text:gsub(",",""))
            writefile("SFX/"..game.Players.LocalPlayer.Name.."/TotalGems.json",d)
        end
    end)
end


local updJS = LPH_NO_VIRTUALIZE(function()
    local j
    local HS = game:GetService("HttpService")
    if writefile then
        d = HS:JSONEncode(_G.Settings)
        writefile("SFX/"..game.Players.LocalPlayer.Name.."/Settings.json",d)
    end
end)


_G.Settings = {
    MobSwordNickname = "",
    BossSwordNickname = "",
    ChestSwordNickname = "",
    Delay = 0,
    WebhookLink = "",
    AutoDungeon = false,
    JoinDelay = 0,
    Tween = false,
    TweenSpeed = 80
}

if readfile and isfile and isfile("SFX/"..game.Players.LocalPlayer.Name.."/Settings.json") then
    local HS = game:GetService("HttpService")
    _G.Settings = HS:JSONDecode(readfile("SFX/"..game.Players.LocalPlayer.Name.."/Settings.json"))
end

local Window = OrionLib:MakeWindow({
Name = "SFX",
HidePremium = false,
SaveConfig = false,
ConfigFolder = "OrionTest",
IntroText = "Made By Roge#4087"
})

local Tab = Window:MakeTab({
	Name = "Auto-Dung",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Section = Tab:AddSection({
	Name = "Main"
})

Section:AddToggle({
	Name = "Auto-Dungeon",
	Default = _G.Settings.AutoDungeon,
	Callback = function(newValue)
		_G.Settings.AutoDungeon = newValue
        updJS()
	end    
})

Section:AddToggle({
	Name = "Tween Instead Of Teleport",
	Default = _G.Settings.Tween,
	Callback = function(newValue)
		_G.Settings.Tween = newValue
        updJS()
	end    
})

Section:AddSlider({
	Name = "Tween Speed",
	Min = 1,
	Max = 150,
	Default = _G.Settings.TweenSpeed,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "",
	Callback = function(newValue)
		_G.Settings.TweenSpeed = newValue
        updJS()
	end    
})

local Section = Tab:AddSection({
	Name = "Swords"
})

local swordTypes = {"Mob","Boss","Chest"}

for i = 1,#swordTypes do
    Section:AddTextbox({
        Name = swordTypes[i].." Sword Nickname",
        Default = _G.Settings[swordTypes[i].."SwordNickname"],
        TextDisappear = false,
        Callback = function(newValue)
            _G.Settings[swordTypes[i].."SwordNickname"] = newValue
            updJS()
        end	  
    })
end

local Section = Tab:AddSection({
	Name = "Other"
})

Section:AddSlider({
	Name = "Time To Wait After Joining Dungeon - For Bad PCs",
	Min = 0,
	Max = 20,
	Default = _G.Settings.JoinDelay,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "",
	Callback = function(newValue)
		_G.Settings.JoinDelay = newValue
        updJS()
	end    
})

Section:AddSlider({
	Name = "Time To Make Run Longer - Anti-Leaderboard",
	Min = 0,
	Max = 20,
	Default = _G.Settings.Delay,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "",
	Callback = function(newValue)
		_G.Settings.Delay = newValue
        updJS()
	end    
})

task.spawn(function()
    task.wait(3)
    pcall(function() updateTotalGem() end)
end)

local Section = Tab:AddSection({
	Name = "Webhook"
})

Section:AddTextbox({
	Name = "Webhook Link",
	Default = _G.Settings.WebHookLink,
	TextDisappear = false,
	Callback = function(newValue)
		_G.Settings.WebHookLink = newValue
        updJS()
	end	  
})

local Tab = Window:MakeTab({
	Name = "Gift-Searcher",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

function getHighestRQCM(Type,types)

    local add = {
        ["Rarity"] = "Rarities",
        ["Quality"] = "Qualities",
        ["Class"] = "Classes",
        ["Mold"] = "Molds"
    }

    local daddy = {}

    function getswordworth(value,thing)
        for i,v in ipairs(require(game:GetService("ReplicatedStorage").SharedLibrary[add[value]]).List) do
            if v.Name == thing then
                return i
            end
        end
    end

    function getNameofworth(value,thing)
        for i,v in ipairs(require(game:GetService("ReplicatedStorage").SharedLibrary[add[value]]).List) do
            if i == thing then
                return v.Name
            end
        end
    end

    _G.Best[Type] = -1

    local ap = ""

    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.GiftsMenu.ScrollingFrame:GetChildren()) do
        if v.Name == "Template" and v:FindFirstChild("Note") and v:FindFirstChild("Buy"):FindFirstChild("TextLabel").Text == "Claim!" then

           pcall(function()
                ap = (v.Note.Text:split(Type..": ")[2]:split(" |")[1])
                if not ap:match(":") then


                    local worth = getswordworth(Type,ap)

                    if _G.Best[Type] < worth then
                        _G.Best[Type] = worth
                    end

                end
           end)

        end
    end


    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.GiftsMenu.ScrollingFrame:GetChildren()) do
        if v.Name == "Template" and v:FindFirstChild("Note") then
            local dadap = (v.Note.Text:split(Type..": ")[2]:split(" |")[1])
            if getswordworth(Type,dadap) == _G.Best[Type] then
                return v.Note.Text
            end
        end
    end

end

local types = {"Rarity","Class","Mold"}

_G.Best = {}

for i = 1, #types do

    local Section = Tab:AddSection({
        Name = types[i]
    })

    local a = Section:AddParagraph("Best Sword By: "..types[i]," Rarity: \nClass: \nMold: ")

    Section:AddButton({
        Name = "Get Best "..types[i].." From Gifts",
        Callback = function()
            pcall(function()
                _G.Best[types[i]] = getHighestRQCM(types[i],types)
                a:Set(_G.Best[types[i]])
            end)
        end    
    })

    
    function getswordworth(value,thing)
        local add = {
            ["Rarity"] = "Rarities",
            ["Quality"] = "Qualities",
            ["Class"] = "Classes",
            ["Mold"] = "Molds"
        }
    
        for i,v in ipairs(require(game:GetService("ReplicatedStorage").SharedLibrary[add[value]]).List) do
            warn(v.Name,thing)
            if v.Name == thing then
                return i
            end
        end
    end

    
    Section:AddButton({
        Name = "Claim Best "..types[i].." From Gifts",
        Callback = function()  
            pcall(function()   
                for a,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.GiftsMenu.ScrollingFrame:GetChildren()) do
                    if v.Name == "Template" and v:FindFirstChild("Note") and v:FindFirstChild("Buy"):FindFirstChild("TextLabel").Text == "Claim!" then
                        pcall(function()
                            

                            if getswordworth(types[i],(v.Note.Text:split(types[i]..": ")[2]:split(" |")[1])) == getswordworth(types[i],(_G.Best[types[i]]:split(types[i]..": ")[2]:split(" |")[1])) then
                                print("2")
                                local button = v:FindFirstChild("Buy"):FindFirstChild("TextButton")
                                local events = {"MouseButton1Click", "MouseButton1Down", "Activated"}
                                for i,v in pairs(events) do
                                    pcall(function()
                                        for i,v in pairs(getconnections(button[v])) do
                                            v:Fire()
                                        end
                                    end)
                                end
                            end
                        end)
                    end
                end
            end)
        end    
    })
    
end




function _G.GetSword(Nickname)
    for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
        if v.Config.Nickname.Value == Nickname then
            return v
        end 
    end
end

function _G.StartDungeon()
    if not _G.Doing then
        pcall(function()
            if not game:GetService("Workspace").Maps["Magma Hills"].FortressDoor:FindFirstChild("Brick") and getStudLength(game:GetService("Workspace"):FindFirstChild("a")) > 100 then

                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(_G.GetSword(_G.Settings.MobSwordNickname))
                end)

                pcall(function()
                    if not firetouchinterest then
                        if _G.Settings.Tween then
                            tw({-10958.4316, 103.607559, -17797.5742},_G.Settings.TweenSpeed,CFrame.new(0,20,0))
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10958.4316, 103.607559, -17797.5742, 0.0791591406, 5.58598927e-08, -0.996861994, 1.24404139e-07, 1, 6.59144561e-08, 0.996861994, -1.29231481e-07, 0.0791591406) * CFrame.new(0,20,0)
                        end
                    else
                        tpToDungeonEntrance()
                    end
                end)
            end
        end)

        function brickCheck()


            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(_G.GetSword(_G.Settings.MobSwordNickname))
            end)

            if getStudLength(game:GetService("Workspace"):FindFirstChild("a")) > 100 then

                for i = 1,1 do
                    pcall(function()
                        if not firetouchinterest then
                            if _G.Settings.Tween then
                                tw({-10958.4316, 103.607559, -17797.5742},_G.Settings.TweenSpeed,CFrame.new(0,20,0))
                            else
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10958.4316, 103.607559, -17797.5742, 0.0791591406, 5.58598927e-08, -0.996861994, 1.24404139e-07, 1, 6.59144561e-08, 0.996861994, -1.29231481e-07, 0.0791591406) * CFrame.new(0,20,0)
                            end
                        else
                            tpToDungeonEntrance()
                        end
                    end)
                    task.wait(.1)
                end
                return game:GetService("Workspace").Maps["Magma Hills"].FortressDoor.Brick.BillboardGui.Counter.Visible
                
            end

        end

        repeat wait(3) until not brickCheck()
        _G.EnteringDungeon = true
        repeat 
            task.wait(.1)
            if game:GetService("Workspace").Maps["Magma Hills"].FortressDoor.Brick.BillboardGui.Counter.Visible == false then
                pcall(function()
                    if _G.Settings.Tween then
                        tw(game:GetService("Workspace").Maps["Magma Hills"].DungeonMatchmaking.MatchmakingPad,20,CFrame.new(0,2,0))
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Maps["Magma Hills"].DungeonMatchmaking.MatchmakingPad.CFrame * CFrame.new(0,2,0)
                    end
                    
                end)
            else
                break
            end
        until _G.EnteringDungeon == false
        if _G.EnteringDungeon == false then
            pcall(function() repeat wait(1) until getStudLength(game:GetService("Workspace").Maps["Magma Hills"].DungeonMatchmaking.MatchmakingPad) > 20  end)
            _G.DoDungeon()
        end
    end
end

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child.Name == "MagmaDungeon" and _G.EnteringDungeon then
        _G.EnteringDungeon = false
        local Ow = Instance.new("StringValue",child)
        Ow.Name = "VV"
        Ow.Value = game.Players.LocalPlayer.Name
    end
end)


function _G.DoDungeon()

    if not _G.Doing then
        _G.Doing = true
    else
        return
    end

    pcall(function() repeat wait(1) until getStudLength(game:GetService("Workspace").Maps["Magma Hills"].DungeonMatchmaking.MatchmakingPad) > 20  end)

    repeat wait(1) warn("waiting for dung") until getYourDungeon()

    if _G.Settings.Tween then
        task.wait(5)
    else
        task.wait(_G.Settings.JoinDelay)
    end

    _G.AutoSwing = true


    function killAllMobs()
        game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(_G.GetSword(_G.Settings.MobSwordNickname))
        for i,v in pairs(game:GetService("Workspace").Mobs:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 and v.Name ~= "Noob" then
                if v.Name == "The Abomination" then
                    game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(_G.GetSword(_G.Settings.BossSwordNickname))
                    if _G.Settings.Delay ~= 0 then
                        for i = 1,10 do
                            pcall(function()
                                if _G.Settings.Tween then
                                    tw(getYourDungeon().Start.Entrance.PlayerWalkTo,_G.Settings.TweenSpeed,CFrame.new(0,5,0))
                                else
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getYourDungeon().Start.Entrance.PlayerWalkTo.CFrame * CFrame.new(0,5,0)
                                end
                            end)
                            task.wait(0.1)
                        end
                        task.wait(_G.Settings.Delay)
                    end
                end
                local b = nil
                b = v
                if b.Name ~= "The Abomination" then
                    local closestMob = nil
                    local closestDist = math.huge
                    for i,v in pairs(game:GetService("Workspace").Mobs:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Humanoid").Health > 0 and v.Name ~= "Noob" then
                            local a = getStudLength(v:FindFirstChild("HumanoidRootPart"))
                            if a < closestDist then
                                closestMob = v
                                closestDist = a
                            end
                        end
                    end
                    b = closestMob
                end
                    pcall(function()
                        repeat 
                            pcall(function()
                                if _G.Settings.Tween then
                                    tw(b:FindFirstChild("HumanoidRootPart"),_G.Settings.TweenSpeed,CFrame.new(0,0,5))
                                else
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = b:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,5)
                                end
                                task.wait(.05)
                                task.wait(.1)
                            end)
                        until b:FindFirstChild("DeathComplete") or b:FindFirstChild("Humanoid").Health <= 0
                    end)
            end
        end
    end

    function killBoss()

        function goThroughEveryting()
            for i,v in ipairs(getYourDungeon():GetDescendants()) do
                if v.Name == "Start" or v.Name == "End" and v:IsA("Part") then
                    pcall(function()
                        if _G.Settings.Tween then
                            tw(v,_G.Settings.TweenSpeed,CFrame.new(0,2,0))
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,2,0)
                        end
                        task.wait(0.1)
                    end)
                end
            end
        end
        
        repeat pcall(function() goThroughEveryting() killAllMobs() end) until getYourDungeon():WaitForChild("EndModule"):FindFirstChild("Start")

        killAllMobs()
        repeat 
            killAllMobs()
            pcall(function()
                task.wait(1)
                if _G.Settings.Tween then
                    tw(getYourDungeon().EndModule.Start,_G.Settings.TweenSpeed,CFrame.new(0,0,math.random(10,20)) * CFrame.new(0,10,0))
                else
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (getYourDungeon().EndModule.Start.CFrame * CFrame.new(0,0,math.random(10,20))) * CFrame.new(0,10,0)
                end
            end)
        until game:GetService("Workspace").Mobs:FindFirstChild("The Abomination")
        killAllMobs()
    end

    function getAllChests()
        for i,v in pairs(getYourDungeon():GetChildren()) do
            task.wait(.1)
            if v:FindFirstChild("Chests") then
                for i,v in ipairs(v.Chests:GetChildren()) do
                    if not v:FindFirstChild("Lock") then
                        local attempt = 0
                        task.wait(.3)
                        local b = nil
                        b = v
                        pcall(function()
                            local closestChest = nil
                            local closestDist = math.huge
                            for i,v in pairs(getYourDungeon():GetChildren()) do
                                if v:FindFirstChild("Chests") then
                                    for i,v in ipairs(v.Chests:GetChildren()) do
                                        if not v:FindFirstChild("Lock") then
                                            local a = getStudLength(v["Chest_Base"].Frame.Frame)
                                            if a < closestDist then
                                                closestChest = v
                                                closestDist = a
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                            repeat
                                attempt += 1
                                pcall(function()
                                    killAllMobs()
                                    game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(_G.GetSword(_G.Settings.ChestSwordNickname))
                                    task.wait(.1)
                                    if _G.Settings.Tween then
                                        tw(b.Chest_Lid.Frame.Lock,_G.Settings.TweenSpeed,CFrame.new(1,0,0))
                                    else
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = b.Chest_Lid.Frame.Lock.CFrame * CFrame.new(1,0,0)
                                    end
                                end)
                            task.wait(.4)
                        until b:FindFirstChild("Lock") or attempt >= 5
                    end
                end
            end
        end
    end

    killAllMobs()
    killBoss()
    getAllChests()

    _G.AutoSwing = false


    game:GetService("ReplicatedStorage").Framework.RemoteEvent:FireServer(0,"UIServer","Teleport",{})

    repeat wait() until not getYourDungeon()

    _G.Doing = false

end

_G.WebHook = LPH_JIT_MAX(function(oldGems,newGems)
	pcall(function()
		local url = tostring(_G.Settings.WebHookLink)
		if url == "" then return end

        function comma_value(amount)
            local formatted = amount
            while true do  
              formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
              if (k==0) then
                break
              end
            end
            return formatted
        end

        local totalGem = "Error!"


        local a = listfiles("SFX")

        for i,v in pairs(a) do
            
            local player = v:split("\\")[2]

            local playerGem = "0"

            local HS = game:GetService("HttpService")
            if readfile and isfile and isfile("SFX/"..player.."/TotalGems.json") then
                playerGem = HS:JSONDecode(readfile("SFX/"..player.."/TotalGems.json"))
            end

            if totalGem == "Error!" then
                totalGem = playerGem
            else
                totalGem += playerGem
            end

        end


        local profitGem = newGems - oldGems

        local data = {
            ["username"]= " abc ",
            ["avatar_url"]= "https://cdn.discordapp.com/attachments/912431345765081148/1023696332638134403/unknown-removebg-preview.png",
            ["content"]= "",
            ["embeds"]= {
              {
                ["color"]= 0,
                ["description"]= "~ **Hello Baby Girl - ||"..game.Players.LocalPlayer.Name.."||**\n\n~ **Here Are Your Stats ;) - ||"..game.Players.LocalPlayer.Name.."||**\n\n- Gem Gain: ** "..comma_value(profitGem).."+ **\n- Total Gems: ** "..comma_value(newGems).." **\n- Total Gems On All Accounts: ** "..comma_value(totalGem).." **\n-\n\n~ **Have Sex With Me Later OwO~ - ||"..game.Players.LocalPlayer.Name.."||**\n\n",
                ["timestamp"]= "",
                ["author"]= {
                  ["name"]= "I'm So Sexy, Marry Me!",
                  ["url"]= "",
                  ["icon_url"]= "https://cdn.discordapp.com/attachments/912431345765081148/1023696455715786863/unknown.png"
                },
                ["image"]= {},
                ["thumbnail"]= {},
                ["footer"] ={},
                ["fields"] = {}
              }
            },
            ["components"] = {}
          }

		local bigTiddieGothGirl = game:GetService("HttpService"):JSONEncode(data)

		local headers = {["content-type"] = "application/json"}
		request = http_request or request or HttpPost or syn.request or http.request
		local pornhub = {Url = url, Body = bigTiddieGothGirl, Method = "POST", Headers = headers}
		warn("Sending webhook notification...")
		request(pornhub)
	end)
end)

task.spawn(function()
    while task.wait() do
        task.wait(3)
        if _G.Settings.AutoDungeon then
            if _G.Settings.MobSwordNickname ~= "" and _G.Settings.BossSwordNickname ~= "" and _G.Settings.ChestSwordNickname ~= "" then
                _G.StartDungeon()
            else
                _G.SendNotification("Error","One Of The Nicknames Are Empty")
            end
        end
    end
end)

task.spawn(function()
    if tostring(_G.Settings.WebHookLink) ~= "" then
        while task.wait(1) do
            repeat wait(1) until _G.Doing
            local oldGems = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.TopHolder.Gems.Price.Text:gsub(",","")
            repeat wait(1) until not _G.Doing
            local newGems = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.TopHolder.Gems.Price.Text:gsub(",","")
            pcall(function() updateTotalGem() end)
            pcall(function() _G.WebHook(tonumber(oldGems),tonumber(newGems)) end)
        end
    end
end)


task.spawn(function()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

task.spawn(function()
    while task.wait() do
        if _G.AutoSwing then
            pcall(function()
                task.wait(.1)
                game:GetService("Players").LocalPlayer.Character.Sword.SwordScriptNew.Attack:FireServer("Attack",false)
            end)
        end
    end
end)


