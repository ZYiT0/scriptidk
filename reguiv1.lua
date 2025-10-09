-- load regui and idemodule
local IDEModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/lib/ide.lua"))()
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/main/ReGui.lua'))()
-- much needed things 
local IDE = IDEModule.CodeFrame.new({Editable = true, FontSize = 13, LineNumbers = true})
local PrefabsId = "rbxassetid://"..ReGui.PrefabsId
ReGui:Init({Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)})

-- console shi for time
local function Timestamp()
    local t = os.date("*t")
    return string.format("[%02d:%02d:%02d]", t.hour, t.min, t.sec)
end

--create windows
local Window = ReGui:TabsWindow({Title = "Multi-Tab ReGui App", Size = UDim2.fromOffset(600, 450)})

--create all the main useful tabs
local HomeTab      = Window:CreateTab({Name = "Home"})
local CodeTab      = Window:CreateTab({Name = "Code Editor"})
local ScripthubTab = Window:CreateTab({Name = "Scripthub"})
local ConsoleTab   = Window:CreateTab({Name = "Console"})
local SettingsTab  = Window:CreateTab({Name = "Settings"})
local ProfileTab   = Window:CreateTab({Name = "Profile"})


-- shitty console

local Console = ConsoleTab:Canvas({Fill = true}) -- Fills the whole tab

local Console = Console:Console({
    LineNumbers = true,
    AutoScroll = true,
    MaxLines = 1000,
    RichText = false,
    ReadOnly = true,
    TextWrapped = true
})

Console:SetValue(Timestamp().." > Console initialized!\n")



--home contents

HomeTab:Label({
	Text = "hi welcome to regui",
	Bold = true,
	Font = "SourceSansBold",
	TextWrapped = true
})

HomeTab:Separator({Text = "Overview"})

HomeTab:Label({
	Text = "regui is made with regui lib by depthso and with the help of ai",
	Italic = true,
	TextWrapped = true
})

HomeTab:Label({
	Text = "Tabs Overview:",
	TextWrapped = true
})

HomeTab:BulletText({
	Rows = {
		"code editor: copy, paste, execute, and clear buttons with tabs",
		"scripthub: preloaded scripthub that's shit",
		"console: console but shitty",
		"settings: you can figure it out on the settings tab",
		"profile: shows information about you"
	},
	TextWrapped = true
})

HomeTab:Separator({Text = "some cool details"})

local FeatureTree = HomeTab:TreeNode({
	Title = "cool features",
	Collapsed = false
})
FeatureTree:Label({
	Text = "• multi tabs on code editor: 10 tabs you can use idk",
	TextWrapped = true
})
FeatureTree:Label({
	Text = "• code editor: you can execute your stuff straight from the code editor tab",
	TextWrapped = true
})
FeatureTree:Label({
	Text = "• scripthub: preloaded scripthub kinda shitty for now",
	TextWrapped = true
})
FeatureTree:Label({
	Text = "• console: shows the stuff you executed and stuff ( ass tho will rework with ai )",
	TextWrapped = true
})
FeatureTree:Label({
	Text = "• settings: adjust themes, adjust keybinds, and I forgot the rest so find out",
	TextWrapped = true
})
FeatureTree:Label({
	Text = "• profiles: Shows information about your account",
	TextWrapped = true
})

local Header = HomeTab:CollapsingHeader({
	Title = "Extra information",
	Collapsed = true
})
Header:Label({
	Text = "• Multiple tabs but none save if you rejoin and execute again",
	TextWrapped = true
})
Header:Label({
	Text = "• Console shows it ( kinda ass tho )",
	TextWrapped = true
})
Header:Label({
	Text = "• you can copy scripts from preloaded scripthub ( will add more soon maybe )",
	TextWrapped = true
})
Header:Label({
	Text = "• change keybinds in setting like ui visibility or execute directly instead of pressing execute",
	TextWrapped = true
})
Header:Label({
	Text = "• REGUI themes allow you to change the appearance of your the ui",
	TextWrapped = true
})

HomeTab:Separator()
HomeTab:Indent({Offset = 20}):Label({
	Text = "REGUI — a script thingy I made for fun ",
	Italic = true,
	TextWrapped = true
})


--code editor shi

local CodeEditor = IDEModule.CodeFrame.new({
    Editable = true,
    FontSize = 13,
    Colors = SyntaxColors,
    FontFace = TextFont
})

-- for like uh where they are on ui
local TabRow = CodeTab:Row({Spacing = 4})        -
local IDEContainer = CodeTab:Canvas({Fill=true})
local ButtonRow = CodeTab:Row({Spacing = 6})     

-- NEED THIS
ReGui:ApplyFlags({
    Object = CodeEditor.Gui,
    WindowClass = Window,
    Class = {
        Fill = true,
        Active = true,
        Parent = IDEContainer:GetObject(),
        BackgroundTransparency = 1
    }
})

-- start tabs
local Tabs = {}
local ActiveTabIndex = 1

local function SwitchTab(index)
    --save tabs ( hopefully )
    if Tabs[ActiveTabIndex] then
        Tabs[ActiveTabIndex].Code = CodeEditor:GetText()
    end

    ActiveTabIndex = index
    CodeEditor:SetText(Tabs[index].Code or "")
end

-- 10 tabs created
for i = 1, 10 do
    local tabBtn = TabRow:SmallButton({
        Text = "Tab "..i,
        Callback = function()
            SwitchTab(i)
        end
    })
    Tabs[i] = {Button = tabBtn, Code = ""}
end

-- the 4 buttons skidded from phantom8015 since I didn't know how
ButtonRow:Button({Text = "Execute", Callback = function()
    local code = CodeEditor:GetText()
    if code and #code > 0 then
        local ok, result = pcall(function()
            local func, err = loadstring(code)
            if func then return func() else error(err) end
        end)
        if ok then
            Console:AppendText(Timestamp().." > Executed code\n")
            if result ~= nil then Console:AppendText(Timestamp().." > Output: "..tostring(result).."\n") end
        else
            Console:AppendText(Timestamp().." > Error: "..tostring(result).."\n")
        end
        Tabs[ActiveTabIndex].Code = code
    else
        Console:AppendText(Timestamp().." > Nothing to execute\n")
    end
end})

ButtonRow:Button({Text = "Clear", Callback = function()
    CodeEditor:SetText("")
    Tabs[ActiveTabIndex].Code = ""
end})

ButtonRow:Button({Text = "Copy", Callback = function()
    pcall(function() setclipboard(CodeEditor:GetText()) end)
    Console:AppendText(Timestamp().." > Copied to clipboard\n")
end})

ButtonRow:Button({Text = "Paste", Callback = function()
    local ok, cb = pcall(function() return getclipboard() end)
    if ok and type(cb) == "string" then
        CodeEditor:SetText(cb)
    end
    Console:AppendText(Timestamp().." > Pasted from clipboard\n")
end})

-- start on tab 1 
SwitchTab(1)

--scripthub ( all preloaded idk how to make it work with it and stuff)


local preloadedScripts = {
    {name="Infinite Yield", code="loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()", image="rbxassetid://11176073582"},
    {name="Cat Script 2", code="print('Hello from Cat Script 2!')", image="rbxassetid://15092340565"},
    {name="Cat Script 3", code="print('Hello from Cat Script 3!')", image="rbxassetid://14863922089"},
    {name="Cat Script 4", code="print('Hello from Cat Script 4!')", image="rbxassetid://11176073582"},
    {name="Cat Script 5", code="print('Hello from Cat Script 5!')", image="rbxassetid://6031075937"},
    {name="Cat Script 6", code="print('Hello from Cat Script 6!')", image="rbxassetid://146317755"},
    {name="Cat Script 7", code="print('Hello from Cat Script 7!')", image="rbxassetid://146317755"},
    {name="Cat Script 8", code="print('Hello from Cat Script 8!')", image="rbxassetid://146317755"},
    {name="Cat Script 9", code="print('Hello from Cat Script 9!')", image="rbxassetid://146317755"},
    {name="Cat Script 10", code="print('Hello from Cat Script 10!')", image="rbxassetid://146317755"},
    {name="Cat Script 11", code="print('Test')", image="rbxassetid://6031075937"}
}

local Table = ScripthubTab:Table({Align="Top", Border=false, RowBackground=false})
local scriptsPerRow = 5
local scriptCount = #preloadedScripts

for i = 1, scriptCount, scriptsPerRow do
    local Row = Table:Row()
    for j = i, math.min(i + scriptsPerRow - 1, scriptCount) do
        local s = preloadedScripts[j]
        local Column = Row:Column()

        Column:Label({Text = s.name, Bold = true, Font = "SourceSansBold"})
        Column:Image({Image = s.image, Size = UDim2.fromOffset(80, 80)})

        local ButtonRow = Column:Row({Spacing = 4})

        ButtonRow:Button({
            Text = "Execute",
            Callback = function()
                local ok, result = pcall(function()
                    local func, err = loadstring(s.code)
                    if func then return func() else error(err) end
                end)
                if ok then
                    Console:AppendText(Timestamp().." > Executed script: "..s.name.."\n")
                else
                    Console:AppendText(Timestamp().." > Error executing script: "..tostring(result).."\n")
                end
            end
        })

        ButtonRow:Button({
            Text = "Copy",
            Callback = function()
                local ModalWindow = ReGui:PopupModal({
                    Title = "Copy Script to Tab",
                    NoResize = false,
                    NoClose = false
                })
                ModalWindow:Label({
                    Text = "Choose which Code Editor tab to copy this script to:",
                    TextWrapped = true
                })
                ModalWindow:Separator()

                local TabsRow = ModalWindow:Row({Expanded = true})
                for tabIndex = 1, #Tabs do
                    TabsRow:Button({
                        Text = "Tab "..tabIndex,
                        Callback = function()
                            CodeEditor:SetText(s.code)
                            Tabs[tabIndex].Code = s.code
                            Console:AppendText(Timestamp().." > Copied "..s.name.." to Tab "..tabIndex.."\n")
                            ModalWindow:ClosePopup()
                        end
                    })
                end

                local CancelRow = ModalWindow:Row({Expanded = true})
                CancelRow:Button({
                    Text = "Cancel",
                    Callback = function()
                        ModalWindow:ClosePopup()
                    end
                })
            end
        })
    end
end



--settings tab 

local function AddSection(tab, title)
    tab:Separator({Text = title})
end

-- main settings
AddSection(SettingsTab, "Main Settings")
local actionRow = SettingsTab:Row({})
actionRow:Button({Text = "Reset Code Editor", Callback = function()
    IDE:SetText("")
    Console:AppendText(Timestamp().." > Code Editor reset\n")
end})
actionRow:Button({Text = "Clear Console", Callback = function()
    Console:SetValue("") 
    Console:AppendText(Timestamp().." > Console cleared\n")
end})
actionRow:Button({Text = "Reload UI Prefabs", Callback = function()
    ReGui:Init({Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)})
    Console:AppendText(Timestamp().." > UI prefabs reloaded\n")
end})

--options for it idfk
AddSection(SettingsTab, "IDE & Console Options")
local optRow = SettingsTab:Row({})
optRow:Checkbox({Label="Auto Scroll Console", Value=true, Callback=function(self, val)
    Console.AutoScroll = val
    Console:AppendText(Timestamp().." > Auto scroll: "..tostring(val).."\n")
end})

--themes inside something treenode idk
AddSection(SettingsTab, "Themes")
local themesNode = SettingsTab:TreeNode({
    Title = "Available Themes",
    Collapsed = true,
    NoAnimation = false,
    OpenOnArrow = true
})

local themeNames = {
    "Cherry","Idk","Idk2","DarkWarm","MutatedRed","LightPastel",
    "DarkTheme","LightTheme","ForestGreen","Monochrome","SunsetPink",
    "TropicalPunch","HighVis","Retrosomethingsomething","Sandy",
    "Cyber","RobloxTheme"
}

for _, name in ipairs(themeNames) do
    themesNode:Button({
        Text = name,
        Callback = function()
            Window:SetTheme(name)
            Console:AppendText(Timestamp().." > Theme set to "..name.."\n")
        end
    })
end

--sections
AddSection(SettingsTab, "UI & Execute Keybinds")

-- ui visibility
SettingsTab:Keybind({
	Label = "Toggle UI Visibility",
	Value = Enum.KeyCode.Q,
	OnKeybindSet = function(_, NewKeybind)
		Console:AppendText(Timestamp().." > UI toggle keybind set to "..tostring(NewKeybind).."\n")
	end,
	Callback = function(_, NewKeybind)
		local IsVisible = Window.Visible
		Window:SetVisible(not IsVisible)
		Console:AppendText(Timestamp().." > UI visibility toggled ("..tostring(not IsVisible)..")\n")
	end
})

--execute shi idk
SettingsTab:Keybind({
	Label = "Execute Current Tab",
	Value = Enum.KeyCode.E,
	OnKeybindSet = function(_, NewKeybind)
		Console:AppendText(Timestamp().." > Execute keybind set to "..tostring(NewKeybind).."\n")
	end,
	Callback = function(_, NewKeybind)
		local code = CodeEditor:GetText()
		if code and #code > 0 then
			local ok, result = pcall(function()
				local func, err = loadstring(code)
				if func then return func() else error(err) end
			end)
			if ok then
				Console:AppendText(Timestamp().." > Executed code from Tab "..ActiveTabIndex.."\n")
				if result ~= nil then Console:AppendText(Timestamp().." > Output: "..tostring(result).."\n") end
			else
				Console:AppendText(Timestamp().." > Error: "..tostring(result).."\n")
			end
			Tabs[ActiveTabIndex].Code = code
		else
			Console:AppendText(Timestamp().." > Nothing to execute in Tab "..ActiveTabIndex.."\n")
		end
	end
})


--- profile tab

local pl = game:GetService("Players").LocalPlayer
ProfileTab:Image({Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..pl.UserId.."&width=420&height=420&format=png", Size = UDim2.fromOffset(100,100)})
ProfileTab:Label({Text = "Username: "..pl.Name})
ProfileTab:Label({Text = "Display Name: "..pl.DisplayName})
ProfileTab:Label({Text = "UserId: "..pl.UserId})
local ok, friends = pcall(function() return #pl:GetFriendsAsync():GetCurrentPage() end)
if ok then ProfileTab:Label({Text = "Friends Count: "..tostring(friends)}) end
ProfileTab:Label({Text = "Account Age (Days): "..tostring(pl.AccountAge)})


-- ui definitions

ReGui:DefineTheme("Cherry", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(120, 100, 120),
    Text = Color3.fromRGB(200, 180, 200),
    FrameBg = Color3.fromRGB(25, 20, 25),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(120, 100, 120),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(150, 100, 150),
    SliderGrab = Color3.fromRGB(150, 100, 150),
    ButtonsBg = Color3.fromRGB(150, 100, 150),
    CollapsingHeaderBg = Color3.fromRGB(150, 100, 150),
    CollapsingHeaderText = Color3.fromRGB(200, 180, 200),
    RadioButtonHoveredBg = Color3.fromRGB(150, 100, 150),
    WindowBg = Color3.fromRGB(35, 30, 35),
    TitleBarBg = Color3.fromRGB(35, 30, 35),
    TitleBarBgActive = Color3.fromRGB(50, 45, 50),
    Border = Color3.fromRGB(50, 45, 50),
    ResizeGrab = Color3.fromRGB(50, 45, 50),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Idk", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(100, 100, 110),
    Text = Color3.fromRGB(230, 230, 240),
    FrameBg = Color3.fromRGB(30, 35, 45),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(50, 90, 140),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(0, 120, 255),
    SliderGrab = Color3.fromRGB(0, 120, 255),
    ButtonsBg = Color3.fromRGB(0, 120, 255),
    CollapsingHeaderBg = Color3.fromRGB(50, 90, 140),
    CollapsingHeaderText = Color3.fromRGB(230, 230, 240),
    RadioButtonHoveredBg = Color3.fromRGB(50, 90, 140),
    WindowBg = Color3.fromRGB(40, 45, 60),
    TitleBarBg = Color3.fromRGB(40, 45, 60),
    TitleBarBgActive = Color3.fromRGB(60, 75, 95),
    Border = Color3.fromRGB(70, 75, 85),
    ResizeGrab = Color3.fromRGB(70, 75, 85),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Idk2", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(100, 100, 100),
    Text = Color3.fromRGB(240, 255, 240),
    FrameBg = Color3.fromRGB(20, 20, 20),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(40, 100, 40),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(50, 205, 50),
    SliderGrab = Color3.fromRGB(50, 205, 50),
    ButtonsBg = Color3.fromRGB(50, 205, 50),
    CollapsingHeaderBg = Color3.fromRGB(40, 100, 40),
    CollapsingHeaderText = Color3.fromRGB(240, 255, 240),
    RadioButtonHoveredBg = Color3.fromRGB(40, 100, 40),
    WindowBg = Color3.fromRGB(30, 30, 30),
    TitleBarBg = Color3.fromRGB(30, 30, 30),
    TitleBarBgActive = Color3.fromRGB(45, 45, 45),
    Border = Color3.fromRGB(60, 60, 60),
    ResizeGrab = Color3.fromRGB(60, 60, 60),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("DarkWarm", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(150, 110, 80),
    Text = Color3.fromRGB(255, 235, 200),
    FrameBg = Color3.fromRGB(20, 15, 10),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(150, 70, 0),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(255, 120, 0),
    SliderGrab = Color3.fromRGB(255, 120, 0),
    ButtonsBg = Color3.fromRGB(255, 120, 0),
    CollapsingHeaderBg = Color3.fromRGB(150, 70, 0),
    CollapsingHeaderText = Color3.fromRGB(255, 235, 200),
    RadioButtonHoveredBg = Color3.fromRGB(150, 70, 0),
    WindowBg = Color3.fromRGB(40, 30, 20),
    TitleBarBg = Color3.fromRGB(40, 30, 20),
    TitleBarBgActive = Color3.fromRGB(60, 45, 30),
    Border = Color3.fromRGB(80, 60, 40),
    ResizeGrab = Color3.fromRGB(80, 60, 40),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("MutatedRed", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(150, 100, 100),
    Text = Color3.fromRGB(255, 200, 200),
    FrameBg = Color3.fromRGB(25, 10, 10),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(100, 30, 30),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(200, 50, 50),
    SliderGrab = Color3.fromRGB(200, 50, 50),
    ButtonsBg = Color3.fromRGB(200, 50, 50),
    CollapsingHeaderBg = Color3.fromRGB(100, 30, 30),
    CollapsingHeaderText = Color3.fromRGB(255, 200, 200),
    RadioButtonHoveredBg = Color3.fromRGB(100, 30, 30),
    WindowBg = Color3.fromRGB(35, 20, 20),
    TitleBarBg = Color3.fromRGB(35, 20, 20),
    TitleBarBgActive = Color3.fromRGB(50, 30, 30),
    Border = Color3.fromRGB(70, 40, 40),
    ResizeGrab = Color3.fromRGB(70, 40, 40),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("LightPastel", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(100, 90, 110),
    Text = Color3.fromRGB(240, 240, 255),
    FrameBg = Color3.fromRGB(15, 15, 25),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(60, 60, 90),
    FrameBgTransparencyActive = 0.4,
    CheckMark = Color3.fromRGB(180, 150, 255),
    SliderGrab = Color3.fromRGB(180, 150, 255),
    ButtonsBg = Color3.fromRGB(180, 150, 255),
    CollapsingHeaderBg = Color3.fromRGB(60, 60, 90),
    CollapsingHeaderText = Color3.fromRGB(240, 240, 255),
    RadioButtonHoveredBg = Color3.fromRGB(60, 60, 90),
    WindowBg = Color3.fromRGB(25, 25, 40),
    TitleBarBg = Color3.fromRGB(25, 25, 40),
    TitleBarBgActive = Color3.fromRGB(40, 40, 60),
    Border = Color3.fromRGB(50, 50, 70),
    ResizeGrab = Color3.fromRGB(50, 50, 70),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("ForestGreen", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(120, 130, 120),
    Text = Color3.fromRGB(220, 255, 220),

    FrameBg = Color3.fromRGB(20, 25, 20),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(60, 90, 60),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(150, 255, 150),
    SliderGrab = Color3.fromRGB(150, 255, 150),
    ButtonsBg = Color3.fromRGB(150, 255, 150),
    CollapsingHeaderBg = Color3.fromRGB(60, 90, 60),
    CollapsingHeaderText = Color3.fromRGB(220, 255, 220),
    RadioButtonHoveredBg = Color3.fromRGB(60, 90, 60),

    WindowBg = Color3.fromRGB(30, 40, 30),
    TitleBarBg = Color3.fromRGB(30, 40, 30),
    TitleBarBgActive = Color3.fromRGB(45, 60, 45),

    Border = Color3.fromRGB(70, 85, 70),
    ResizeGrab = Color3.fromRGB(70, 85, 70),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Monochrome", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(120, 120, 120),
    Text = Color3.fromRGB(255, 255, 255),

    FrameBg = Color3.fromRGB(10, 10, 10),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(60, 60, 60),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(0, 255, 255), -- Bright Cyan Accent
    SliderGrab = Color3.fromRGB(0, 255, 255),
    ButtonsBg = Color3.fromRGB(0, 255, 255),
    CollapsingHeaderBg = Color3.fromRGB(60, 60, 60),
    CollapsingHeaderText = Color3.fromRGB(255, 255, 255),
    RadioButtonHoveredBg = Color3.fromRGB(60, 60, 60),

    WindowBg = Color3.fromRGB(20, 20, 20),
    TitleBarBg = Color3.fromRGB(20, 20, 20),
    TitleBarBgActive = Color3.fromRGB(35, 35, 35),

    Border = Color3.fromRGB(50, 50, 50),
    ResizeGrab = Color3.fromRGB(50, 50, 50),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("SunsetPink", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(180, 150, 160),
    Text = Color3.fromRGB(255, 240, 245),

    FrameBg = Color3.fromRGB(30, 25, 30),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(120, 60, 80),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(255, 80, 180),
    SliderGrab = Color3.fromRGB(255, 80, 180),
    ButtonsBg = Color3.fromRGB(255, 80, 180),
    CollapsingHeaderBg = Color3.fromRGB(120, 60, 80),
    CollapsingHeaderText = Color3.fromRGB(255, 240, 245),
    RadioButtonHoveredBg = Color3.fromRGB(120, 60, 80),

    WindowBg = Color3.fromRGB(45, 40, 45),
    TitleBarBg = Color3.fromRGB(45, 40, 45),
    TitleBarBgActive = Color3.fromRGB(65, 60, 65),

    Border = Color3.fromRGB(80, 75, 80),
    ResizeGrab = Color3.fromRGB(80, 75, 80),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("TropicalPunch", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(150, 150, 150),
    Text = Color3.fromRGB(245, 245, 245),

    FrameBg = Color3.fromRGB(30, 30, 35),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(180, 50, 80),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(255, 0, 100), -- Hot Pink
    SliderGrab = Color3.fromRGB(255, 80, 0),  -- Bright Orange
    ButtonsBg = Color3.fromRGB(255, 0, 100),
    CollapsingHeaderBg = Color3.fromRGB(180, 50, 80),
    CollapsingHeaderText = Color3.fromRGB(245, 245, 245),
    RadioButtonHoveredBg = Color3.fromRGB(180, 50, 80),

    WindowBg = Color3.fromRGB(45, 45, 50),
    TitleBarBg = Color3.fromRGB(45, 45, 50),
    TitleBarBgActive = Color3.fromRGB(65, 65, 70),

    Border = Color3.fromRGB(80, 80, 85),
    ResizeGrab = Color3.fromRGB(80, 80, 85),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("HighVis", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(130, 130, 130),
    Text = Color3.fromRGB(255, 255, 255),

    FrameBg = Color3.fromRGB(20, 20, 30),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(150, 150, 0),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(255, 255, 0), -- Bright Yellow
    SliderGrab = Color3.fromRGB(200, 255, 0), -- Lime Green
    ButtonsBg = Color3.fromRGB(255, 255, 0),
    CollapsingHeaderBg = Color3.fromRGB(150, 150, 0),
    CollapsingHeaderText = Color3.fromRGB(255, 255, 255),
    RadioButtonHoveredBg = Color3.fromRGB(150, 150, 0),

    WindowBg = Color3.fromRGB(35, 35, 45),
    TitleBarBg = Color3.fromRGB(35, 35, 45),
    TitleBarBgActive = Color3.fromRGB(50, 50, 60),

    Border = Color3.fromRGB(80, 80, 90),
    ResizeGrab = Color3.fromRGB(80, 80, 90),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Sandy", {TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(150, 130, 100),
    Text = Color3.fromRGB(60, 40, 20),

    FrameBg = Color3.fromRGB(240, 230, 200),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(210, 200, 170),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(100, 60, 30),
    SliderGrab = Color3.fromRGB(120, 80, 50),
    ButtonsBg = Color3.fromRGB(100, 60, 30),
    CollapsingHeaderBg = Color3.fromRGB(210, 200, 170),
    CollapsingHeaderText = Color3.fromRGB(60, 40, 20),
    RadioButtonHoveredBg = Color3.fromRGB(210, 200, 170),

    WindowBg = Color3.fromRGB(255, 245, 220),
    TitleBarBg = Color3.fromRGB(220, 210, 180),
    TitleBarBgActive = Color3.fromRGB(190, 180, 150),

    Border = Color3.fromRGB(120, 100, 80),
    ResizeGrab = Color3.fromRGB(120, 100, 80),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Cyber", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(120, 160, 160),
    Text = Color3.fromRGB(200, 240, 255),

    FrameBg = Color3.fromRGB(10, 25, 25),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(0, 100, 100),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(0, 255, 100),  -- Acid Green
    SliderGrab = Color3.fromRGB(0, 200, 200),
    ButtonsBg = Color3.fromRGB(0, 255, 100),
    CollapsingHeaderBg = Color3.fromRGB(0, 100, 100),
    CollapsingHeaderText = Color3.fromRGB(200, 240, 255),
    RadioButtonHoveredBg = Color3.fromRGB(0, 100, 100),

    WindowBg = Color3.fromRGB(15, 45, 45),
    TitleBarBg = Color3.fromRGB(15, 45, 45),
    TitleBarBgActive = Color3.fromRGB(30, 70, 70),

    Border = Color3.fromRGB(50, 90, 90),
    ResizeGrab = Color3.fromRGB(50, 90, 90),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("RobloxTheme", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(115, 115, 115),
    Text = Color3.fromRGB(250, 250, 250),

    FrameBg = Color3.fromRGB(40, 40, 45),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(70, 70, 75),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(0, 120, 250),
    SliderGrab = Color3.fromRGB(0, 120, 250),
    ButtonsBg = Color3.fromRGB(0, 120, 250),
    CollapsingHeaderBg = Color3.fromRGB(70, 70, 75),
    CollapsingHeaderText = Color3.fromRGB(250, 250, 250),
    RadioButtonHoveredBg = Color3.fromRGB(70, 70, 75),

    WindowBg = Color3.fromRGB(55, 55, 60),
    TitleBarBg = Color3.fromRGB(55, 55, 60),
    TitleBarBgActive = Color3.fromRGB(80, 80, 85),

    Border = Color3.fromRGB(95, 95, 100),
    ResizeGrab = Color3.fromRGB(95, 95, 100),
    RegionBgTransparency = 1,
})

ReGui:DefineTheme("Retrosomethingsomething", {
    TitleAlign = Enum.TextXAlignment.Center,
    TextDisabled = Color3.fromRGB(180, 160, 140),
    Text = Color3.fromRGB(255, 230, 200),

    FrameBg = Color3.fromRGB(35, 25, 20),
    FrameBgTransparency = 0.4,
    FrameBgActive = Color3.fromRGB(90, 60, 120),
    FrameBgTransparencyActive = 0.4,

    CheckMark = Color3.fromRGB(160, 90, 200),  -- Deep Violet
    SliderGrab = Color3.fromRGB(160, 90, 200),
    ButtonsBg = Color3.fromRGB(160, 90, 200),
    CollapsingHeaderBg = Color3.fromRGB(90, 60, 120),
    CollapsingHeaderText = Color3.fromRGB(255, 230, 200),
    RadioButtonHoveredBg = Color3.fromRGB(90, 60, 120),

    WindowBg = Color3.fromRGB(50, 40, 30),
    TitleBarBg = Color3.fromRGB(50, 40, 30),
    TitleBarBgActive = Color3.fromRGB(75, 60, 45),

    Border = Color3.fromRGB(100, 80, 60),
    ResizeGrab = Color3.fromRGB(100, 80, 60),
    RegionBgTransparency = 1,
})
