local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("ModdedWorldRemotes"):WaitForChild("Punch")
local punching = false

local function punch()
	if punching then
		return
	end
	punching = true
	remote:FireServer()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
		local animation = Instance.new("Animation")
		animation.AnimationId = "rbxassetid://507777826"
		local track = animator:LoadAnimation(animation)
		track.Priority = Enum.AnimationPriority.Action
		track:Play(0.05, 1, 1.35)
		task.delay(0.7, function()
			track:Stop(0.1)
			animation:Destroy()
		end)
	end
	task.delay(0.45, function()
		punching = false
	end)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.E) then
		punch()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "PunchControls"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")
local button = Instance.new("TextButton")
button.Name = "PunchButton"
button.AnchorPoint = Vector2.new(1, 1)
button.Position = UDim2.new(1, -24, 1, -24)
button.Size = UDim2.fromOffset(170, 58)
button.BackgroundColor3 = Color3.fromRGB(120, 45, 220)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "PUNCH  [E]"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.Parent = gui
button.Activated:Connect(punch)
