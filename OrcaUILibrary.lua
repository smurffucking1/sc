-- ============================================================================
-- ORCA UI LIBRARY - MODULAR UI COMPONENT LIBRARY
-- ============================================================================
-- This is a simplified UI library focused on pure presentation and animations
-- All business logic has been removed for maximum reusability
-- ============================================================================

local UILibrary = {}

-- ============================================================================
-- CORE COMPONENTS - Pure UI Components
-- ============================================================================

-- Button Component - Pure presentation, no business logic
function UILibrary.Button(props)
	--[[
		Props:
		- size: UDim2 - Button size
		- position: UDim2 - Button position
		- radius: number - Corner radius
		- color: Color3 - Background color
		- borderEnabled: boolean - Show border
		- borderColor: Color3 - Border color
		- transparency: number - Background transparency
		- onActivate: function() - Called when clicked
		- onHover: function(isHovered: boolean) - Called on hover
		- children: table - Child elements
	--]]
	return {
		type = "Button",
		props = props
	}
end

-- Slider Component - Pure presentation
function UILibrary.Slider(props)
	--[[
		Props:
		- min: number - Minimum value
		- max: number - Maximum value
		- initialValue: number - Starting value
		- size: UDim2 - Slider size
		- position: UDim2 - Slider position
		- radius: number - Corner radius
		- color: Color3 - Track color
		- accentColor: Color3 - Fill color
		- borderEnabled: boolean - Show border
		- borderColor: Color3 - Border color
		- transparency: number - Track transparency
		- indicatorTransparency: number - Fill transparency
		- onValueChanged: function(value) - Called while dragging
		- onRelease: function(value) - Called on release
	--]]
	return {
		type = "Slider",
		props = props
	}
end

-- Container Component - Pure layout
function UILibrary.Container(props, children)
	--[[
		Props:
		- size: UDim2
		- position: UDim2
		- backgroundColor: Color3
		- backgroundTransparency: number
		- cornerRadius: number
		- children: table
	--]]
	return {
		type = "Container",
		props = props,
		children = children or {}
	}
end

-- ============================================================================
-- ANIMATION UTILITIES
-- ============================================================================

local Animations = {}

-- Color animation using linear interpolation
function Animations.animateColor(startColor, endColor, duration, callback)
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

-- Value animation (for sliders, etc)
function Animations.animateValue(startValue, endValue, duration, callback)
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

-- Spring physics animation
function Animations.springAnimation(targetValue, initialValue, damping, frequency, callback)
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

UILibrary.Animations = Animations

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local Utils = {}

-- Convert hex color to Color3
function Utils.hexToColor3(hex)
	hex = hex:gsub("#", "")
	return Color3.fromRGB(
		tonumber(hex:sub(1, 2), 16),
		tonumber(hex:sub(3, 4), 16),
		tonumber(hex:sub(5, 6), 16)
	)
end

-- Map a value from one range to another
function Utils.mapValue(value, inMin, inMax, outMin, outMax)
	return outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
end

-- Create rounded corner frame
function Utils.createRoundedFrame(parent, size, position, radius, color, transparency)
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

-- Create text label
function Utils.createTextLabel(parent, text, size, position, fontSize, textColor)
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

UILibrary.Utils = Utils

-- ============================================================================
-- THEME SYSTEM
-- ============================================================================

local ThemeManager = {}
ThemeManager.themes = {}

-- Create a new theme
function ThemeManager.createTheme(name, colors)
	--[[
		colors structure:
		{
			primary = Color3,
			secondary = Color3,
			background = Color3,
			foreground = Color3,
			accent = Color3,
			border = Color3,
			hover = Color3,
			active = Color3
		}
	--]]
	ThemeManager.themes[name] = colors
	return colors
end

-- Get a theme
function ThemeManager.getTheme(name)
	return ThemeManager.themes[name] or ThemeManager.themes.default
end

-- Light theme (default)
ThemeManager.createTheme("light", {
	primary = Color3.fromRGB(59, 89, 152),
	secondary = Color3.fromRGB(108, 132, 187),
	background = Color3.fromRGB(240, 242, 245),
	foreground = Color3.fromRGB(255, 255, 255),
	accent = Color3.fromRGB(31, 178, 255),
	border = Color3.fromRGB(200, 200, 200),
	hover = Color3.fromRGB(235, 235, 235),
	active = Color3.fromRGB(30, 150, 240)
})

-- Dark theme
ThemeManager.createTheme("dark", {
	primary = Color3.fromRGB(25, 25, 25),
	secondary = Color3.fromRGB(40, 40, 40),
	background = Color3.fromRGB(18, 18, 18),
	foreground = Color3.fromRGB(255, 255, 255),
	accent = Color3.fromRGB(31, 178, 255),
	border = Color3.fromRGB(60, 60, 60),
	hover = Color3.fromRGB(45, 45, 45),
	active = Color3.fromRGB(30, 150, 240)
})

UILibrary.ThemeManager = ThemeManager

-- ============================================================================
-- RENDERER - Converts UI components to Roblox instances
-- ============================================================================

local Renderer = {}

function Renderer.render(component, parent)
	if component.type == "Button" then
		return Renderer.renderButton(component.props, parent)
	elseif component.type == "Slider" then
		return Renderer.renderSlider(component.props, parent)
	elseif component.type == "Container" then
		return Renderer.renderContainer(component.props, component.children, parent)
	end
end

function Renderer.renderButton(props, parent)
	local button = Utils.createRoundedFrame(
		parent,
		props.size or UDim2.new(0, 100, 0, 50),
		props.position or UDim2.new(0, 0, 0, 0),
		props.radius or 8,
		props.color or Color3.fromRGB(255, 255, 255),
		props.transparency or 0
	)
	
	-- Add border if enabled
	if props.borderEnabled then
		local stroke = Instance.new("UIStroke")
		stroke.Color = props.borderColor or Color3.fromRGB(200, 200, 200)
		stroke.Thickness = 2
		stroke.Transparency = 0.2
		stroke.Parent = button
	end
	
	-- Make it interactive
	local textButton = Instance.new("TextButton")
	textButton.Text = ""
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.Position = UDim2.new(0, 0, 0, 0)
	textButton.BackgroundTransparency = 1
	textButton.Parent = button
	
	local isHovered = false
	
	textButton.MouseEnter:Connect(function()
		isHovered = true
		if props.onHover then props.onHover(true) end
		-- Animate to hover color
		if props.hoverColor then
			Animations.animateColor(button.BackgroundColor3, props.hoverColor, 0.15, function(color)
				button.BackgroundColor3 = color
			end)
		end
	end)
	
	textButton.MouseLeave:Connect(function()
		isHovered = false
		if props.onHover then props.onHover(false) end
		-- Animate back to original color
		if props.hoverColor and props.color then
			Animations.animateColor(button.BackgroundColor3, props.color, 0.15, function(color)
				button.BackgroundColor3 = color
			end)
		end
	end)
	
	textButton.Activated:Connect(function()
		if props.onActivate then props.onActivate() end
	end)
	
	return button
end

function Renderer.renderSlider(props, parent)
	local container = Instance.new("Frame")
	container.Size = props.size or UDim2.new(0, 200, 0, 50)
	container.Position = props.position or UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.Parent = parent
	
	-- Track
	local track = Utils.createRoundedFrame(
		container,
		UDim2.new(1, 0, 0, 6),
		UDim2.new(0, 0, 0.5, -3),
		3,
		props.color or Color3.fromRGB(200, 200, 200),
		props.transparency or 0
	)
	
	-- Progress fill
	local fill = Utils.createRoundedFrame(
		track,
		UDim2.new(0.5, 0, 1, 0),
		UDim2.new(0, 0, 0, 0),
		3,
		props.accentColor or Color3.fromRGB(31, 178, 255),
		props.indicatorTransparency or 0
	)
	
	-- Thumb
	local thumb = Utils.createRoundedFrame(
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
	
	game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessed)
		if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input.Position.X)
		end
	end)
	
	return container
end

function Renderer.renderContainer(props, children, parent)
	local container = Utils.createRoundedFrame(
		parent,
		props.size or UDim2.new(1, 0, 1, 0),
		props.position or UDim2.new(0, 0, 0, 0),
		props.cornerRadius or 0,
		props.backgroundColor or Color3.fromRGB(255, 255, 255),
		props.backgroundTransparency or 0.1
	)
	
	if children then
		for _, child in ipairs(children) do
			Renderer.render(child, container)
		end
	end
	
	return container
end

UILibrary.Renderer = Renderer

-- ============================================================================
-- EXPORT
-- ============================================================================

return UILibrary
