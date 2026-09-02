extends Control

## TODO: We'll probably need to refactor a bunch of shit to prevent
## this project from becoming maintenance hell.

enum STATE {
	CLOSED,
	OPEN
}


# Is there a better way to do this? This is extremely dependent on the
# position AND name of nodes.
@onready var INV_PATH = $"../../Player/Inventory"
@onready var UIGrid = $Screen/GridContainer
@onready var panel = $Screen
@onready var background = $Background
var INV_STATE : STATE;
var borderSize = 10;
var cellSize = 40;

var cellList : Array[Button];
# Called when the node enters the scene tree for the first time.
func _ready():
	#background.color
	#self.
	var inventory = INV_PATH.testInv;
	UIGrid.columns = inventory.Width;
	UIGrid.add_theme_constant_override("h_separation", borderSize);
	UIGrid.add_theme_constant_override("v_separation", borderSize);
	self.size = get_viewport().size
	#var _comment="
	self.anchor_bottom = 0;
	self.anchor_left = 0;
	self.anchor_top = 0;
	self.anchor_right = 0;
	#"

	
	
	panel.custom_minimum_size = Vector2(
		(borderSize * inventory.Width+1) + (cellSize * inventory.Width),
		(borderSize * inventory.Height+1) + (cellSize * inventory.Height)
		);
	#SCREEN_PATH.position = an
	
	
	
	panel.anchor_bottom = 0.5
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	var rec = panel.get_rect().size
	panel.offset_left = -rec.x / 2
	panel.offset_right = rec.x / 2
	panel.offset_top = -rec.y / 2
	panel.offset_bottom = rec.y / 2
	
#	TODO: In the inventory UI, give every button a (x,y) value. When pressed,
#	emit those values to a function somewhere in THIS file. The receiving
#	function should remove that item from the inventory.
#	There is a new script "inventoryButton.gd" which has a new class to hold
#	the (x,y) pair. I am currently having trouble emitting the (x,y) pair
#	so please fix that.


	var _o = 0;
	for i in range(0, inventory.Width * inventory.Height):
		var invButt = InventoryButton.new()
		#invButt.x = i%inventory.Width
		#invButt.y = (i - i%inventory.Width) / inventory.Height
		invButt.pressed.connect(test)
		
		cellList.append(invButt);
		
		cellList[i].custom_minimum_size = Vector2(cellSize, cellSize);
		UIGrid.add_child(cellList[i]);
	
	
	
	# return 0 # Replace with function body.

func test():
	print("work")

func dropItem(x : int, y : int):
	print(str(x) + ", " + str(y))

func refreshInventory():
	for i in range(0,cellList.size()):
		cellList[i].text = ""
		if INV_PATH.testInv.Grid[i]:
			cellList[i].text = str(INV_PATH.testInv.Grid[i])
		
		#print(items[i].position)
		

func close():
	
	pass


# TODO: Everytime an item moves position, update the items array if an
# item moves in the world.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
