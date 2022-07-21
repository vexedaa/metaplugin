local RunService = game:GetService("RunService")
local Connection = require(script:WaitForChild("Connection"))

local Event = {}
Event.__index = Event
	
function Event.new()
	local self = setmetatable({
		Listeners = {};
		Waiting = {};
		Connections = {};
	}, Event)
	return self
end

function Event:Fire(...)
	local pack = {...}
	for i, fnc in pairs(self.Listeners) do
		local fncThread = coroutine.wrap(fnc)
		fncThread(unpack(pack))
	end
	local waitList = self.Waiting
	self.Waiting = {}
	for i, thread in pairs(waitList) do
		coroutine.resume(thread, unpack(pack))
	end
end

function Event:Connect(fn)
	local connection = Connection.new(self.Listeners, self)
	self.Listeners[connection] = fn
	table.insert(self.Connections, connection)
	return connection
end

function Event:Disconnect(connection)
	self.Listeners[connection] = nil
end

function Event:Wait(timeout, default)
	assert(typeof(timeout) == "number", "Timeout (number) required for wait time.")
	local current_thread = coroutine.running()
	self.Waiting[current_thread] = true
	task.wait(timeout)
	self.Waiting[current_thread] = nil
	coroutine.resume(current_thread, default)
end

return Event
