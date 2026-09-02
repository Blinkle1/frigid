extends gridShape
## Represents a spacial inventory.
##
## Has a grid which contains the shapes of items (the dimensions of which are
## determined by the Width an Height variables). Has List which actually stores
## the items in memory. This should be used for David's backpack, holsters, and
## whatever else you think might need it.
class_name SpacialInventory

## List of the actual items in the inventory. This is an internal variable, and
## should not be shown via UI. Items are added to the lowest empty (null) slot.
## Is the same length as Board.
@export var List : Array[ItemData] = [];

## Contains the top-left corner of items, stored in .x and .y, and their
## rotation, stored in .z. Rotation should be from 0-7. (See gridShape.rotateGrid()
## for details on how rotation should be read.)
var RotPosList : Array[Vector3] = []

## Constructor. Given Width and Height, create and zero out arrays. Width and
## Height have a minimum value of 1.
func _init(Width : int, Height : int):
	if Height < 1:
		print("TESTTESTTEST: " + str(self.Height))
		self.Height = 1;
	else:
		self.Height = Height;
	
	if Width < 1:
		self.Width = 1;
	else:
		self.Width = Width;
	
	Grid.resize(self.Width * self.Height);
	Grid.fill(0);
	self.List.resize(Width*Height);
	self.List.fill(null);
	self.RotPosList.resize(Width*Height);
	self.RotPosList.fill(Vector3(0,0,0))

# TODO: This could have multiple return values:
# if the item can't fit, return a shape that shows where
# there are collisions. Example:
# 
#   item            inv                  
#  . . 1 0        0 0 1 1   (cant fit)   . . 1 .
#  . . 1 1   ->   0 0 0 0        =       . . . .
#  . . . .        0 0 0 0                . . . .

## @experimental
## Actually see if an shape can fit in the space provided. [br]
## Returns -1 if out of bounds, 0 if there's overlap, 1 if there is no overlap. 
func spaceCheck(x : int, y : int, shape : gridShape, _mode : int = 0):
	# Bounds check.
	if ( ((x + shape.Width) > self.Width)
	or ((y + shape.Height) > self.Height) ):
		return -1;
	
	# Overlap check.
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			# If at least one of the indexGrid()s returns 0, there is no overlap.
			if (self.indexGrid(xindex + x, yindex + y, false) and
					shape.indexGrid(xindex, yindex, false)):
				return 0;
	
	return 1;


## Adds an item to the grid, and the items list. This does NOT preform any
## checks, use spaceCheck() prior to calling this function for checks.
func addItem(x : int, y : int, rotation : int, item:ItemData):
	var index : int = -1;
	var shape = item.rotateGrid(rotation, 1);		# rotated item shape
	
	# Store item in List at lowest empty spot.
	for i in range(0, List.size()):
		if List[i] == null:
			List[i] = item
			index = i+1
			
			RotPosList[i].x = x;
			RotPosList[i].y = y;
			RotPosList[i].z = rotation;
			
			break;
			
	if index == -1:
		print("Inventory full! Did you not call spaceCheck()?")
		return -1
	
	#shape.printGrid()
	
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			if (shape.indexGrid(xindex, yindex) == 1):
				self.setAtIndex(xindex + x, yindex + y, index);
				
	
	return 1;

## Removes an item from gridShape and List, given an index into List.
func removeItemByList(index : int):
	if index > List.size():
		print("removeItemByList: Index greater than inventory size.")
		return -1
		
	var item = List[index];
	
	if item == null:
		print("removeItemByList: Attempted to remove null item at index " + str(index) + ".")
		return -2
	
	var rotpos = RotPosList[index]
	var shape = item.rotateGrid(rotpos.z)
	
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			if (item.indexGrid(xindex, yindex) == 1):
				self.setAtIndex(xindex + rotpos.x, yindex + rotpos.y, 0);
	return 1

## Removes an item from gridShape and List, given coordinates in gridShape.
func removeItemByCoords(x : int, y : int) -> int:
	var index = self.indexGrid(x, y);
	if index < 0:
		print("removeItemByCoords: Coordinates out of bounds.")
		return -1
	if index == 0:
		print("removeItemByCoords: Attempted to remove non-existant item.")
		return -2
	
	
	var item = List[index];
	var shape = item.rotateGrid[RotPosList[index]]
	
	# Remove item from List
	List[index] = null
	
	# Remove item from grid
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			if (item.indexGrid(xindex, yindex) == 1):
				self.setAtIndex(xindex + x, yindex + y, 0);
	return 1

# TODO: Complete function. This mirrors the adjustShape function
# in ItemData. Could be used for inventory space upgrades. Should be used
# for things like Holsters, as those are entirely separate spacial inventories.



## @experimental
## Adjusts Width, Height, and consequentially Grid.
func adjustGrid():
	pass;

## @experimental
## NOT FINISHED OR CURRENTLY WORKING [br]
## Add item by just appending to List?
## Not sure if needed.
func addItembyList(item : ItemData):
	pass;







#
