local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

-- Global setup
bb.ui = {}
bb.ui.window = {}

--if BadBoy_data.options[GetSpecialization()] == nil then BadBoy_data.options[GetSpecialization()] = {} end
--if BadBoy_data.options[GetSpecialization()][bb.selectedProfile] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile] = {} end

-- TODO: save window position and restore it

--[[ FROM PE ]]--

DiesalGUI:RegisterObjectConstructor("FontString", function()
    local self      = DiesalGUI:CreateObjectBase(Type)
    local frame     = CreateFrame('Frame',nil,UIParent)
    local fontString = frame:CreateFontString(nil, "OVERLAY", 'DiesalFontNormal')
    self.frame      = frame
    self.fontString = fontString
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self.fontString:SetText('')
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "FontString"
    return self
end, 1)

DiesalGUI:RegisterObjectConstructor("Rule", function()
    local self      = DiesalGUI:CreateObjectBase(Type)
    local frame     = CreateFrame('Frame',nil,UIParent)
    self.frame      = frame
    frame:SetHeight(1)
    frame.texture = frame:CreateTexture()
    frame.texture:SetTexture(0,0,0,0.5)
    frame.texture:SetAllPoints(frame)
    self.SetParent = function(self, parent)
        self.frame:SetParent(parent)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)

local statusBarStylesheet = {
    ['frame-texture'] = {
        type        = 'texture',
        layer       = 'BORDER',
        gradient    = 'VERTICAL',
        color       = '000000',
        alpha       = 0.7,
        alphaEnd    = 0.1,
        offset      = 0,
    }
}

DiesalGUI:RegisterObjectConstructor("StatusBar", function()
    local self  = DiesalGUI:CreateObjectBase(Type)
    local frame = CreateFrame('StatusBar',nil,UIParent)
    self.frame  = frame

    self:AddStyleSheet(statusBarStylesheet)

    frame.Left = frame:CreateFontString()
    frame.Left:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Left:SetShadowColor(0,0,0, 0)
    frame.Left:SetShadowOffset(-1,-1)
    frame.Left:SetPoint("LEFT", frame)

    frame.Right = frame:CreateFontString()
    frame.Right:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    frame.Right:SetShadowColor(0,0,0, 0)
    frame.Right:SetShadowOffset(-1,-1)

    frame:SetStatusBarTexture(1,1,1,0.8)
    frame:GetStatusBarTexture():SetHorizTile(false)
    frame:SetMinMaxValues(0, 100)
    frame:SetHeight(15)

    self.SetValue = function(self, value)
        self.frame:SetValue(value)
    end
    self.SetParent = function(self, parent)
        self.parent = parent
        self.frame:SetParent(parent)
        self.frame:SetPoint("LEFT", parent, "LEFT")
        self.frame:SetPoint("RIGHT", parent, "RIGHT")
        self.frame.Right:SetPoint("RIGHT", self.frame, "RIGHT", -2, 2)
        self.frame.Left:SetPoint("LEFT", self.frame, "LEFT", 2, 2)
    end
    self.OnRelease = function(self)
        self:Hide()
    end
    self.OnAcquire = function(self)
        self:Show()
    end
    self.type = "Rule"
    return self
end, 1)


--[[ ]]--



local buttonStyleSheet = {
    ['frame-color'] = {
        type			= 'texture',
        layer			= 'BACKGROUND',
        color			= '2f353b',
        offset		= 0,
    },
    ['frame-highlight'] = {
        type			= 'texture',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'FFFFFF',
        alpha 		= 0,
        alphaEnd	= .1,
        offset		= -1,
    },
    ['frame-outline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        color			= '000000',
        offset		= 0,
    },
    ['frame-inline'] = {
        type			= 'outline',
        layer			= 'BORDER',
        gradient	= 'VERTICAL',
        color			= 'ffffff',
        alpha 		= .02,
        alphaEnd	= .09,
        offset		= -1,
    },
    ['frame-hover'] = {
        type			= 'texture',
        layer			= 'HIGHLIGHT',
        color			= 'ffffff',
        alpha			= .1,
        offset		= 0,
    },
    ['text-color'] = {
        type			= 'Font',
        color			= 'b8c2cc',
    },
}

function bb.ui:createWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 250
    window.settings.height = height or 250
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    local scrollFrame = DiesalGUI:Create('ScrollFrame')
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    -- Load saved position
    if BadBoy_data.options[GetSpecialization()]["optionsFrame".."_point"] ~= nil then
        local point, relativeTo = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_point"], BadBoy_data.options[GetSpecialization()]["optionsFrame".."_relativeTo"]
        local relativePoint = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_relativePoint"]
        local xOfs, yOfs = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_xOfs"], BadBoy_data.options[GetSpecialization()]["optionsFrame".."_yOfs"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if BadBoy_data.options[GetSpecialization()]["optionsFrame".."_point2"] ~= nil then
        local point, relativeTo = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_point2"], BadBoy_data.options[GetSpecialization()]["optionsFrame".."_relativeTo2"]
        local relativePoint = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_relativePoint2"]
        local xOfs, yOfs = BadBoy_data.options[GetSpecialization()]["optionsFrame".."_xOfs2"], BadBoy_data.options[GetSpecialization()]["optionsFrame".."_yOfs2"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if BadBoy_data.options[GetSpecialization()]["optionsFrame".."_width"] and BadBoy_data.options[GetSpecialization()]["optionsFrame".."_height"] then
        scrollFrame.parent:SetWidth(BadBoy_data.options[GetSpecialization()]["optionsFrame".."_width"])
        scrollFrame.parent:SetHeight(BadBoy_data.options[GetSpecialization()]["optionsFrame".."_height"])
    end

    return scrollFrame
end

function bb.ui:createProfileWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    local scrollFrame = DiesalGUI:Create('ScrollFrame')
    window:AddChild(scrollFrame)
    scrollFrame:SetParent(window.content)
    scrollFrame:SetAllPoints(window.content)
    scrollFrame.parent = window

    -- Load saved position
    if BadBoy_data.options[GetSpecialization()]["configFrame".."_point"] ~= nil then
        local point, relativeTo = BadBoy_data.options[GetSpecialization()]["configFrame".."_point"], BadBoy_data.options[GetSpecialization()]["configFrame".."_relativeTo"]
        local relativePoint = BadBoy_data.options[GetSpecialization()]["configFrame".."_relativePoint"]
        local xOfs, yOfs = BadBoy_data.options[GetSpecialization()]["configFrame".."_xOfs"], BadBoy_data.options[GetSpecialization()]["configFrame".."_yOfs"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if BadBoy_data.options[GetSpecialization()]["configFrame".."_point2"] ~= nil then
        local point, relativeTo = BadBoy_data.options[GetSpecialization()]["configFrame".."_point2"], BadBoy_data.options[GetSpecialization()]["configFrame".."_relativeTo2"]
        local relativePoint = BadBoy_data.options[GetSpecialization()]["configFrame".."_relativePoint2"]
        local xOfs, yOfs = BadBoy_data.options[GetSpecialization()]["configFrame".."_xOfs2"], BadBoy_data.options[GetSpecialization()]["configFrame".."_yOfs2"]
        scrollFrame.parent:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
    end
    if BadBoy_data.options[GetSpecialization()]["configFrame".."_width"] and BadBoy_data.options[GetSpecialization()]["configFrame".."_height"] then
        scrollFrame.parent:SetWidth(BadBoy_data.options[GetSpecialization()]["configFrame".."_width"])
        scrollFrame.parent:SetHeight(BadBoy_data.options[GetSpecialization()]["configFrame".."_height"])
    end

    return scrollFrame
end

function bb.ui:createMessageWindow(name, width, height)
    local window = DiesalGUI:Create('Window')
    window:SetTitle('BadBoy', name)
    window.settings.width = width or 300
    window.settings.height = height or 250
    window.frame:SetClampedToScreen(true)
    window:ApplySettings()

    local newMessageFrame = DiesalGUI:Create('ScrollingMessageFrameBB')
    window:AddChild(newMessageFrame)
    newMessageFrame:SetParent(window.content)
    newMessageFrame:SetAllPoints(window.content)
    newMessageFrame.parent = window

    return newMessageFrame
end

bb.spacing = 15

function bb.ui:createCheckbox(parent, text, tooltip)
    local newBox = DiesalGUI:Create('Toggle')
    local parent = parent
    local anchor = anchor or "TOPLEFT"

    -- Set text
    newBox:SetText(text)

    -- Change size
    --newBox.settings.height = 12
    --newBox.settings.width = 12

    -- Calculate Position
    local howManyBoxes = 1
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end

    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -bb.spacing) -5 end
    if y == 1 then y = -5 end

    -- Set parent
    newBox:SetParent(parent.content)

    -- Set anchor
    newBox:SetPoint("TOPLEFT", parent.content, anchor, 10, y)

    -- Read check value from config, false if nothing found
    -- Set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] = false end
    local check = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"]
    if check == 0 then check = false end
    if check == 1 then check = true end


    newBox:SetChecked(check)

    -- Event: OnValueChanged
    newBox:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Check"] = checked

        -- Create Chat Overlay
        if checked then
            ChatOverlay("|cff15FF00"..text.." Enabled")
        else
            ChatOverlay("|cFFED0000"..text.." Disabled")
        end
    end)
    -- Event: Tooltip
    if tooltip then
        newBox:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newBox:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    -- Apply changed settings like size, position, etc
    newBox:ApplySettings()

    -- Add as a child element to parent
    parent:AddChild(newBox)

    return newBox
end

function bb.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, hideCheckbox)
    local newSpinner = DiesalGUI:Create('Spinner')
    local parent = parent

    -- Create Checkbox for Spinner
    local checkBox = bb.ui:createCheckbox(parent, text, tooltip)

    -- Calculate position
    local howManyBoxes = 0
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end
    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -bb.spacing) -5 end
    if y == 1 then y = -5 end

    if hideCheckbox then
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end

    -- Set size
    newSpinner.settings.height = 12

    -- Set Steps
    newSpinner.settings.min = min or 0
    newSpinner.settings.max = max or 100
    newSpinner.settings.step = step or 5

    newSpinner:SetParent(parent.content)

    -- Set anchor
    newSpinner:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, y)

    -- Read number from config or set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] = number end
    local state = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"]
    newSpinner:SetNumber(state)


    -- Event: OnValueChange
    newSpinner:SetEventListener('OnValueChanged', function(this, event, checked)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Status"] = newSpinner:GetNumber()
    end)
    -- Event: Tooltip
    if tooltip or tooltipSpin then
        local tooltip = tooltipSpin or tooltip
        newSpinner:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newSpinner:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    newSpinner:ApplySettings()

    parent:AddChild(newSpinner)

    return newSpinner
end

function bb.ui:createSpinnerWithout(parent, text, number, min, max, step, tooltip, tooltipSpin)
    return bb.ui:createSpinner(parent, text, number, min, max, step, tooltip, tooltipSpin, true)
end

function bb.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, hideCheckbox)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local itemlist = itemlist
    local default = default or 1

    -- Create Checkbox for Dropdown
    local checkBox = bb.ui:createCheckbox(parent,text,tooltip)

    -- Calculate position
    local howManyBoxes = 0
    for i=1, #parent.children do
        if parent.children[i].type == "Toggle" then
            howManyBoxes = howManyBoxes + 1
        end
    end
    local y = howManyBoxes
    if y  ~= 1 then y = ((y-1) * -bb.spacing) -5 end
    if y == 1 then y = -5 end

    if hideCheckbox then
        checkBox:Disable()
        checkBox:ReleaseTextures()
    end

    --newDropdown.settings.text = text
    newDropdown.settings.height = 12
    newDropdown:SetParent(parent.content)
    newDropdown:SetPoint("TOPRIGHT", parent.content, "TOPRIGHT", -10, y)

    -- Create the Dropdown List
    newDropdown:SetList(itemlist)

    -- Read from config or set default
    if BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"] = default end
    local value = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"]
    newDropdown:SetValue(value)

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][bb.selectedProfile][text.."Drop"]  = key
    end)
    -- Event: Tooltip
    if tooltip or tooltipDrop then
        local tooltip = tooltipDrop or tooltip
        newDropdown:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newDropdown:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

function bb.ui:createDropdownWithout(parent, text, itemlist, default, tooltip, tooltipDrop)
    return bb.ui:createDropdown(parent, text, itemlist, default, tooltip, tooltipDrop, true)
end

function bb.ui:createRotationDropdown(parent, itemlist, tooltip)
    local newDropdown = DiesalGUI:Create('DropdownBB')
    local parent = parent
    local text = "Rotation"

    newDropdown:SetParent(parent.titleBar)
    newDropdown:SetPoint("TOPRIGHT", parent.closeButton, "TOPLEFT", 0, -2)

    newDropdown:SetList(itemlist)

    if BadBoy_data.options[GetSpecialization()][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][text.."Drop"] = 1 end
    local value = BadBoy_data.options[GetSpecialization()][text.."Drop"]
    newDropdown:SetValue(value)
    if BadBoy_data.options[GetSpecialization()][text.."Drop"] == nil then BadBoy_data.options[GetSpecialization()][text.."Drop"] = value end

    newDropdown:SetEventListener('OnValueChanged', function(this, event, key, value, selection)
        BadBoy_data.options[GetSpecialization()][text.."Drop"]  = key
        BadBoy_data.options[GetSpecialization()][text.."DropValue"]  = value
        bb.selectedProfile = key
        bb.ui:recreateWindows()
        bb.rotation_changed = true
    end)
    -- Event: Tooltip
    if tooltip then
        newDropdown:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newDropdown:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end
    newDropdown:ApplySettings()

    parent:AddChild(newDropdown)

    return newDropdown
end

function bb.ui:createSection(parent, sectionName, tooltip)
    local newSection = DiesalGUI:Create('AccordianSectionBB')
    local parent = parent

    -- Calculate Position
    local howManySections = 1
    for i=1, #parent.children do
        if parent.children[i].type == "AccordianSectionBB" then
            howManySections = howManySections + 1
        end
    end

    local position = howManySections

    newSection:SetParentObject(parent)
    newSection.settings.position = position
    newSection.settings.sectionName = sectionName
    newSection.settings.expanded = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][sectionName.."Section"]
    --newSection.settings.contentPad = {0,0,12,32}

    newSection:SetEventListener('OnStateChange', function(this, event)
       BadBoy_data.options[GetSpecialization()][bb.selectedProfile][sectionName.."Section"] = newSection.settings.expanded
    end)
    -- Event: Tooltip
    if tooltip then
        newSection:SetEventListener("OnEnter", function(this, event)
            GameTooltip:SetOwner(Minimap, "ANCHOR_CURSOR", 50 , 50)
            GameTooltip:SetText(tooltip, 214/255, 25/255, 25/255)
            GameTooltip:Show()
        end)
        newSection:SetEventListener("OnLeave", function(this, event)
            GameTooltip:Hide()
        end)
    end

    newSection:ApplySettings()
    newSection:UpdateHeight()

    parent:AddChild(newSection)

    return newSection
end

function createNewText(parent, text)
    local newText = DiesalGUI:Create("FontString")
    local offset = -2
    local anchor = parent.content

    -- Calculate Position
    local howManyTexts = 1
    for i=1, #parent.children do
        if parent.children[i].type == "FontString" then
            anchor = parent.children[i]
        end
    end

    local y = howManyTexts
    if y  ~= 1 then y = ((y-1) * -bb.spacing) -5 end
    if y == 1 then y = -5 end

    newText:SetParent(parent.content)
    parent:AddChild(newText)
    newText = newText.fontString


    newText:SetPoint("TOPLEFT", anchor.content, "TOPLEFT", 5, offset)
    newText:SetPoint("TOPRIGHT", anchor.content, "TOPRIGHT", -5, offset)

    newText:SetText(text)
    newText:SetJustifyH('LEFT')
    newText:SetJustifyV('TOP')
    newText:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
    newText:SetWidth(parent.content:GetWidth()-10)
    newText:SetWordWrap(true)

    return newText
end


-- Restore last saved state of section (collapsed or expanded)
function bb.ui:checkSectionState(section)
    local state = BadBoy_data.options[GetSpecialization()][bb.selectedProfile][section.settings.sectionName.."Section"]

    if state then
        section:Expand()
    else
        section:Collapse()
    end
end

function bb.ui:createButton(parent, buttonName, x, y)
    local newButton = DiesalGUI:Create('Button')
    local parent = parent

    parent:AddChild(newButton)
    newButton:SetParent(parent.content)
    newButton:AddStyleSheet(buttonStyleSheet)
    newButton:SetPoint("TOPLEFT", parent.content, "TOPLEFT", x, y)
    newButton:SetText(buttonName)
    newButton:SetWidth(100)
    newButton:SetHeight(20)
    --newBox:SetEventListener("OnClick", function()
    --
    --end)

    parent:AddChild(newButton)

    return newButton
end

-- Checks if profile button was shown or closed on last logout and restores it
-- TODO: BUG atm as it only saves state when uses via minimap icon, doesnt save if window is closed by clickin on X
-- TODO: BUG on / off toggle doesnt behave correctly
function bb:checkProfileWindowStatus()
    if BadBoy_data.options[GetSpecialization()]["configFrame"] ~= true then
        if bb.ui.window.profile then
            bb.ui.window.profile.parent:Show()
            return true
        end
    else
        if bb.ui.window.profile then
            bb.ui.window.profile.parent.closeButton:Click()
            return false
        end
    end
end

function bb:checkConfigWindowStatus()
    if BadBoy_data.options[GetSpecialization()] then
        if BadBoy_data.options[GetSpecialization()]["optionsFrame"] then
            if bb.ui.window.config then
                bb.ui.window.config.parent.closeButton:Click()
                --optionsFrame:Hide()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = false
            end
        else
            if bb.ui.window.config then
                bb.ui.window.config.parent:Show()
                --optionsFrame:Show()
                BadBoy_data.options[GetSpecialization()]["optionsFrame"] = true
            end
        end
    end
end

function bb.ui:recreateWindows()
    bb.ui.window.config.parent.closeButton:Click()
    bb.ui.window.profile.parent.closeButton:Click()

    bb.ui:createConfigWindow()
end

-- todo
function bb.ui:createOverviewWindow()
    bb.ui.window.overview = bb.ui:createWindow("Overview")

    -- Open ABOUT window
    local buttonAbout = bb.ui:createButton(bb.ui.window.overview, "About", 10, -10)
    buttonAbout:SetEventListener("OnClick", function()
        bb.ui.window.about.parent:Show()
    end)
end

-- todo
function bb.ui:createAboutWindow()
    bb.ui.window.about = bb.ui:createWindow("About")


end

function bb.ui:createHelpWindow()
    bb.ui.window.help = bb.ui:createMessageWindow("Help")
    local colorBlue = "|cff00CCFF"
    local colorGreen = "|cff00FF00"
    local colorRed = "|cffFF0011"
    local colorWhite = "|cffFFFFFF"
    local colorGold = "|cffFFDD11"
    bb.ui.window.help:AddMessage(colorGreen.."--- [[ AUTHORS ]] ---")
    bb.ui.window.help:AddMessage(colorRed.."CodeMyLife - CuteOne - Ragnar - Defmaster")
    bb.ui.window.help:AddMessage(colorRed.."Gabbz - Chumii - AveryKey")
    bb.ui.window.help:AddMessage(colorRed.."Masoud - Cpoworks - Tocsin")
    bb.ui.window.help:AddMessage(colorRed.."Mavmins - CukieMunster - Magnu")
    bb.ui.window.help:AddMessage("----------------------------------------")
    --
    bb.ui.window.help:AddMessage(colorGreen.."--- [[ TODO ]] ---")
    bb.ui.window.help:AddMessage(colorGold.."HELP WINDOW NOT FINISHED YET ! ")
    bb.ui.window.help.parent:Hide()
end


-- This creates the normal BadBay Configuration Window
function bb.ui:createConfigWindow()
    bb.ui:createHelpWindow()
    bb.ui.window.config = bb.ui:createWindow("Configuration", 275, 400)

    local section
    -- General
    section = bb.ui:createSection(bb.ui.window.config, "General")
    bb.ui:createCheckbox(section, "Start/Stop BadBoy", "Uncheck to prevent BadBoy pulsing.")
    bb.ui:createCheckbox(section, "Debug Frame", "Display Debug Frame.")
    bb.ui:createCheckbox(section, "Display Failcasts", "Dispaly Failcasts in Debug.")
    bb.ui:createCheckbox(section, "Queue Casting", "Allow Queue Casting on some profiles.")
    bb.ui:createSpinner(section,  "Auto Loot" ,0.5, 0.1, 3, 0.1, "Sets Autloot on/off.", "Sets a delay for Auto Loot.")
    bb.ui:createCheckbox(section, "Auto-Sell/Repair", "Automatically sells grays and repais when you open a repairman trade.")
    bb.ui:createCheckbox(section, "Accept Queues", "Automatically accept LFD, LFR, .. queue.")
    bb.ui:createCheckbox(section, "Overlay Messages", "Check to enable chat overlay messages.")
    bb.ui:checkSectionState(section)

    -- Enemies Engine
    section = bb.ui:createSection(bb.ui.window.config, "Enemies Engine")
    bb.ui:createCheckbox(section, "Dynamic Targetting", "Check this to allow dynamic targetting. If unchecked, profile will only attack current target.")
    bb.ui:createDropdown(section, "Wise Target", {"Highest", "Lowest", "abs Highest"}, 1, "|cffFFDD11Check if you want to use Wise Targetting, if unchecked there will be no priorisation from hp.")
    bb.ui:createCheckbox(section, "Forced Burn", "Check to allow forced Burn on specific whitelisted units.")
    bb.ui:createCheckbox(section, "Avoid Shields", "Check to avoid attacking shielded units.")
    bb.ui:createCheckbox(section, "Tank Threat", "Check add more priority to taregts you lost aggro on(tank only).")
    bb.ui:createCheckbox(section, "Safe Damage Check", "Check to prevent damage to targets you dont want to attack.")
    bb.ui:createCheckbox(section, "Don't break CCs", "Check to prevent damage to targets that are CC.")
    bb.ui:createCheckbox(section, "Skull First", "Check to enable focus skull dynamically.")
    bb.ui:createDropdown(section, "Interrupts Handler", {"Target", "T/M", "T/M/F", "All"}, 1, "Check this to allow Interrupts Handler. DO NOT USE YET!")
    bb.ui:createCheckbox(section, "Only Known Units", "Check this to interrupt only on known units using whitelist.")
    bb.ui:createCheckbox(section, "Crowd Control", "Check to use crowd controls on select units/buffs.")
    bb.ui:createCheckbox(section, "Enrages Handler", "Check this to allow Enrages Handler.")
    bb.ui:checkSectionState(section)

    -- Healing Engine
    section = bb.ui:createSection(bb.ui.window.config, "Healing Engine")
    bb.ui:createCheckbox(section, "HE Active", "Uncheck to disable Healing Engine.\nCan improves FPS if you dont rely on Healing Engine.")
    bb.ui:createCheckbox(section, "Heal Pets", "Check this to Heal Pets.")
    bb.ui:createDropdown(section, "Special Heal", {"Target", "T/M", "T/M/F", "T/F"}, 1, "Check this to Heal Special Whitelisted Units.", "Choose who you want to Heal.")
    bb.ui:createCheckbox(section, "Sorting with Role", "Sorting with Role")
    bb.ui:createDropdown(section, "Prioritize Special Targets", {"Special", "All"}, 1, "Prioritize Special targets(mouseover/target/focus).", "Choose Which Special Units to consider.")
    bb.ui:createSpinner(section, "Blacklist", 95, nil, nil, nil, "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list.")
    bb.ui:createCheckbox(section, "Ignore Absorbs", "Check this if you want to ignore absorb shields. If checked, it will add shieldBuffValue/4 to hp. May end up as overheals, disable to save mana.")
    bb.ui:createCheckbox(section, "Incoming Heals", "If checked, it will add incoming health from other healers to hp. Uncheck this if you want to prevent overhealing units.")
    bb.ui:createSpinner(section, "Overhealing Cancel", 95, nil, nil, nil, "Set Desired Threshold at which you want to prevent your own casts.")
    bb.ui:createCheckbox(section, "Healing Debug", "Check to display Healing Engine Debug.")
    bb.ui:createSpinner(section, "Debug Refresh", 500, 0, 1000, 25, "Set desired Healing Engine Debug Table refresh for rate in ms.")
    bb.ui:createSpinner(section, "Dispel delay", 15, 5, 90, 5, "Set desired dispel delay in % of debuff duration.\n|cffFF0000Will randomise around the value you set.")
    bb.ui:checkSectionState(section)

    -- Other Features
    section = bb.ui:createSection(bb.ui.window.config, "Other Features")
    bb.ui:createSpinner(section, "Profession Helper", 0.5, 0, 1, 0.1, "Check to enable Professions Helper.", "Set Desired Recast Delay.")
    bb.ui:createDropdown(section, "Prospect Ores", {"WoD", "MoP", "Cata", "All"}, 1, "Prospect Desired Ores.")
    bb.ui:createDropdown(section, "Mill Herbs", {"WoD", "MoP", "Cata", "All"}, 1, "Mill Desired Herbs.")
    bb.ui:createCheckbox(section, "Disenchant", "Disenchant Cata blues/greens.")
    bb.ui:createCheckbox(section, "Leather Scraps", "Combine leather scraps.")
    bb.ui:createSpinner(section, "Salvage", 15, 5, 30, 1, "Check to enable Salvage Helper.", "Set Desired waiting after full inventory.")
    bb.ui:createCheckbox(section, "Automatic Gathering", "Automatic gathering of things like herbs,mining nodes, quest items, ...")
    bb.ui:createCheckbox(section, "Use Drawer", "EXPERIMENTAL!")
    bb.ui:checkSectionState(section)

    -- temp
    if BadBoy_data.options[GetSpecialization()] and BadBoy_data.options[GetSpecialization()]["optionsFrame"] ~= true then
        bb.ui.window.config.parent.closeButton:Click()
    end
end

-- TODO: create new debug frame
function bb.ui:createDebugWindow()

end

-- TODO: re arrange files, put function and window into different files
-- TODO: use bb.ui.window.window.config ... instead of bb.config ...