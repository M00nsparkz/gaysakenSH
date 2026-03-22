--!strict

--AnimCtrl.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BLEND_TIME = 0 -- Плавность старта/остановки
local LOOP_ANIMATION = true -- Зациклить анимацию

-- Хранилище активных треков
local activeTracks: { AnimationTrack } = {}
local isPriorityMode = false

local function PlayPriorAnim(character: Model, animId: string): boolean
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	-- Останавливаем всё, что играло до этого
	StopAllAnimations()

	-- Загружаем анимацию
	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://" .. animId
	local track = animator:LoadAnimation(anim)
	
	-- 🔝 Максимальный приоритет + настройки
	track.Priority = Enum.AnimationPriority.Action4 -- Самый высокий!
	track.Looped = LOOP_ANIMATION
	track:Play(BLEND_TIME)
	
	-- Сохраняем трек
	table.insert(activeTracks, track)
	isPriorityMode = true
	
	return true
end


function StopAllAnimations()
	for i = #activeTracks, 1, -1 do
		local track = activeTracks[i]
		if track and track.IsPlaying then
			track:Stop(BLEND_TIME)
		end
		activeTracks[i] = nil
	end
	isPriorityMode = false
end


local function onCharacterAdded(character: Model)
	character:WaitForChild("HumanoidRootPart", 10)
	task.wait(0.2) -- Стабилизация
	
	-- Если нужно — сразу запускаем приоритетную анимацию
	-- Если нет — закомментируй строку ниже
	--PlayPriorityAnimation(character, PRIORITY_ANIM_ID)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Запускаем для уже существующего персонажа
if LocalPlayer.Character then
	task.spawn(function()
		onCharacterAdded(LocalPlayer.Character)
	end)
end

LocalPlayer.CharacterRemoving:Connect(function()
	StopAllAnimations()
end)

return {
	StopAllAnim = StopAllAnimations,
	PlayPriorAnim = function(animId: string?)
		local char = LocalPlayer.Character
		if char and animId then
			PlayPriorAnim(char, animId)
		end
	end
}
