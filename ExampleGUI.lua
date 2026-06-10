-- ============================================================================
-- EXAMPLE GUI - Demonstrates how to use OrcaUILibrary
-- ============================================================================
-- Place this in StarterPlayer > StarterPlayerScripts or ServerScriptService
-- Make sure OrcaUILibrary is accessible via require()
-- ============================================================================

local UILib = require(script.Parent:WaitForChild("OrcaUILibrary"))
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ============================================================================
-- SETUP
-- ============================================================================

local theme = UILib.ThemeManager.getTheme("dark")
local guiContainer = nil
local isGuiOpen = false

-- ============================================================================
-- CREATE MAIN GUI
-- ============================================================================

local function createMainGui()
	-- Destroy existing GUI if present
	if guiContainer and guiContainer.Parent then
		guiContainer:Destroy()
	end
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OrcaExampleGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	guiContainer = screenGui
	
	-- ========================================================================
	-- MAIN BACKGROUND CONTAINER
	-- ========================================================================
	
	local mainContainer = UILib.Utils.createRoundedFrame(
		screenGui,
		UDim2.new(0, 400, 0, 500),
		UDim2.new(0.5, -200, 0.5, -250),
		12,
		theme.primary,
		0
	)
	mainContainer.Name = "MainContainer"
	
	-- Add drop shadow effect
	local shadow = Instance.new("UIStroke")
	shadow.Color = Color3.fromRGB(0, 0, 0)
	shadow.Thickness = 3
	shadow.Transparency = 0.5
	shadow.Parent = mainContainer
	
	-- ========================================================================
	-- HEADER
	-- ========================================================================
	
	local header = UILib.Utils.createRoundedFrame(
		mainContainer,
		UDim2.new(1, 0, 0, 60),
		UDim2.new(0, 0, 0, 0),
		12,
		theme.secondary,
		0
	)
	header.Name = "Header"
	
	local titleLabel = UILib.Utils.createTextLabel(
		header,
		"Orca UI Library",
		UDim2.new(1, -20, 1, 0),
		UDim2.new(0, 10, 0, 0),
		24,
		Color3.fromRGB(255, 255, 255)
	)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Font = Enum.Font.GothamBold
	
	-- ========================================================================
	-- CONTENT AREA
	-- ========================================================================
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, 0, 1, -60)
	content.Position = UDim2.new(0, 0, 0, 60)
	content.BackgroundTransparency = 1
	content.Parent = mainContainer
	
	-- Add padding
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 15)
	padding.PaddingBottom = UDim.new(0, 15)
	padding.PaddingLeft = UDim.new(0, 15)
	padding.PaddingRight = UDim.new(0, 15)
	padding.Parent = content
	
	-- ========================================================================
	-- SECTION 1: BUTTONS
	-- ========================================================================
	
	local section1Title = UILib.Utils.createTextLabel(
		content,
		"Buttons",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 0),
		16,
		theme.accent
	)
	section1Title.TextXAlignment = Enum.TextXAlignment.Left
	section1Title.Font = Enum.Font.GothamBold
	
	-- Button 1
	local button1 = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(0.45, 0, 0, 45),
		UDim2.new(0, 0, 0, 30),
		8,
		theme.accent,
		0
	)
	button1.Name = "Button1"
	
	local button1Label = UILib.Utils.createTextLabel(
		button1,
		"Click Me!",
		UDim2.new(1, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		14,
		Color3.fromRGB(255, 255, 255)
	)
	button1Label.Font = Enum.Font.GothamBold
	
	local button1TextButton = Instance.new("TextButton")
	button1TextButton.Text = ""
	button1TextButton.Size = UDim2.new(1, 0, 1, 0)
	button1TextButton.BackgroundTransparency = 1
	button1TextButton.Parent = button1
	
	button1TextButton.Activated:Connect(function()
		print("Button 1 clicked!")
		UILib.Animations.animateColor(button1.BackgroundColor3, Color3.fromRGB(100, 200, 100), 0.3, function(color)
			button1.BackgroundColor3 = color
		end)
		task.wait(0.3)
		UILib.Animations.animateColor(button1.BackgroundColor3, theme.accent, 0.3, function(color)
			button1.BackgroundColor3 = color
		end)
	end)
	
	-- Button 2
	local button2 = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(0.45, 0, 0, 45),
		UDim2.new(0.55, 0, 0, 30),
		8,
		theme.secondary,
		0
	)
	button2.Name = "Button2"
	
	local button2Label = UILib.Utils.createTextLabel(
		button2,
		"Button 2",
		UDim2.new(1, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		14,
		Color3.fromRGB(255, 255, 255)
	)
	button2Label.Font = Enum.Font.GothamBold
	
	local button2TextButton = Instance.new("TextButton")
	button2TextButton.Text = ""
	button2TextButton.Size = UDim2.new(1, 0, 1, 0)
	button2TextButton.BackgroundTransparency = 1
	button2TextButton.Parent = button2
	
	button2TextButton.Activated:Connect(function()
		print("Button 2 clicked!")
	end)
	
	-- ========================================================================
	-- SECTION 2: SLIDER
	-- ========================================================================
	
	local section2Title = UILib.Utils.createTextLabel(
		content,
		"Slider",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 100),
		16,
		theme.accent
	)
	section2Title.TextXAlignment = Enum.TextXAlignment.Left
	section2Title.Font = Enum.Font.GothamBold
	
	-- Slider container
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Name = "SliderContainer"
	sliderContainer.Size = UDim2.new(1, 0, 0, 60)
	sliderContainer.Position = UDim2.new(0, 0, 0, 130)
	sliderContainer.BackgroundTransparency = 1
	sliderContainer.Parent = content
	
	-- Slider value display
	local sliderValueLabel = UILib.Utils.createTextLabel(
		sliderContainer,
		"Value: 50",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 0),
		12,
		Color3.fromRGB(200, 200, 200)
	)
	sliderValueLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Track background
	local trackBg = UILib.Utils.createRoundedFrame(
		sliderContainer,
		UDim2.new(1, 0, 0, 6),
		UDim2.new(0, 0, 0, 30),
		3,
		theme.secondary,
		0
	)
	
	-- Progress fill
	local fill = UILib.Utils.createRoundedFrame(
		trackBg,
		UDim2.new(0.5, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		3,
		theme.accent,
		0
	)
	
	-- Thumb/indicator
	local thumb = UILib.Utils.createRoundedFrame(
		sliderContainer,
		UDim2.new(0, 20, 0, 20),
		UDim2.new(0.5, -10, 0, 23),
		10,
		theme.accent,
		0
	)
	
	local minValue, maxValue = 0, 100
	local currentValue = 50
	local isDragging = false
	
	local function updateSliderValue(mouseX)
		local trackPos = trackBg.AbsolutePosition.X
		local trackSize = trackBg.AbsoluteSize.X
		local relativeX = math.clamp(mouseX - trackPos, 0, trackSize)
		local normalized = relativeX / trackSize
		currentValue = math.floor(minValue + normalized * (maxValue - minValue))
		
		fill.Size = UDim2.new(normalized, 0, 1, 0)
		thumb.Position = UDim2.new(normalized, -10, 0, 23)
		sliderValueLabel.Text = "Value: " .. tostring(currentValue)
	end
	
	thumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
		end
	end)
	
	thumb.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSliderValue(input.Position.X)
		end
	end)
	
	-- ========================================================================
	-- SECTION 3: SETTINGS
	-- ========================================================================
	
	local settingsTitle = UILib.Utils.createTextLabel(
		content,
		"Settings",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 210),
		16,
		theme.accent
	)
	settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	settingsTitle.Font = Enum.Font.GothamBold
	
	-- Close/Destroy GUI Button
	local closeButton = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(1, 0, 0, 40),
		UDim2.new(0, 0, 0, 240),
		8,
		Color3.fromRGB(220, 50, 50),
		0
	)
	closeButton.Name = "CloseButton"
	
	local closeButtonLabel = UILib.Utils.createTextLabel(
		closeButton,
		"Destroy GUI",
		UDim2.new(1, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		14,
		Color3.fromRGB(255, 255, 255)
	)
	closeButtonLabel.Font = Enum.Font.GothamBold
	
	local closeButtonTextButton = Instance.new("TextButton")
	closeButtonTextButton.Text = ""
	closeButtonTextButton.Size = UDim2.new(1, 0, 1, 0)
	closeButtonTextButton.BackgroundTransparency = 1
	closeButtonTextButton.Parent = closeButton
	
	-- Hover effects for close button
	closeButtonTextButton.MouseEnter:Connect(function()
		UILib.Animations.animateColor(closeButton.BackgroundColor3, Color3.fromRGB(250, 100, 100), 0.2, function(color)
			closeButton.BackgroundColor3 = color
		end)
	end)
	
	closeButtonTextButton.MouseLeave:Connect(function()
		UILib.Animations.animateColor(closeButton.BackgroundColor3, Color3.fromRGB(220, 50, 50), 0.2, function(color)
			closeButton.BackgroundColor3 = color
		end)
	end)
	
	closeButtonTextButton.Activated:Connect(function()
		print("Destroying GUI...")
		screenGui:Destroy()
		isGuiOpen = false
		guiContainer = nil
	end)
	
	isGuiOpen = true
end

-- ============================================================================
-- TOGGLE GUI WITH KEYBOARD
-- ============================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Press 'G' to toggle GUI
	if input.KeyCode == Enum.KeyCode.G then
		if not isGuiOpen then
			createMainGui()
		else
			if guiContainer and guiContainer.Parent then
				guiContainer:Destroy()
			end
			isGuiOpen = false
			guiContainer = nil
		end
	end
end)

-- ============================================================================
-- CREATE GUI ON STARTUP
-- ============================================================================

createMainGui()

print("✓ Example GUI loaded! Press 'G' to toggle the GUI")
print("✓ OrcaUILibrary is working correctly!")
