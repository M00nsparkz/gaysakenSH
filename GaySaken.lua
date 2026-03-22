local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local anim = loadstring(game:HttpGet(('https://raw.githubusercontent.com/M00nsparkz/gaysakenSH/main/AnimCtrl.lua')))()

local function closecallback()
    OrionLib:MakeNotification({
	    Name = "Goodbye!",
	    Content = "Hope you will come back!",
	    Image = "rbxassetid://4483345998",
	    Time = 3
    })
    print("GaysakenSH window closed")
end

local Window = OrionLib:MakeWindow({Name = "GaysakenSH", HidePremium = false, SaveConfig = true, ConfigFolder = "gaysaken", CloseCallback = closecallback})

local Tab = Window:MakeTab({
	Name = "General",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local cheats = Tab:AddSection({
	Name = 'Cheats ("im a fucking unskill")'
})

local emotes = Tab:AddSection({
	Name = "Emotes"
})

--local anims = Tab:AddSection({
--	Name = "Anim Changer"
--})

emotes:AddDropdown({
	Name = "Emote",
	Default = "DSit",
	Options = {"DSit", "Custom"},
	Callback = function(Value)
		print(Value)
        local animid = nil
        if Value == "DSit" then
            animid = "104113460162561"
        elseif Value == "Custom" then
            warn("Not implemented yet")
        end
        anim:PlayPriorAnim(animid)
	end    
})



OrionLib:Init()