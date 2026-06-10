-- ============================================================================
-- ORCA UI LIBRARY - EXECUTOR VERSION (All-in-One)
-- ============================================================================
-- Single file designed for executor usage
-- Usage: local UILib = loadstring(game:HttpGet("url"))()
--        UILib.createExampleGUI()
-- ============================================================================

local UILib = {}

-- ============================================================================
-- SERVICES
-- ============================================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- ============================================================================
-- CORE COMPONENTS
-- ============================================================================

function UILib.Button(props)
	return {
		type = "Button",
		props = props
	}
end

function UILib.Slider(props)
	return {
		type = "Slider",
		props = props
	}
end

function UILib.Container(props, children)
	return {
		type = "Container",
		props = props,
		children = children or {}
	}
end

-- ============================================================================
-- ANIMATION UTILITIES
-- ============================================================================

UILib.Animations = {}

function UILib.Animations.animateColor(startColor, endColor, duration, callback)
	local startTime = tick()
	local connection
	connection = game:GetService("RunService").RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		local progress = math.min(elapsed / duration, 1)
		
		local animatedColor = startColor:Lerp(endColor, progress)
		callback(animatedColor)
		
		if progress >= 1 then
			connection:Disconnect()
		end
	end)
	return connection
end

function UILib.Animations.animateValue(startValue, endValue, duration, callback)
	local startTime = tick()
	local connection
	connection = game:GetService("RunService").RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		local progress = math.min(elapsed / duration, 1)
		
		local animatedValue = startValue + (endValue - startValue) * progress
		callback(animatedValue)
		
		if progress >= 1 then
			connection:Disconnect()
		end
	end)
	return connection
end

function UILib.Animations.springAnimation(targetValue, initialValue, damping, frequency, callback)
	local velocity = 0
	local currentValue = initialValue
	local connection
	
	connection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
		local delta = targetValue - currentValue
		velocity = velocity + delta * frequency * frequency * deltaTime
		velocity = velocity * (1 - damping * deltaTime)
		currentValue = currentValue + velocity * deltaTime
		
		callback(currentValue)
		
		if math.abs(delta) < 0.001 and math.abs(velocity) < 0.001 then
			connection:Disconnect()
		end
	end)
	return connection
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

UILib.Utils = {}

function UILib.Utils.hexToColor3(hex)
	hex = hex:gsub("#", "")
	return Color3.fromRGB(
		tonumber(hex:sub(1, 2), 16),
		tonumber(hex:sub(3, 4), 16),
		tonumber(hex:sub(5, 6), 16)
	)
end

function UILib.Utils.mapValue(value, inMin, inMax, outMin, outMax)
	return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

function UILib.Utils.createRoundedFrame(parent, size, position, radius, color, transparency)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = position
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = transparency or 0
	frame.BorderSizePixel = 0
	frame.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = frame
	
	return frame
end

function UILib.Utils.createTextLabel(parent, text, size, position, fontSize, textColor)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Size = size
	label.Position = position
	label.BackgroundTransparency = 1
	label.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
	label.TextSize = fontSize or 14
	label.Font = Enum.Font.GothamBold
	label.Parent = parent
	
	return label
end

function UILib.Utils.createButton(parent, text, size, position, color, onClick)
	local button = UILib.Utils.createRoundedFrame(parent, size, position, 8, color, 0)
	
	local label = UILib.Utils.createTextLabel(
		button,
		text,
		UDim2.new(1, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		14,
		Color3.fromRGB(255, 255, 255)
	)
	label.Font = Enum.Font.GothamBold
	
	local textButton = Instance.new("TextButton")
	textButton.Text = ""
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.BackgroundTransparency = 1
	textButton.Parent = button
	
	textButton.Activated:Connect(function()
		if onClick then onClick() end
	end)
	
	return button
end

-- ============================================================================
-- THEME MANAGER
-- ============================================================================

UILib.ThemeManager = {}
UILib.ThemeManager.themes = {}

function UILib.ThemeManager.createTheme(name, colors)
	UILib.ThemeManager.themes[name] = colors
	return colors
end

function UILib.ThemeManager.getTheme(name)
	return UILib.ThemeManager.themes[name] or UILib.ThemeManager.themes.dark
end

-- Create default themes
UILib.ThemeManager.createTheme("light", {
	primary = Color3.fromRGB(59, 89, 152),
	secondary = Color3.fromRGB(108, 132, 187),
	background = Color3.fromRGB(240, 242, 245),
	foreground = Color3.fromRGB(255, 255, 255),
	accent = Color3.fromRGB(31, 178, 255),
	border = Color3.fromRGB(200, 200, 200),
	hover = Color3.fromRGB(235, 235, 235),
	active = Color3.fromRGB(30, 150, 240)
})

UILib.ThemeManager.createTheme("dark", {
	primary = Color3.fromRGB(25, 25, 25),
	secondary = Color3.fromRGB(40, 40, 40),
	background = Color3.fromRGB(18, 18, 18),
	foreground = Color3.fromRGB(255, 255, 255),
	accent = Color3.fromRGB(31, 178, 255),
	border = Color3.fromRGB(60, 60, 60),
	hover = Color3.fromRGB(45, 45, 45),
	active = Color3.fromRGB(30, 150, 240)
})

-- ============================================================================
-- RENDERER
-- ============================================================================

UILib.Renderer = {}

function UILib.Renderer.render(component, parent)
	if component.type == "Button" then
		return UILib.Renderer.renderButton(component.props, parent)
	elseif component.type == "Slider" then
		return UILib.Renderer.renderSlider(component.props, parent)
	elseif component.type == "Container" then
		return UILib.Renderer.renderContainer(component.props, component.children, parent)
	end
end

function UILib.Renderer.renderButton(props, parent)
	local button = UILib.Utils.createRoundedFrame(
		parent,
		props.size or UDim2.new(0, 100, 0, 50),
		props.position or UDim2.new(0, 0, 0, 0),
		props.radius or 8,
		props.color or Color3.fromRGB(255, 255, 255),
		props.transparency or 0
	)
	
	if props.borderEnabled then
		local stroke = Instance.new("UIStroke")
		stroke.Color = props.borderColor or Color3.fromRGB(200, 200, 200)
		stroke.Thickness = 2
		stroke.Transparency = 0.2
		stroke.Parent = button
	end
	
	local textButton = Instance.new("TextButton")
	textButton.Text = ""
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.Position = UDim2.new(0, 0, 0, 0)
	textButton.BackgroundTransparency = 1
	textButton.Parent = button
	
	textButton.MouseEnter:Connect(function()
		if props.onHover then props.onHover(true) end
		if props.hoverColor then
			UILib.Animations.animateColor(button.BackgroundColor3, props.hoverColor, 0.15, function(color)
				button.BackgroundColor3 = color
			end)
		end
	end)
	
	textButton.MouseLeave:Connect(function()
		if props.onHover then props.onHover(false) end
		if props.hoverColor and props.color then
			UILib.Animations.animateColor(button.BackgroundColor3, props.color, 0.15, function(color)
				button.BackgroundColor3 = color
			end)
		end
	end)
	
	textButton.Activated:Connect(function()
		if props.onActivate then props.onActivate() end
	end)
	
	return button
end

function UILib.Renderer.renderSlider(props, parent)
	local container = Instance.new("Frame")
	container.Size = props.size or UDim2.new(0, 200, 0, 50)
	container.Position = props.position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	local track = UILib.Utils.createRoundedFrame(
		container,
		UDim2.new(1, 0, 0, 6),
		UDim2.new(0, 0, 0.5, -3),
		3,
		props.color or Color3.fromRGB(200, 200, 200),
		props.transparency or 0
	)
	
	local fill = UILib.Utils.createRoundedFrame(
		track,
		UDim2.new(0.5, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		3,
		props.accentColor or Color3.fromRGB(31, 178, 255),
		props.indicatorTransparency or 0
	)
	
	local thumb = UILib.Utils.createRoundedFrame(
		container,
		UDim2.new(0, 20, 0, 20),
		UDim2.new(0.5, -10, 0.5, -10),
		10,
		props.accentColor or Color3.fromRGB(31, 178, 255),
		0
	)
	
	local isDragging = false
	local currentValue = props.initialValue or ((props.min or 0) + (props.max or 100)) / 2
	
	local function updateSlider(mouseX)
		local trackPos = track.AbsolutePosition.X
		local trackSize = track.AbsoluteSize.X
		local relativeX = math.clamp(mouseX - trackPos, 0, trackSize)
		local normalized = relativeX / trackSize
		currentValue = (props.min or 0) + normalized * ((props.max or 100) - (props.min or 0))
		
		fill.Size = UDim2.new(normalized, 0, 1, 0)
		thumb.Position = UDim2.new(normalized, -10, 0.5, -10)
		
		if props.onValueChanged then props.onValueChanged(currentValue) end
	end
	
	thumb.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
		end
	end)
	
	thumb.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = false
			if props.onRelease then props.onRelease(currentValue) end
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)
	
	return container
end

function UILib.Renderer.renderContainer(props, children, parent)
	local container = UILib.Utils.createRoundedFrame(
		parent,
		props.size or UDim2.new(1, 0, 1, 0),
		props.position or UDim2.new(0, 0, 0, 0),
		props.cornerRadius or 0,
		props.backgroundColor or Color3.fromRGB(255, 255, 255),
		props.backgroundTransparency or 0.1
	)
	
	if children then
		for _, child in ipairs(children) do
			UILib.Renderer.render(child, container)
		end
	end
	
	return container
end

-- ============================================================================
-- EXAMPLE GUI CREATOR - EXECUTOR OPTIMIZED
-- ============================================================================

function UILib.createExampleGUI()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	
	-- Destroy existing GUI
	local existingGui = playerGui:FindFirstChild("OrcaExampleGui")
	if existingGui then
		existingGui:Destroy()
	end
	
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OrcaExampleGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	local theme = UILib.ThemeManager.getTheme("dark")
	
	-- ========================================================================
	-- MAIN CONTAINER
	-- ========================================================================
	
	local mainContainer = UILib.Utils.createRoundedFrame(
		screenGui,
		UDim2.new(0, 400, 0, 550),
		UDim2.new(0.5, -200, 0.5, -275),
		12,
		theme.primary,
		0
	)
	
	-- Shadow
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
	
	local titleLabel = UILib.Utils.createTextLabel(
		header,
		"🎨 Orca UI Library",
		UDim2.new(1, -20, 1, 0),
		UDim2.new(0, 10, 0, 0),
		20,
		Color3.fromRGB(255, 255, 255)
	)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Font = Enum.Font.GothamBold
	
	-- ========================================================================
	-- CONTENT
	-- ========================================================================
	
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -30, 1, -90)
	content.Position = UDim2.new(0, 15, 0, 70)
	content.BackgroundTransparency = 1
	content.Parent = mainContainer
	
	-- ========================================================================
	-- SECTION 1: BUTTONS
	-- ========================================================================
	
	local buttonTitle = UILib.Utils.createTextLabel(
		content,
		"📌 BUTTONS",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 0),
		14,
		theme.accent
	)
	buttonTitle.TextXAlignment = Enum.TextXAlignment.Left
	buttonTitle.Font = Enum.Font.GothamBold
	
	-- Button 1
	local btn1 = UILib.Utils.createButton(
		content,
		"Click Me!",
		UDim2.new(0.45, 0, 0, 40),
		UDim2.new(0, 0, 0, 25),
		theme.accent,
		function()
			print("✓ Button 1 clicked!")
			-- Color animation
			UILib.Animations.animateColor(btn1.BackgroundColor3, Color3.fromRGB(100, 200, 100), 0.2, function(color)
				btn1.BackgroundColor3 = color
			end)
			task.wait(0.2)
			UILib.Animations.animateColor(btn1.BackgroundColor3, theme.accent, 0.2, function(color)
				btn1.BackgroundColor3 = color
			end)
		end
	)
	
	-- Button 2
	local btn2 = UILib.Utils.createButton(
		content,
		"Button 2",
		UDim2.new(0.45, 0, 0, 40),
		UDim2.new(0.55, 0, 0, 25),
		theme.secondary,
		function()
			print("✓ Button 2 clicked!")
		end
	)
	
	-- ========================================================================
	-- SECTION 2: SLIDER
	-- ========================================================================
	
	local sliderTitle = UILib.Utils.createTextLabel(
		content,
		"🎚️ SLIDER",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 80),
		14,
		theme.accent
	)
	sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
	sliderTitle.Font = Enum.Font.GothamBold
	
	-- Slider value label
	local valueLabel = UILib.Utils.createTextLabel(
		content,
		"Volume: 50",
		UDim2.new(1, 0, 0, 18),
		UDim2.new(0, 0, 0, 105),
		12,
		Color3.fromRGB(200, 200, 200)
	)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Slider track
	local sliderBg = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(1, 0, 0, 6),
		UDim2.new(0, 0, 0, 130),
		3,
		theme.secondary,
		0
	)
	
	-- Slider fill
	local sliderFill = UILib.Utils.createRoundedFrame(
		sliderBg,
		UDim2.new(0.5, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		3,
		theme.accent,
		0
	)
	
	-- Slider thumb
	local sliderThumb = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(0, 20, 0, 20),
		UDim2.new(0.5, -10, 0, 123),
		10,
		theme.accent,
		0
	)
	
	local sliderValue = 50
	local sliderDragging = false
	
	local function updateSlider(mouseX)
		local trackPos = sliderBg.AbsolutePosition.X
		local trackSize = sliderBg.AbsoluteSize.X
		local relativeX = math.clamp(mouseX - trackPos, 0, trackSize)
		local normalized = relativeX / trackSize
		sliderValue = math.floor(normalized * 100)
		
		sliderFill.Size = UDim2.new(normalized, 0, 1, 0)
		sliderThumb.Position = UDim2.new(normalized, -10, 0, 123)
		valueLabel.Text = "Volume: " .. tostring(sliderValue)
	end
	
	sliderThumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliderDragging = true
		end
	end)
	
	sliderThumb.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliderDragging = false
			print("✓ Slider set to: " .. sliderValue)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)
	
	-- ========================================================================
	-- SECTION 3: STATUS
	-- ========================================================================
	
	local statusTitle = UILib.Utils.createTextLabel(
		content,
		"ℹ️ STATUS",
		UDim2.new(1, 0, 0, 20),
		UDim2.new(0, 0, 0, 160),
		14,
		theme.accent
	)
	statusTitle.TextXAlignment = Enum.TextXAlignment.Left
	statusTitle.Font = Enum.Font.GothamBold
	
	local statusBox = UILib.Utils.createRoundedFrame(
		content,
		UDim2.new(1, 0, 0, 50),
		UDim2.new(0, 0, 0, 185),
		8,
		theme.secondary,
		0.3
	)
	
	local statusText = UILib.Utils.createTextLabel(
		statusBox,
		"✓ GUI Loaded\n✓ All systems ready\n✓ Click buttons to test",
		UDim2.new(1, -10, 1, -10),
		UDim2.new(0, 5, 0, 5),
		11,
		Color3.fromRGB(100, 220, 100)
	)
	statusText.TextWrapped = true
	statusText.TextXAlignment = Enum.TextXAlignment.Left
	statusText.TextYAlignment = Enum.TextYAlignment.Top
	
	-- ========================================================================
	-- FOOTER: DESTROY BUTTON
	-- ========================================================================
	
	local destroyBtn = UILib.Utils.createButton(
		mainContainer,
		"❌ Destroy GUI",
		UDim2.new(1, -30, 0, 40),
		UDim2.new(0, 15, 1, -50),
		Color3.fromRGB(220, 50, 50),
		function()
			print("✓ Destroying GUI...")
			screenGui:Destroy()
		end
	)
	
	-- Hover effect on destroy button
	local destroyTextButton = destroyBtn:FindFirstChildOfClass("TextButton")
	destroyTextButton.MouseEnter:Connect(function()
		UILib.Animations.animateColor(destroyBtn.BackgroundColor3, Color3.fromRGB(250, 100, 100), 0.15, function(color)
			destroyBtn.BackgroundColor3 = color
		end)
	end)
	destroyTextButton.MouseLeave:Connect(function()
		UILib.Animations.animateColor(destroyBtn.BackgroundColor3, Color3.fromRGB(220, 50, 50), 0.15, function(color)
			destroyBtn.BackgroundColor3 = color
		end)
	end)
	
	print("✓ Example GUI created!")
	return screenGui
end

-- ============================================================================
-- STARTUP
-- ============================================================================

print("\n" .. string.rep("=", 50))
print("✓ Orca UI Library v1.0 - Executor Edition")
print("=" .. string.rep("=", 49))
print("\n📝 USAGE:")
print("   local UILib = loadstring(game:HttpGet('url'))()")
print("   UILib.createExampleGUI()")
print("\n🎨 FEATURES:")
print("   • Smooth animations")
print("   • Interactive buttons")
print("   • Draggable sliders")
print("   • Theme system")
print("\n" .. string.rep("=", 50) .. "\n")

return UILib
