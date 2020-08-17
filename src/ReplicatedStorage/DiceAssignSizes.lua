--[[
	@Author: Gavin "Mullets" Rosenthal
	@Desc: Assign a size to UI objects and track the viewport for delicate scaling
--]]

--// logic
local AssignSize = {}
AssignSize.Events = {}
AssignSize.Types = {'Frame','ImageLabel','ImageButton','TextButton','TextLabel','TextBox'}
AssignSize.OverrideMobile = false
AssignSize.Enums = {
	['Mobile'] = {};
	['Computer'] = {};
}

--// services
local LoadLibrary = require(game:GetService('ReplicatedStorage'):WaitForChild('PlayingCards'))
local Services = setmetatable({}, {__index = function(cache, serviceName)
    cache[serviceName] = game:GetService(serviceName)
    return cache[serviceName]
end})

--// functions
local function Filter(element,enum,value)
	if enum ~= nil and value ~= nil then
		if AssignSize.Enums[enum] then
			AssignSize.Enums[enum][element] = value
			return true
		end
	elseif not enum and not value then
		for index,type in pairs(AssignSize.Types) do
			if element:IsA(type) then
				return true
			end
		end
	end
	return false
end

local function Valid(element,enum)
	if element ~= nil and enum ~= nil then
		if AssignSize.Enums[enum] then
			if AssignSize.Enums[enum][element] ~= nil then
				return AssignSize.Enums[enum][element]
			end
		end
	end
	return true
end

local function Resize(element,scale,min,max)
	scale = scale or 1
	min = min or 0
	max = max or 1
	local viewportSize = Services['Workspace'].CurrentCamera.ViewportSize
	if viewportSize.Y <= 700 then
		AssignSize.OverrideMobile = true
	else
		AssignSize.OverrideMobile = false
	end
	local OGSize = AssignSize.Events[element]['OGSize']
	if Services['UserInputService'].TouchEnabled or AssignSize.OverrideMobile then
		if not Valid(element,AssignSize.Enums.Mobile) then return end
		local uiSize = (viewportSize.X/viewportSize.Y) * scale
		local clampX = math.clamp(OGSize.X.Scale * uiSize, min, max)
		local clampY = math.clamp(OGSize.Y.Scale * uiSize, min, max)
		element.Size = UDim2.new(clampX, 0, clampY, 0)
	elseif Valid(element,AssignSize.Enums.Computer) then
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
		if absoluteY < 36 then
			Resize(element,scale * 2,min,max)
		end
	end
end

return function(element,scale,min,max)
	if Filter(element) then
		if Filter(element,scale,min) then return end
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
		return true
	end
	warn('[ASSIGN SIZES]:','Unexpected element type, you can only use GUI elements |','Class used:',element.ClassName,'| Name:',element.Name)
	return false
end