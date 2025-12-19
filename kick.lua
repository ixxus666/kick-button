local gui = instance.new("screengui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local button = instance.new("TextButton")
button.size = UDim2.new(0, 200, 0, 50)
button.position = UDim2.new(0.5, -100, 0.5, -25)
button.text = "Leave"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.parent = gui

button.Mousebutton1Click:Connect(function()
game.Players.LocalPlayer:Kick("Kick Was Successful!")
  end)
