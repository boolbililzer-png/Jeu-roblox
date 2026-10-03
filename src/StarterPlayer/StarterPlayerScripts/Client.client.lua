-- Bagarre Bizarre — point d'entrée client.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

ReplicatedStorage:WaitForChild("Remotes")
ReplicatedStorage:WaitForChild("GameState")

local Modules = script.Parent:WaitForChild("ClientModules")
local Animator = require(Modules.Animator)
local Controller = require(Modules.Controller)
local CameraRig = require(Modules.CameraRig)
local Fx = require(Modules.Fx)
local Hud = require(Modules.Hud)
local Menu = require(Modules.Menu)
local MobileButtons = require(Modules.MobileButtons)

pcall(function()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
end)

Animator.start()
CameraRig.start()
Hud.start()
Fx.onBanner = Hud.banner
Fx.onBlackout = Hud.blackout
Fx.start()
Controller.start()
MobileButtons.start()
Menu.start()
