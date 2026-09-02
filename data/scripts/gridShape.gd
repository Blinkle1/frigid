extends Node
## Grid of integers that represent items (usually).
##
## gridShape is essentially an array of integers that represent a 2D grid. The
## size of that grid is defined by the Width and Height members. This class is
## used to represent the shapes of items and the space in a spacial inventory.
class_name gridShape

## The width of the grid, minimum of 1.
@export var Width : int;

## The height of the grid, minimum of 1.
@export var Height : int;

## The grid. Numbers within it represent different things depending on what
## class is using it.
@export var Grid : Array[int];

## Create grid given Width and Height, fill with 0s.
func _init(Width : int, Height : int):
	if Height < 1:
		self.Height = 1;
	else:
		self.Height = Height;
	
	if Width < 1:
		self.Width = 1;
	else:
		self.Width = Width;
	
	Grid = []
	Grid.resize(self.Width * self.Height);
	Grid.fill(0);

## Returns a copy of itself rotated, or rotates itself. [br]
## Rotation determines how the object is orientated: How many clockwise 90deg
## turns it should take, and if it should be flipped vertically. [br][br]
## 0 = 0deg, 1 = 90deg, 2 = 180deg, 3 = 270deg. Add 4 to this number to flip
## vertically. 
## Flipping occurs AFTER rotation.
func rotateGrid(rotation : int, returnCopy : bool = 0):
	var i = 0;
	var k : Array[int];
	
	# masks only first 2 bits
	match rotation & 3:
		1:		# 90 degree rotation
			k.resize(self.Width*self.Height)
			
			for x in range(0, self.Width, 1):
				for y in range(self.Height-1, -1, -1):
					k[i] = Grid[(y*self.Width)+x];
					i += 1;
			
		2:		# 180 degree rotation
			k.assign(Grid.duplicate());
			k.reverse();
			
		3:		# 270 degree rotation (-90 degree rotation)
			k.resize(self.Width*self.Height)
			
			for x in range(self.Width-1, -1, -1):
				for y in range(0, self.Height, 1):
					k[i] = Grid[(y*self.Width)+x];
					i += 1;
			
		0:	# 0 deg rotation
			k = Grid.duplicate();
	
	# Isolate third bit, flip vertically if it's 1.
	if (rotation & 4):
		var w
		var h
		if (rotation & 1):
			w = self.Height
			h = self.Width
		else:
			w = self.Width
			h = self.Height
		
		var swap
		for x in range(0, w):
			for y in range(0, int(h/2)):
				var origin = (y*w)+x			#
				var target = (w*(h-(1+y)))+x	#
				
				swap = k[origin]
				k[origin] = k[target]
				k[target] = swap
	
	if returnCopy:
		var c
		if (rotation & 1):
			c = gridShape.new(self.Height, self.Width);
		else:
			c = gridShape.new(self.Width, self.Height);
		c.Grid.assign(k);
		return c;
	else:
		self.Grid.assign(k);
		if (rotation & 1):
			var s = self.Height;
			self.Height = self.Width;
			self.Width = s;

func getSize() -> int:
	return self.Width * self.Height;

## See what number is at a set of coordinates. Set check
## to false to skip all boundary checks. Returns -2 if out of bounds.
func indexGrid(x : int, y : int, returnCellIndex : bool = false, check : bool = true):
	if check:
		if (x >= self.Width or x < 0) or (y >= self.Height or y < 0):
			return -2
	if returnCellIndex:
		return (y * self.Width) + x
	else:
		return Grid[(y * self.Width) + x];

## Sets the cell at (x, y) to value.
func setAtIndex(x : int, y : int, value):
	#print( str((y * self.Width) + x) + ", " + str(Grid.size()))
	Grid[(y * self.Width) + x] = value;


## For debugging, prints the Grid to the console.
func printGrid():
	var row : String = ""
	for y in range(0,self.Height):
		for x in range(0,self.Width):
			row += str((Grid[(y * self.Width) + x]))
		print(row)
		row = ""
