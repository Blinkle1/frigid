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
var List : Array[ItemData] = [];

## Limit of weight before items are rejected (?)
var WeightLimit : int;
## Enables or disables item limit
var EnableItemLimit : bool = false;
## Limit before more items are rejected. Holsters set this value to 1.
var ItemLimit : int;
## If true, essentially makes itemLimit only count unique stacks
var CountOnlyUniqueItems : bool = false;

#@export var List2 : Array[ItemData] = [];

## Contains the top-left corner of items, stored in .x and .y, and their
## rotation, stored in .z. Rotation should be from 0-7. (See gridShape.rotateGrid()
## for details on how rotation should be read.)
var RotPosList : Array[Vector3i] = []

## Constructor. Given Width and Height, create and zero out arrays. Width and
## Height have a minimum value of 1.
func _init(Width : int, Height : int):
	if Height < 1:
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
	self.RotPosList.fill(Vector3i(0,0,0))
	
	#self.List2.resize(Width*Height);
	#self.List2.fill(null);

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
	var k
	# Store item in List at lowest empty spot.
	for i in range(0, List.size()):
		if self.List[i] == null:
			self.List[i] = item
			#self.List2[i] = item
			index = i+1			# The value 0 in a grid indicates emptiness, so this cannot be 0
			k = i
			self.RotPosList[i].x = x;
			self.RotPosList[i].y = y;
			self.RotPosList[i].z = rotation;
			
			break;
		else:
			print(self.List[i])

	#print(self.List[k])
	#print(k)
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
## Does NOT remove data from RotPosList, it is not necessary (yet).
func removeItemByCoords(x : int, y : int) -> int:
	var index = self.indexGrid(x, y);
	if index < 0:
		print("removeItemByCoords: Coordinates out of bounds.")
		return -1
	if index == 0:
		print("removeItemByCoords: Attempted to remove non-existant item.")
		return -2
	
	# This will get the actual index into List[].
	index -= 1
	
	var item : ItemData = self.List[index];
	var shape : gridShape = item.rotateGrid(self.RotPosList[index].z, 1)
	
	var nx = self.RotPosList[index].x
	var ny = self.RotPosList[index].y
	# Remove item from List
	List[index] = null
	
	# Remove item from grid
	for xindex in range(0, shape.Width):
		for yindex in range(0, shape.Height):
			if (shape.indexGrid(xindex, yindex) == 1):
				self.setAtIndex(xindex + nx, yindex + ny, 0);
	return 1


## Get what item is at a certain index. If rotpos is true, gets the item's
## Rotation and Position instead.
func getItemByCoords(x : int, y : int, rotpos : bool = false): 
	var i = self.indexGrid(x, y)
	
	if i < 1:
		return null
	
	if rotpos:
		return RotPosList[i-1];
	else:
		return List[i-1]

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
