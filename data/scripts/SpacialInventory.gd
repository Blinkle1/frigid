extends Node
## Represents a spacial inventory.
##
## Has Board which contains the shapes of items (the dimensions of which are
## determined by the Width an Height variables). Has List which actually stores
## the items in memory. This should be used for David's backpack, holsters, and
## whatever else you think might need it.
class_name SpacialInventory

## A 2d array that represents a spacial item storage. The bounds are defined
## by Width and Length, "top-left corner" is (0,0). 0 means a cell is empty,
## -1 means that the spot is invalid (unused for now), and other numbers
## index into ItemsList (subtracting 1) to see what item is there.     [br]
## 4x4 example:                      [br]
##       1 1 1 3                      [br]
##       2 2 4 3                      [br]
##       0 0 4 5                      [br]
##       0 0 4 0                      [br]
## 0 is empty space, 1 points to the first element (index 0) of ItemsList,
## 2 the second element (index 1), etc.
var Board : gridShape;
## List of the actual items in the inventory. This is an internal variable, and
## should not be shown via UI. Items are added to the lowest empty (null) slot.
## Is the same length as Board.
@export var List : Array[ItemData] = [];

## Constructor. Given Width and Height, create and zero out arrays. Width and
## Height have a minimum value of 1.
func _init(Width : int, Height : int):
	self.Width = Width if Width > 0 else 1;
	self.Height = Height if Height > 0 else 1;
	self.Board.resize(self.Width*self.Height);
	self.Board.fill(0);
	self.List.resize(self.Width*self.Height);
	self.List.fill(null);

# TODO: This should have multiple return values:
# if the item can't fit, return a shape that shows where
# there are collisions. Example:
# 
#   item            inv                  
#  . . 1 0        0 0 1 1   (cant fit)   . . 1
#  . . 1 1   ->   0 0 0 0        =       . . 
#  . . . .        0 0 0 0                

## @experimental
## Actually see if an shape can fit in the space provided. [br]
## Returns -1 if out of bounds, 0 if there's overlap, 1 if there is no overlap. 
func spaceCheck(x : int, y : int, shape : gridShape):
	# Bounds check.
	if ( ((x + shape.Width) > self.Board.Width)
	or ((y + shape.Height) > self.Board.Height) ):
		return -1;
		
	# Overlap check.
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			# If at least one returns 0, there is no overlap.
			if (self.Board.indexGrid(xindex + x, yindex + y, false) and
					shape.indexGrid(xindex, yindex, false)):
				return 0;
	
	return 1;

# TODO: Complete function. This mirrors the adjustShape function
# in ItemData. Could be used for inventory space upgrades. Should be used
# for things like Holsters, as those are entirely separate spacial inventories.

## @experimental
## Adjusts Width, Height, and consequentially Board.
func adjustBoard():
	pass;

## Add an item to inventory by checking if it fits in the spacial inventory.
##
func addItemBySpace(item : ItemData) -> bool:
	return 0;
	







#
