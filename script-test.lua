local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- SETTINGS
local AutoQTE = false
local AntiAFK = false

-- REMOVE OLD GUI
pcall(function()
	player.PlayerGui:FindFirstChild("SimpleHub"):Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SimpleHub"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

-- MAIN FRAME
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,200,0,135)
main.Position = UDim2.new(0.03,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

Instance.new("UICorner",main).CornerRadius = UDim.new(0,12)

-- OPEN BUTTON
local openButton = Instance.new("ImageButton")
openButton.Parent = gui
openButton.Size = UDim2.new(0,45,0,45)
openButton.Position = UDim2.new(0.03,0,0.25,0)
openButton.Visible = true
main.Visible = false
openButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
openButton.BorderSizePixel = 0
openButton.Image = "rbxassetid://80679940074937"
openButton.ScaleType = Enum.ScaleType.Fit
openButton.Active = true
openButton.Draggable = true

Instance.new("UICorner",openButton).CornerRadius = UDim.new(1,0)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = main
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,21,0,8)
title.Size = UDim2.new(1,-45,0,24)
title.Font = Enum.Font.GothamBold
title.Text = "Alexandra Interface (AI)"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Center

-- HIDE BUTTON
local hideButton = Instance.new("TextButton")
hideButton.Parent = main
hideButton.Size = UDim2.new(0,30,0,30)
hideButton.Position = UDim2.new(0,-12,0,-12)
hideButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
hideButton.BorderSizePixel = 0
hideButton.Text = "X"
hideButton.Font = Enum.Font.GothamBold
hideButton.TextSize = 12
hideButton.TextColor3 = Color3.new(1,1,1)

Instance.new("UICorner",hideButton).CornerRadius = UDim.new(1,0)

-- CONTENT FRAME
local content = Instance.new("Frame")
content.Parent = main
content.BackgroundTransparency = 1
content.Position = UDim2.new(0,0,0,33)
content.Size = UDim2.new(1,0,1,-38)

-- LAYOUT
local layout = Instance.new("UIListLayout")
layout.Parent = content
layout.Padding = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local padding = Instance.new("UIPadding")
padding.Parent = content
padding.PaddingTop = UDim.new(0,6)

-- TOGGLE CREATOR
local function createToggle(text)

	local button = Instance.new("TextButton")
	button.Parent = content
	button.Size = UDim2.new(0,170,0,35)
	button.BackgroundColor3 = Color3.fromRGB(40,40,40)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.Gotham
	button.TextColor3 = Color3.new(1,1,1)
	button.TextSize = 14

	Instance.new("UICorner",button).CornerRadius = UDim.new(0,8)

	button.Text = text.." : OFF"

	return button
end

-- BUTTONS
local qteButton = createToggle("Auto Train")
local afkButton = createToggle("Anti AFK")

-- EVENTS
qteButton.MouseButton1Click:Connect(function()

	AutoQTE = not AutoQTE

	qteButton.Text =
		"Auto QTE : "..(AutoQTE and "ON" or "OFF")

	qteButton.BackgroundColor3 =
		AutoQTE
		and Color3.fromRGB(0,170,100)
		or Color3.fromRGB(40,40,40)

end)

afkButton.MouseButton1Click:Connect(function()

	AntiAFK = not AntiAFK

	afkButton.Text =
		"Anti AFK : "..(AntiAFK and "ON" or "OFF")

	afkButton.BackgroundColor3 =
		AntiAFK
		and Color3.fromRGB(0,170,100)
		or Color3.fromRGB(40,40,40)

end)

-- AUTO QTE
task.spawn(function()

	while true do
		task.wait(0.01)

		if AutoQTE then

			local success,button = pcall(function()

				return player.PlayerGui
					.TreadmillQTE_Icon
					.Frame
					.ImageButton

			end)

			if success and button and button.Visible then

				pcall(function()
					button:Activate()
				end)

				pcall(function()
					firesignal(button.Activated)
				end)

				pcall(function()
					firesignal(button.MouseButton1Click)
				end)

			end
		end
	end
end)

-- ANTI AFK
player.Idled:Connect(function()

	if AntiAFK then

		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())

	end
end)

-- HIDE / OPEN ANIMATION
hideButton.MouseButton1Click:Connect(function()

	local buttonPos = openButton.Position

	local tween = TweenService:Create(
		main,
		TweenInfo.new(
			0.22,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		{
			Size = UDim2.new(0,0,0,0),
			Position = buttonPos,
			BackgroundTransparency = 1
		}
	)

	tween:Play()

	tween.Completed:Wait()

	main.Visible = false
	openButton.Visible = true

end)

openButton.MouseButton1Click:Connect(function()

	openButton.Visible = false
	main.Visible = true

	main.Size = UDim2.new(0,0,0,0)
	main.Position = openButton.Position
	main.BackgroundTransparency = 1

	TweenService:Create(
		main,
		TweenInfo.new(
			0.28,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{
			Size = UDim2.new(0,200,0,135),
			Position = UDim2.new(
				openButton.Position.X.Scale,
				openButton.Position.X.Offset + 80,
				openButton.Position.Y.Scale,
				openButton.Position.Y.Offset + 20
			),
			BackgroundTransparency = 0
		}
	):Play()

end)