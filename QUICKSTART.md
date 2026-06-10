-- Quick Start Guide: Loading the Example GUI

--[[
    OPTION 1: Load from GitHub (Recommended for Executors)
    Use this method in your executor:
]]

local function loadFromGithub(branch)
    branch = branch or "ui-library-refactor"
    local baseUrl = "https://raw.githubusercontent.com/smurffucking1/sc/" .. branch .. "/"
    
    -- Load dependencies first
    local roact = loadstring(game:HttpGet(baseUrl .. "roact"))()
    
    -- Load UI Library
    local UILibrary = loadstring(game:HttpGet(baseUrl .. "orcab-ui-library"))()
    
    -- Load components
    local BrightButton = loadstring(game:HttpGet(baseUrl .. "components/BrightButton"))()
    local BrightSlider = loadstring(game:HttpGet(baseUrl .. "components/BrightSlider"))()
    local Border = loadstring(game:HttpGet(baseUrl .. "components/Border"))()
    local Acrylic = loadstring(game:HttpGet(baseUrl .. "components/Acrylic"))()
    
    -- Load example GUI
    local ExampleGUI = loadstring(game:HttpGet(baseUrl .. "example-gui"))()
    
    return {
        roact = roact,
        UILibrary = UILibrary,
        components = {
            BrightButton = BrightButton,
            BrightSlider = BrightSlider,
            Border = Border,
            Acrylic = Acrylic
        },
        ExampleGUI = ExampleGUI
    }
end

--[[
    OPTION 2: Copy-Paste into Executor
    
    Step 1: Copy the orcab-ui-library file content
    Step 2: Copy the example-gui file content
    Step 3: Paste this into your executor:
]]

-- Example executor script:
local gui = loadstring(game:HttpGet("https://raw.githubusercontent.com/smurffucking1/sc/ui-library-refactor/example-gui"))()

-- To destroy the GUI:
gui.unmount()


--[[
    OPTION 3: Step-by-Step Setup (For Testing)
    
    1. Open the repository: https://github.com/smurffucking1/sc
    2. Switch to branch: ui-library-refactor
    3. Copy raw content of "orcab-ui-library"
    4. Copy raw content of "example-gui"
    5. Run in executor:
]]

-- Define the files locally
local UILibraryCode = [[
-- Paste orcab-ui-library content here
]]

local ExampleGuiCode = [[
-- Paste example-gui content here
]]

-- Execute
local UILib = loadstring(UILibraryCode)()
local GUI = loadstring(ExampleGuiCode)()


--[[
    OPTION 4: Direct Roblox Studio (LocalScript)
    
    If you want to test in Roblox Studio:
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Create a simple LocalScript in StarterGui
local exampleGuiScript = Instance.new("LocalScript")
exampleGuiScript.Source = [[
    -- Your example-gui code here
]]
exampleGuiScript.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")


--[[
    QUICK START (Copy-Paste This)
    Just paste this single line into your executor:
]]

loadstring(game:HttpGet("https://raw.githubusercontent.com/smurffucking1/sc/ui-library-refactor/example-gui"))()


--[[
    TROUBLESHOOTING:
    
    Q: "HttpGet is not available"
    A: Enable HTTP requests in your executor settings
    
    Q: "Module not found"
    A: Make sure the branch is "ui-library-refactor" and all files are present
    
    Q: "Roact not found"
    A: Roact needs to be loaded first or available in the repo
    
    Q: How do I destroy the GUI?
    A: Call the returned unmount function or press the Destroy button in the GUI
]]

print("✓ UI Library loaded successfully!")
print("✓ Example GUI is now running!")
print("✓ Click the red 'Destroy' button to close the GUI")
