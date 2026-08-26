extends Control

## TODO: We'll probably need to refactor a bunch of shit to prevent
## this project from becoming maintenance hell.

enum STATE {
	CLOSED,
	OPEN
}


# Is there a better way to do this? This is extremely dependent on the
# position AND name of nodes.
@onready var INV_PATH = $"../../Player/ImportantStuff/InventoryHandler"
@onready var grid = $Screen/GridContainer
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
	var board = INV_PATH.testInv.Board;
	grid.columns = board.Width;
	grid.add_theme_constant_override("h_separation", borderSize);
	grid.add_theme_constant_override("v_separation", borderSize);
	self.size = get_viewport().size
	#var _psodl="
	self.anchor_bottom = 0;
	self.anchor_left = 0;
	self.anchor_top = 0;
	self.anchor_right = 0;
	#"

	
	
	panel.custom_minimum_size = Vector2(
		(borderSize * board.Width+1) + (cellSize * board.Width),
		(borderSize * board.Height+1) + (cellSize * board.Height)
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
	
#	grid.
	var _o = 0;
	for i in range(0, board.Width * board.Height):
		cellList.append(Button.new());
		cellList[i].custom_minimum_size = Vector2(cellSize, cellSize);
		grid.add_child(cellList[i]);
	
	
	
	# return 0 # Replace with function body.

func open():
	
	pass
		
		#print(items[i].position)
		

func close():
	
	pass


# TODO: Everytime an item moves position, update the items array if an
# item moves in the world.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
