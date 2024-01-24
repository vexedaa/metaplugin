--------------------------------------- DETAILS ---------------------------------------
--@desc: A convenient springboard for plugin development.
---------------------------------------------------------------------------------------

--------------------------------------- SERVICES --------------------------------------
local ChangeHistoryService = game:GetService("ChangeHistoryService")
---------------------------------------------------------------------------------------

--------------------------------------- DEPENDENCIES ----------------------------------
local Packages = script.Parent.Packages
local Signal = require(Packages.Signal)
local ToolbarConfig = require(script.Parent.Toolbar)
local Config = require(script.Parent.Config)
---------------------------------------------------------------------------------------

--------------------------------------- VARIABLES -------------------------------------
local plugin = nil
local Widgets = script.Parent.Widgets
---------------------------------------------------------------------------------------


local meta2 = {}

meta2.Widgets = {}
meta2.Buttons = {}

meta2.Toolbar = nil

--[=[
    @desc: Returns your Roblox Studio theme details. Your plugins can use this to change their UI to match the user's theme.
    @return (table) theme
]=]
function meta2:GetStudioThemeDetails(): StudioTheme
    local theme = settings().Studio.Theme
    return theme
end

function meta2:CreateToolbar(name: string): PluginToolbar
    if self.Toolbar and self.Toolbar.Name == name then
        return self.Toolbar
    end

    local toolbar = plugin:CreateToolbar(name)
    self.Toolbar = toolbar
    return toolbar
end

function meta2:CreateWidget(name: string, initialDockState: Enum.InitialDockState, initialEnabled: boolean, initialEnabledShouldOverrideRestore: boolean, floatingXsize: number, floatingYsize: number, minWidth: number, minHeight: number): DockWidgetPluginGui
    local widget = self.Widgets[name]
    if widget then
        return widget
    end


    local info = DockWidgetPluginGuiInfo.new(
        initialDockState,
        initialEnabled,
        initialEnabledShouldOverrideRestore,
        floatingXsize,
        floatingYsize,
        minWidth,
        minHeight
    )

    widget = plugin:CreateDockWidgetPluginGui(name, info)
    widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    widget.Name = name

    self.Widgets[name] = widget

    local getWidgetGui = Widgets:FindFirstChild(name)
    if getWidgetGui then
        getWidgetGui.Parent = widget
    end
    return widget, getWidgetGui
end

function meta2:GetWidget(name: string): DockWidgetPluginGui
    return self.Widgets[name]
end

function meta2:CreateButton(name: string, tooltip: string, icon: string): PluginToolbarButton
    local button = self.Toolbar:CreateButton(name, tooltip, icon)
    self.Buttons[name] = button
    return button
end

function meta2:GetButton(name: string): PluginToolbarButton
    return self.Buttons[name]
end

function meta2:ToggleButton(button: PluginToolbarButton, state: boolean)
    if state then
        button:SetActive(true)
    else
        button:SetActive(false)
    end
end

function meta2:Init(pluginRef: Plugin)
    plugin = pluginRef
    self:CreateToolbar(Config.Name)
    for _, entry in pairs(ToolbarConfig) do
        local class = entry.class
        if class == "PluginToolbarButton" then

            local button = self:CreateButton(entry.name, entry.tooltip, entry.icon)
            if entry.opensWidget then
                button.Click:Connect(function()
                    local widget = self:GetWidget(entry.widgetName)
                    widget.Enabled = not widget.Enabled
                    self:ToggleButton(button, widget.Enabled)
                end)
            end
        elseif class == "DockWidgetPluginGui" then
            local _, getWidgetGui = self:CreateWidget(entry.name, entry.initialDockState, entry.initialEnabled, entry.initialEnabledShouldOverrideRestore, entry.floatingXsize, entry.floatingYsize, entry.minWidth, entry.minHeight)
            if getWidgetGui then
                getWidgetGui.Enabled = entry.initialEnabled
            end
        end
    end
end

return meta2