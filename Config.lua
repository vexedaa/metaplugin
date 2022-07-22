local Config = {}

Config.PluginName = "MetaPlugin"
Config.SyncToTheme = true

--[[ BUTTON PARAMETERS

Under Config.Buttons, insert a table using this format:

ButtonIdentifier = {
		Name = "Button Name";
		Tooltip = "Button Tooltip";
		Icon = "[insert asset ID]";
		BindToWidget = "Enter widget name or do not include";
		BindToScreenGui = "Enter ScreenGUI name or do not include";
};

The button's index in the table serves as its identifier so you can access it from your plugin scripts.

]]--

Config.Buttons = {
	
}

--[[ WIDGET PARAMETERS

Under Config.Widgets, insert a table using this format:

{
		InitialDockState = Enum.InitialDockState.Float;
		InitiallyEnabled = false;
		OverridePreviousState = false;
		DefaultWidth = 800;
		DefaultHeight = 400;
		MinWidth = 400;
		MinHeight = 400
};

The widget's index in the table serves as its unique identifier so you can access it from your plugin scripts and match its name with a button's "BindToWidget"

]]--

Config.Widgets = {
	
}

return Config
