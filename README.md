<div align="center">
<h1>Dice Assign Sizes</h1>

By [Mullet Mafia Dev](https://www.roblox.com/groups/5018486/Mullet-Mafia-Dev#!/about)
</div>

Assign a UI size that translates per device! By hooking UI to this function, you can easily create a way to resize & control the values of how large an element is. This allows for a wide variety of devices to fit your UI, and even makes users with low-resolution PCs use mobile-like UI for better control!

## Documentation

### DiceAssignSizes
```
DiceAssignSizes(element,scale,min,max)
```

To properly use this function, element must be a UI element that is a descendant of the PlayerGui. Set the scale of the element (the multiplier) and set minimum & maximum values to contain the element in a certain size. Be mindful, this size will be quite large on mobile, utilize the min & max correctly!

*Example:*

To properly use this, require the module.
```lua
local DiceAssignSizes = require(game.ReplicatedStorage.DiceAssignSizes)
```

Now you can call the function!
```lua
local DiceAssignSizes = require(game.ReplicatedStorage.DiceAssignSizes)
DiceAssignSizes(element,scale,min,max)

-- example:
DiceAssignSizes(MainUI.PlayerData,1.2,0.125,0.2)
```
