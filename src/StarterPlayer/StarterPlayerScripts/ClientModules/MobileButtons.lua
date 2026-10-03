-- Boutons tactiles (70 px minimum) à côté du bouton SAUT de Roblox. Un seul bouton à la fois.
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Controller = require(script.Parent.Controller)

local MobileButtons = {}

local DEFS = {
	{ id = "S", text = "S", color = Color3.fromRGB(59, 130, 246), pos = UDim2.new(1, -250, 1, -205) },
	{ id = "P", text = "P", color = Color3.fromRGB(239, 68, 68), pos = UDim2.new(1, -165, 1, -250) },
	{ id = "grab", text = "✋", color = Color3.fromRGB(16, 185, 129), pos = UDim2.new(1, -335, 1, -150) },
	{ id = "dodge", text = "ESQ", color = Color3.fromRGB(139, 92, 246), pos = UDim2.new(1, -250, 1, -110) },
}

function MobileButtons.start()
	if not UserInputService.TouchEnabled then
		return
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "BBTouch"
	gui.ResetOnSpawn = false
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	for _, d in DEFS do
		local b = Instance.new("TextButton")
		b.Name = d.id
		b.Size = UDim2.fromOffset(78, 78)
		b.Position = d.pos
		b.BackgroundColor3 = d.color
		b.BackgroundTransparency = 0.15
		b.Text = d.text
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.FredokaOne
		b.TextScaled = true
		b.AutoButtonColor = true
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = b
		local s = Instance.new("UIStroke")
		s.Color = Color3.new(1, 1, 1)
		s.Thickness = 3
		s.Transparency = 0.3
		s.Parent = b
		b.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				Controller.press(d.id)
			end
		end)
		b.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				Controller.release(d.id)
			end
		end)
		b.Parent = gui
	end
	local state = ReplicatedStorage:WaitForChild("GameState")
	RunService.RenderStepped:Connect(function()
		local phase = state:GetAttribute("Phase")
		gui.Enabled = phase == "Fight" or phase == "Countdown"
	end)
end

return MobileButtons
