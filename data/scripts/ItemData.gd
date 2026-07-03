extends Resource
## A class for containing the raw data for items.
##
## Container for all the data needed to represent an item, such as it's Name,
## ID, Model.
class_name ItemData

## @experimental
## Don't know what this exactly does yet, but I'm thinking
## that some type of glossary, internal or external, could use this.
## Could also be used to quickly set up items, something like a prefab. [br]
## Feel free to remove this if this proves to be useless.
enum ITEMTYPE {
	SYRINGE,		## Syringe, potion-esque items.
	GUN,			## Gun type weapon.
	MELEE,			## Melee type weapon.
	KEY_LITERALLY,	## Keys for opening doors and locks.
	AMMO,			## Ammo for guns and stuff.
	
	OTHER,			## Miscellaneous items.
}

## Name of item.
@export var ItemName : String
## Texture of item for inventory, might not be needed if we just use
## a 3D model for inventory.
@export var Icon : Texture2D
## The model I presume.
@export_file("*.tscn") var ItemModelPrefab : String

# TODO: Make these variables changeable from the property editor.
# Do this via @tool and this link:
# (https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html)

## ID of the item.
var ID : int;

## Type of item. (Ex: Syringe, Gun, Melee)
@export var Type : ITEMTYPE;
## Determines if an Item takes up space in inventory and can be dropped;
## essentially makes all inventory related variables moot. Feel free to remove
## this.
@export var IsKeyItem : bool;
## Grid representing the "shape" of the item in the inventory. The 1s create
## the actual shape of the item, and 0s are the empty space.	[br]
## 5x4 example (pickaxe):                      [br]
##       1 1 1 1 1                      [br]
##       0 0 1 0 0                      [br]
##       0 0 1 0 0                      [br]
##       0 0 1 0 0
var Shape : gridShape = null;
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
# TODO: Move this to gridShape.gd
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























# just some blank space so i can scroll down in the editor, please dont remove #
