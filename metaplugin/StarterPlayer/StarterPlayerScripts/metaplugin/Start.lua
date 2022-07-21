--[[
	Welcome to MetaPlugin, a lightweighht springboard to make Roblox plugin development easier.
	Please note that this is a heavy work-in-progress, usage patterns and features WILL change.

	Do not use MetaPlugin without understanging and accepting the risk that instabilities will occur, and future updates
	may render previous work made with MetaPlugin incompatible with newer versions.

	MetaPlugin is provided as a Wally package for convenience only.
	To start developing your own plugins with this tool, please *copy* the "metaplugin" folder inside this package
	and place it in your preferred working space.
]]

-------------------------- MetaPlugin Initialization --------------------------
local Meta = require(script.Parent:WaitForChild("Meta"))

Meta.Initialized:Connect(function()
	-- You can do some initial setup here to guarantee load order after Meta initializes but before things execute below this line
end)

Meta.Initialize(plugin) --ModuleScripts cannot access the plugin global, so we must provide it when starting MetaPlugin  

-------------------------- WORK BELOW THIS LINE --------------------------

--[[
	After initializing MetaPlugin, you can start your plugin implementation here.
]]