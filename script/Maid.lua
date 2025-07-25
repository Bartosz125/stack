-- Module: Maid (Originally module 'c')

local Maid = {}
Maid.ClassName = "Maid"

function Maid.new()
	return (setmetatable({ _tasks = {} }, Maid))
end

function Maid.isMaid(value)
	return type(value) == "table" and value.ClassName == "Maid"
end

function Maid.__index(self, index)
	if Maid[index] then
		return Maid[index]
	else
		return self._tasks[index]
	end
end

function Maid.__newindex(self, index, newTask)
	if Maid[index] ~= nil then
		error(string.format("Cannot use '%s' as a Maid key", tostring(index)), 2)
	end
	local tasks = self._tasks
	local job = tasks[index]
	if job == newTask then
		return
	end
	tasks[index] = newTask
	if job then
		if typeof(job) == "function" then
			(job)()
		elseif typeof(job) == "table" then
			local destructable = job
			if type(destructable.Destroy) == "function" then
				destructable:Destroy()
			end
		elseif typeof(job) == "Instance" then
			job:Destroy()
		elseif typeof(job) == "thread" then
			local cancelled
			if coroutine.running() ~= job then
				cancelled = pcall(function()
					task.cancel(job)
				end)
			end
			if not cancelled then
				task.defer(function()
					task.cancel(job)
				end)
			end
		elseif typeof(job) == "RBXScriptConnection" then
			job:Disconnect()
		end
	end
end

function Maid.Add(self, task)
	if not task then
		error("Task cannot be false or nil", 2)
	end
	self[#((self._tasks)) + 1] = task
	if type(task) == "table" and not task.Destroy then
		warn("[Maid.Add] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end
	return task
end

function Maid.GiveTask(self, task)
	if not task then
		error("Task cannot be false or nil", 2)
	end
	local taskId = #((self._tasks)) + 1
	self[taskId] = task
	if type(task) == "table" and not (task).Destroy then
		warn("[Maid.GiveTask] - Gave table task without .Destroy\n\n" .. debug.traceback())
	end
	return taskId
end

function Maid.GivePromise(self, promise)
	if not promise:IsPending() then
		return promise
	end
	local newPromise = promise.resolved(promise)
	local id = self:GiveTask(newPromise)
	newPromise:Finally(function()
		self[id] = nil
	end)
	return newPromise
end

function Maid.DoCleaning(self)
	local tasks = self._tasks
	for index, job in tasks do
		if typeof(job) == "RBXScriptConnection" then
			tasks[index] = nil
			job:Disconnect()
		end
	end
	local index, job = next(tasks)
	while job ~= nil do
		tasks[index] = nil
		if typeof(job) == "function" then
			(job)()
		elseif typeof(job) == "table" and type((job).Destroy) == "function" then
			(job):Destroy()
		elseif typeof(job) == "Instance" then
			job:Destroy()
		elseif typeof(job) == "thread" then
			local cancelled
			if coroutine.running() ~= job then
				cancelled = pcall(function()
					task.cancel(job)
				end)
			end
			if not cancelled then
				local toCancel = job
				task.defer(function()
					task.cancel(toCancel)
				end)
			end
		elseif typeof(job) == "RBXScriptConnection" then
			job:Disconnect()
		end
		index, job = next(tasks)
	end
end
Maid.Destroy = Maid.DoCleaning

return Maid
