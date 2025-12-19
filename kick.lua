-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local SAVE_FILE = "kick_ui_pos.txt"
local THEME_FILE = "kick_ui_theme.txt"

-- Cleanup old UI
pcall(function()
	PlayerGui:FindFirstChild("DeltaKickUI"):Destroy()
end)

-- ===== ScreenGui & Main Frame =====
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaKickUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 140)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 18)

-- Shadow
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
shadow.Size = UDim2.new(1, 28, 1, 28)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.75
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Parent = frame
shadow.ZIndex = frame.ZIndex - 1

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
}
gradient.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 32)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Session Controls"
title.Font = Enum.Font.GothamSemibold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.Parent = frame

-- Kick Button
local kickBtn = Instance.new("TextButton")
kickBtn.Size = UDim2.new(1, -20, 0, 42)
kickBtn.Position = UDim2.new(0, 10, 0, 50)
kickBtn.Text = "Leave Game"
kickBtn.Font = Enum.Font.GothamBold
kickBtn.TextSize = 15
kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kickBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
kickBtn.BorderSizePixel = 0
kickBtn.Parent = frame
Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0, 14)

-- Theme Toggle
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, -20, 0, 28)
themeBtn.Position = UDim2.new(0, 10, 0, 100)
themeBtn.Text = "Toggle Light/Dark"
themeBtn.Font = Enum.Font.GothamSemibold
themeBtn.TextSize = 14
themeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
themeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
themeBtn.BorderSizePixel = 0
themeBtn.Parent = frame
Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 10)

-- ===== Load Saved Position =====
local function loadPos()
	if readfile and isfile and isfile(SAVE_FILE) then
		local d = readfile(SAVE_FILE)
		local xS,xO,yS,yO = d:match("(.+),(.+),(.+),(.+)")
		if xS then
			frame.Position = UDim2.new(
				tonumber(xS), tonumber(xO),
				tonumber(yS), tonumber(yO)
			)
			return
		end
	end
	frame.Position = UDim2.new(0.5, -130, 0.7, 0)
end

local function savePos()
	if writefile then
		local p = frame.Position
		writefile(SAVE_FILE, table.concat({
			p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset
		}, ","))
	end
end

loadPos()

-- ===== Dragging =====
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		savePos()
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ===== Button Animations =====
local hoverTweenKick = TweenService:Create(
	kickBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}
)
local normalTweenKick = TweenService:Create(
	kickBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}
)
kickBtn.InputBegan:Connect(function() hoverTweenKick:Play() end)
kickBtn.InputEnded:Connect(function() normalTweenKick:Play() end)

-- ===== Kick Action =====
kickBtn.Activated:Connect(function()
	player:Kick("You chose to leave the session.")
end)

-- ===== Theme Logic =====
local theme = "Dark"
local function applyTheme(t)
	if t == "Dark" then
		frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
		}
		title.TextColor3 = Color3.fromRGB(230, 230, 230)
		kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		kickBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
		themeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
		themeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	else -- Light
		frame.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
		gradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 250, 250)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
		}
		title.TextColor3 = Color3.fromRGB(30, 30, 35)
		kickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		kickBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		themeBtn.TextColor3 = Color3.fromRGB(30, 30, 35)
		themeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
	end
end

-- Load saved theme
if readfile and isfile and isfile(THEME_FILE) then
	local t = readfile(THEME_FILE)
	if t == "Light" or t == "Dark" then theme = t end
end
applyTheme(theme)

-- Theme toggle button
themeBtn.Activated:Connect(function()
	if theme == "Dark" then theme = "Light" else theme = "Dark" end
	applyTheme(theme)
	if writefile then writefile(THEME_FILE, theme) end
end)
