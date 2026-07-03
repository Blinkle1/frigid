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
var Grid : Array[int];

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
	
	Grid.resize(self.Width * self.Height);
	Grid.fill(0);

## Returns a copy of itself rotated, or rotates itself. [br]
## rotation (clockwise): 0 is 0deg, 1 is 90deg, 2 is 180deg, 3 is 270deg
func rotateGrid(rotation : int, returnCopy : bool = 0):
	var i = 0;
	var k : Array[int];
	
	match rotation:			
		1:		# 90 degree rotation
			k.resize(self.Width*self.Height)
			
			for x in range(0, self.Height, 1):
				for y in range(self.Width-1, -1, -1):
					k[i] = Grid[(y*self.Height)+x];
					i += 1;
			
		2:		# 180 degree rotation
			k.assign(Grid.duplicate());
			k.reverse();
			
		3:		# 270 degree roation (-90 degree rotation)
			k.resize(self.Width*self.Height)
			
			for x in range(self.Height-1, -1, -1):
				for y in range(0, self.Width, 1):
					k[i] = Grid[(y*self.Height)+x];
					i += 1;
			
		0, _:	# 0 deg rotation; this is the default option
			k = Grid.duplicate();
	
	if returnCopy:
		var c := gridShape.new(self.Height, self.Width);
		c.Grid.assign(k);
		return c;
	else:
		self.Grid.assign(k);
		var s = self.Height;		# swap
		self.Height = self.Width;
		self.Width = s;

## See what number is at a set of coordinates. Set check
## to false to skip all boundary checks. Returns -2 if out of bounds.
func indexGrid(x : int, y : int, check : bool = true):
	if check:
		if (x >= self.Width or x < 0) or (y >= self.Height or y < 0):
			return -2
	
	return Grid[(y * self.Height) + self.Width];
