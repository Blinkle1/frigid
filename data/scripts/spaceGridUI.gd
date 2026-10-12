extends Panel

class_name GridUI

signal drag_started(invIndex : int, x : int, y : int);
signal item_removed(invIndex : int, x : int, y : int);
signal drag_ended(invIndex : int, x : int, y : int);

## A pointer to the spacial inventory this is supposed to represent.
## Read only.
var inventory : SpacialInventory

## Index of inventory in Inventory Handler
var invIndex : int

## Actual grid of buttons.
var Grid : GridContainer
var button : InventoryButton

## The distance between cells
var borderSize : int 
## The side length of each cell
var cellSize : int 
## Total number of cells.
var cellCount : int
	#set(v):
		#pass
var cellList : Array[InventoryButton];

# Very weird way of _ready'ing this node. Is there a better way?
func initialize(inv, n):
	self.inventory = inv
	self.invIndex = n
	
	# Have to do this because node paths break upon calling duplicate()
	Grid = self.get_child(0)
	button = Grid.get_child(0)
	
	Grid.columns = inventory.Width;
	Grid.add_theme_constant_override("h_separation", borderSize);
	Grid.add_theme_constant_override("v_separation", borderSize);
	
	
	self.custom_minimum_size = Vector2(
		(borderSize * inventory.Width+1) + (cellSize * inventory.Width),
		(borderSize * inventory.Height+1) + (cellSize * inventory.Height)
		);
	
	var poop = 2
	
	self.anchor_bottom = 0.5
	self.anchor_left = 0.5
	self.anchor_top = 0.5
	self.anchor_right = 0.5
	var rec = self.get_rect().size
	self.offset_left = -rec.x / poop
	self.offset_right = rec.x / poop
	self.offset_top = -rec.y / poop
	self.offset_bottom = rec.y / poop
	
	self.custom_minimum_size.x = 200
	self.custom_maximum_size.y = 200
	
	self.position.x += randi_range(-400,400)
	
	# Default ppearance of buttons
	var DS : StyleBoxFlat = StyleBoxFlat.new()
	DS.set_corner_radius_all(0)
	DS.bg_color = Color(0.35, 0.35, 0.35, 1.0)
	
	# Signal Connections
	# These should be passed to all duplicates
	button.drag_start.connect(initDrag)
	button.hovered.connect(previewItemOutline)
	button.pressed.connect(itemRemoved)
	button.drag_end.connect(endDrag)
	
	button.add_theme_stylebox_override("normal", DS)
	
	button.x = 0
	button.y = 0
	button.occupied = false
	
	cellList.append(button)
	
	for i in range(1, (inventory.Width * inventory.Height)):
		var invButt : InventoryButton = button.duplicate()
		
		invButt.x = i%inventory.Width
		invButt.y = (i - i%inventory.Width) / inventory.Width
		
		
		
		cellList.append(invButt);
		
		cellList[i].custom_minimum_size = Vector2(cellSize, cellSize);
		Grid.add_child(cellList[i]);

func _ready():
	# This is NOT how this shit is supposed to happen, but for now it will NOT work.
	#await get_parent().ready
	pass

	
	

func changeCellCount(v : int):
	
	Grid.remove_child(button)
	
	for n in Grid.get_children():
		n.queue_free()
	
	Grid.add_child(button)
	
	for n in range(1,v+1):
		pass

## Highlight the cells that would be affected by insertion.
## Do not care about this right now to be honest.
func previewItemOutline(x: int, y: int):
	pass

func itemRemoved(x: int, y: int):
	item_removed.emit(self.invIndex, x, y)
	refreshInventory()
	
func endDrag(x : int, y : int):
	drag_ended.emit(self.invIndex, x, y)

func initDrag(x : int, y : int):
	drag_started.emit(self.invIndex, x, y)
	refreshInventory()

# "Redraw" the UI based on the actual inventory's contents.
func refreshInventory():
	for i in range(0,cellList.size()):
		if inventory.Grid[i]:
			cellList[i].text = str(inventory.Grid[i])
			cellList[i].occupied = true
		else:
			cellList[i].text = ""
			cellList[i].occupied = false











#
