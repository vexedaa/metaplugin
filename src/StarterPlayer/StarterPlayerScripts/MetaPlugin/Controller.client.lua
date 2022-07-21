local Meta = require(script.Parent:WaitForChild("Meta"))

Meta.Initialized:Connect(function()
	--You can do some initial setup here to guarantee load order after Meta initializes but before things execute below this line
end)

Meta.Initialize(plugin)
-------------------------- WORK BELOW THIS LINE --------------------------

