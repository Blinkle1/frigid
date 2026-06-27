extends Resource
class_name ItemData

## Name of item.
@export var ItemName : String
@export var Icon : Texture2D
@export_file("*.tscn") var ItemModelPrefab : String

# TODO: Make these variables changeable from the property editor.

## Determines if an Item takes up space in inventory and can be dropped;
## essentially makes all inventory related variables moot. Feel free to remove
## this.
@export var IsKeyItem : bool;
## Item width. Used in inventory.
@export var Width : int;
## Item height. Used in inventory.
@export var Height : int;
## 2d array representing the "shape" of the item in the inventory, size is
## determined by the Width and Height variables. The 1s represent the actual
## shape, the 0s represent empty space.                      [br]
## 4x4 example:                      [br]
##       1 1 1 1                      [br]
##       0 1 0 0                      [br]
##       0 1 0 0                      [br]
##       0 1 0 0
@export var Shape : Array[int];
## The weight of an Item, currently only to be used in inventory. We can drop
## this if we decide to not go through with weight. We can also change the type
## to INT if that would make calculations easier.
@export var Weight : float;
## Maximum items per stack. This is usally only 1 for things like weapons, and
## higher for things like ammo.
@export var MaxStack : int;
## Can this item be put in the pocket slots, is shown in the tooltip.
## Typically this would be true for small items.
@export var canBePocket : bool;

# TODO: This function is not done yet, as it does not adjust the underlying
# shape properly, all it does is change the Width and Height variables.
## Function to be called when changing the size of an item in the properties
## menu. Any new cells/indexes created should be set to 0. Width and Height
## should never go below 1.                 [br]
## Returns 0, -1, -2, or -3 depending on if any size changes went out of bounds:
## 0 for none, -1 for Width, -2 for Height, -3 for both.
func adjustSize(widthChange : int = 0, heightChange : int = 0):
	var rVal = 0;
	
	if (self.Width + widthChange < 1):
		self.Width = 1;
		rVal -= 1;
	else:
		self.Width += widthChange;
	
	if (self.Height + heightChange < 1):
		self.Height = 1;
		rVal -= 2;
	else:
		self.Height += heightChange;
	
	return rVal;

## See if the item exists at the given set of coordinates. Set check
## to false to skip all boundary checks. Returns -1 if x is out of bounds,
## -2 if y is out of bounds, and -3 if both.
func indexShape(x : int, y : int, check : bool = true):
	if check:
		var c = 0;
		if (x >= self.Width or x < 0):
			c -= 1;
		if (y >= self.Height or y < 0):
			c -= 2;
		if c < 0:
			return c;
	
	return Shape[(y * self.Height) + self.Width];
