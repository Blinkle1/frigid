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
@export var Board : Array[int] = [];
## Width of Board (x).
@export var Width : int;
## Height of Board (y).
@export var Height : int;
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

## See what item exists, if any, at a certain set of coordinates. Set check to
## false to skip all boundary checks. Returns -11 if x is out of bounds,
## -12 if y is out of bounds, and -13 if both are out of bounds.
func indexBoard(x : int, y : int, check : bool = true):
	if check:
		var c = 0;
		if (x >= self.Width or x < 0):
			c -= 1;
		if (y >= self.Height or y < 0):
			c -= 2;
		if c < 0:
			return c - 10;
	
	return Board[(y * self.Height) + self.Width];

## Actually see if an item can fit in the space provided.
func compareSpace(x : int, y : int, new:ItemData):
	# Bounds check.
	if (x + new.Width) > Width:
		return -1;
	if (y + new.Height) > Height:
		return -2;
		
	# Overlap check.
	for xindex in range(0, new.Width):
		for yindex in range(0, new.Height):
			# If at least one returns 0, there is no overlap.
			if (indexBoard(xindex + x, yindex + y, false) and
					new.indexShape(xindex, yindex, false)):
				return -3;
	
	return 0;

# TODO: Complete function. This mirrors the adjustShape function
# in ItemData. We could also totally disregard this function if it's
# functionality is not needed.

## @experimental
## Adjusts Width, Height, and consequentially Board.
func adjustBoard():
	pass;
