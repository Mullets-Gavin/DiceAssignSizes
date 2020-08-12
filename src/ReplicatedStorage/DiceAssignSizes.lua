--[[
	@Author: Gavin "Mullets" Rosenthal
	@Desc: Assign a size to UI objects and track the viewport for delicate scaling
--]]

--// logic
local AssignSize = {}
AssignSize.Events = {}
AssignSize.OverrideMobile = false

--// services
local LoadLibrary = require(game:GetService('ReplicatedStorage'):WaitForChild('PlayingCards'))
local Services = setmetatable({}, {__index = function(cache, serviceName)
    cache[serviceName] = game:GetService(serviceName)
    return cache[serviceName]
end})

--// functions
local function Resize(element,scale,min,max)
	local viewportSize = Services['Workspace'].CurrentCamera.ViewportSize
	if viewportSize.Y <= 700 then
		AssignSize.OverrideMobile = true
	else
		AssignSize.OverrideMobile = false
	end
	local OGSize = AssignSize.Events[element]['OGSize']
	if Services['UserInputService'].TouchEnabled or AssignSize.OverrideMobile then
		local uiSize = (viewportSize.X/viewportSize.Y) * scale
		local clampX = math.clamp(OGSize.X.Scale * uiSize, min, max)
		local clampY = math.clamp(OGSize.Y.Scale * uiSize, min, max)
		element.Size = UDim2.new(clampX, 0, clampY, 0)
	else
		local uiSize
		if (viewportSize.X/viewportSize.Y) >= 2 then
			uiSize = (viewportSize.X/viewportSize.Y) * (scale/3.5)
		else
			uiSize = (viewportSize.X/viewportSize.Y) * (scale/2)
		end
		local clampX = math.clamp(OGSize.X.Scale * uiSize, min, max)
		local clampY = math.clamp(OGSize.Y.Scale * uiSize, min, max)
		element.Size = UDim2.new(clampX, 0, clampY, 0)
		local absoluteY = element.AbsoluteSize.Y
		if absoluteY < 32 then
			element.Size = UDim2.new(clampX, 0, 0, 32)
		end
	end
end

return function(element,scale,min,max)
	if element:IsA('Frame') or element:IsA('ImageLabel') then
		if AssignSize.Events[element] then
			AssignSize.Events[element]['Event']:Disconnect()
		else
			AssignSize.Events[element] = {
				['Event'] = nil;
				['OGSize'] = nil;
			}
		end
		AssignSize.Events[element]['OGSize'] = element.Size
		Resize(element,scale,min,max)
		local event;
		event = Services['Workspace'].CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
			Resize(element,scale,min,max)
		end)
		AssignSize.Events[element]['Event'] = event
	end
end