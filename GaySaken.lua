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
	Name = "Emotes/Anims",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local emotes = Tab:AddSection({
	Name = "Emotes"
})

--local anims = Tab:AddSection({
--	Name = "Anim Changer"
--})
local animValue = nil
emotes:AddDropdown({
	Name = "Emote",
	Default = "DSit",
	Options = {"DSit", "Custom"},
	Callback = function(AnimValue)
		print(AnimValue)
        animValue = AnimValue
	end    
})

emotes:AddButton({
	Name = "Start",
	Callback = function()
      	local animid = nil
        if animValue == "DSit" then
            animid = "104113460162561"
        elseif animValue == "Custom" then
            warn("Not implemented yet")
        end
        anim:PlayPriorAnim(animid)
  	end    
})



OrionLib:Init()