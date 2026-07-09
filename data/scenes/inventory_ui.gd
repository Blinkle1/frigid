extends Control

## TODO: We'll probably need to refactor a bunch of shit to prevent
## this project from becoming maintenance hell.

@onready var INV_PATH = $"../../CharacterBody3D/ImportantStuff/InventoryHandler"
@onready var grid = $Screen/GridContainer
@onready var panel = $Screen
@onready var background = $Background
var STATE;
var borderSize = 10;
var cellSize = 70;

var cellList : Array[Button];
# Called when the node enters the scene tree for the first time.
func _ready():
	#background.color
	#self.
	var board = INV_PATH.testInv.Board;
	grid.columns = board.Width;
	
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
	
	
	panel.anchor_bottom = 0.5;
	panel.anchor_left = 0.5;
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
