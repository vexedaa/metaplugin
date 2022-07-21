local plugin = nil --ModuleScripts don't have access to the `plugin` global. It must be provided by a script that initializes MetaPlugin.

local Meta = {}

--ROBLOX SERVICES
Meta.ChangeHistoryService = game:GetService("ChangeHistoryService")

Meta.Config = require(script:WaitForChild("Config"))
Meta.TopAncestor = script.Parent

local Packages = script:WaitForChild("Modules")

Meta.Packages = {
	Event = require(Packages:WaitForChild("Event"));
	TagService = require(Packages:WaitForChild("TagService"));
}

Meta.GUI_FOLDER = script.Storage:WaitForChild("GUI")
Meta.WIDGET_FOLDER = Meta.GUI_FOLDER:WaitForChild("Widget")
Meta.SCREEN_FOLDER = Meta.GUI_FOLDER:WaitForChild("Screen")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
Meta.Initialized = Signal.new()

Meta.Buttons = {}
Meta.Widgets = {}

Meta.SyncToTheme = function()
	local objectsToSync = Meta.Packages.TagService.GetTagged("SyncToTheme")
	for i, object in pairs(objectsToSync) do
		local success, result = pcall(function()
			object.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
		end)
		local success, result = pcall(function()
			object.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		end)
		local success, result = pcall(function()
			if object:IsA("UIStroke") then
				object.Color = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Shadow)
			end
		end)
	end
end

Meta.AddButton = function(name, tooltip, icon)
	local button = Meta.Toolbar:CreateButton(name, tooltip, icon)
	local metaButton = {Button = button; Active = false; OnActivation = Signal.new()}
	Meta.Buttons[name] = metaButton
	return metaButton
end

Meta.ToggleActive = function(button, active)
	button.Active = active
	button.Button:SetActive(active)
	button.OnActivation:Fire(active)
end

Meta.Initialize = function(pluginGlobal)
	plugin = pluginGlobal
	Meta.Toolbar = plugin:CreateToolbar(Meta.Config.PluginName)
	
	for name, widgetConfig in pairs(Meta.Config.Widgets) do
		local widget = plugin:CreateDockWidgetPluginGui(
			Meta.Config.PluginName.."-"..name,
			DockWidgetPluginGuiInfo.new(
				widgetConfig.InitialDockState,
				widgetConfig.InitiallyEnabled,
				widgetConfig.OverridePreviousState,
				widgetConfig.DefaultWidth,
				widgetConfig.DefaultHeight,
				widgetConfig.MinWidth,
				widgetConfig.MinHeight
			)
		)
		local widgetGUI = Meta.WIDGET_FOLDER:FindFirstChild(name)
		if widgetGUI then
			for i, element in pairs(widgetGUI:GetChildren()) do
				element.Parent = widget
			end
		end
		widget.Title = name
		Meta.Widgets[name] = widget
	end
	
	for buttonName, buttonConfig in pairs(Meta.Config.Buttons) do
		local metaButton = Meta.AddButton(buttonName, buttonConfig.Tooltip, buttonConfig.Icon, buttonConfig.Name)
		local bindToWidget = buttonConfig.BindToWidget
		local getWidget = Meta.Widgets[bindToWidget]
		metaButton.Button.Click:Connect(function()
			Meta.ToggleActive(metaButton, not metaButton.Active)
			if bindToWidget ~= nil then
				if getWidget ~= nil then
					getWidget.Enabled = metaButton.Active
					getWidget:BindToClose(function()
						getWidget.Enabled = false
						Meta.ToggleActive(metaButton, false)
					end)
				end
			end
		end)
	end
	if Meta.Config.SyncToTheme == true then
		Meta.SyncToTheme()
		settings().Studio.ThemeChanged:Connect(Meta.SyncToTheme)
	end
	Meta.Initialized:Fire()
end

return Meta
