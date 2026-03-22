--!strict
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ⚙️ НАСТРОЙКИ
local PRIORITY_ANIM_ID = "123456789" -- ID твоей анимации (только цифры!)
local BLEND_TIME = 0 -- Плавность старта/остановки
local LOOP_ANIMATION = true -- Зациклить анимацию

-- Хранилище активных треков
local activeTracks: { AnimationTrack } = {}
local isPriorityMode = false

-- 🔥 ГЛАВНАЯ ФУНКЦИЯ: запуск приоритетной анимации
local function PlayPriorityAnimation(character: Model, animId: string): boolean
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

-- 🔥 ФУНКЦИЯ ОСТАНОВКИ: вызывай отовсюду
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

-- 🔁 Обработчик респавна
local function onCharacterAdded(character: Model)
	character:WaitForChild("HumanoidRootPart", 10)
	task.wait(0.2) -- Стабилизация
	
	-- Если нужно — сразу запускаем приоритетную анимацию
	-- Если нет — закомментируй строку ниже
	PlayPriorityAnimation(character, PRIORITY_ANIM_ID)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Запускаем для уже существующего персонажа
if LocalPlayer.Character then
	task.spawn(function()
		onCharacterAdded(LocalPlayer.Character)
	end)
end

-- 🌐 ДЕЛАЕМ ФУНКЦИИ ДОСТУПНЫМИ ИЗ ДРУГИХ СКРИПТОВ
-- Вариант 1: через _G (просто, но менее надёжно)
_G.StopAllAnim = StopAllAnimations
_G.PlayPriorityAnim = function(animId: string?)
	local char = LocalPlayer.Character
	if char then
		PlayPriorityAnimation(char, animId or PRIORITY_ANIM_ID)
	end
end

-- Вариант 2: через RemoteEvent (если нужно вызывать с сервера)
-- Создай RemoteEvent в ReplicatedStorage с именем "AnimControl"
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local remote = ReplicatedStorage:WaitForChild("AnimControl", 5)
-- if remote then
-- 	remote.OnClientEvent:Connect(function(cmd: string, animId: string?)
-- 		if cmd == "stop" then
-- 			StopAllAnimations()
-- 		elseif cmd == "play" and animId then
-- 			PlayPriorityAnimation(LocalPlayer.Character, animId)
-- 		end
-- 	end)
-- end

-- 🧹 Автоочистка при удалении персонажа
LocalPlayer.CharacterRemoving:Connect(function()
	StopAllAnimations()
end)