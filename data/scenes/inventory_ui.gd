extends Control

## TODO: We'll probably need to refactor a bunch of shit to prevent
## this project from becoming maintenance hell.

enum STATE {
	CLOSED,
	OPEN
}

signal removeItem()
#signal ()

# Is there a better way to do this? This is extremely dependent on the
# position AND name of nodes.
#@onready var INV_PATH : InventoryHandler = $"../../Player/Inventory"
#@onready var UIGrid : GridContainer = $Screen/InventorySlots
#@onready var panel : Panel = $Screen
#@onready var background : Panel = $Background
var INV_STATE : STATE;
var borderSize = 1;
var cellSize = 80;

var isDragging = false
var dragShape : gridShape
var dragRotPos : Vector3i
var dragPanelShape : Control = null
var dragData : ItemData
var dragPreviousLocation : Vector3i


@onready var screen = $Screen

var invList : Array[GridUI]


## Pointer to inventory handler. Direct all inventory management requests here.
var invHandler : InventoryHandler = Global.G_INVENTORYHANDLER

func _ready():
	##var _comment="
	#self.anchor_bottom = 0;
	#self.anchor_left = 0;
	#self.anchor_top = 0;
	#self.anchor_right = 0;
	##"
	
	
	if invHandler == null:
		print("oh no")
		invHandler = Global.G_INVENTORYHANDLER
		if invHandler == null:
			print("AW FUCK")
	
	if invHandler != null:
		for n in range(0, invHandler.inventoryCount):
			var k
			if n != 0:
				k = screen.duplicate()
				invList.append(k)
				print(k.get_children())
			else:
				invList.append(screen)
			k = invList[n];
			
			print(invHandler.inventories[n])
			
			k.initialize(invHandler.inventories[n], n)
			
			
	

func dummy():
	pass
# on click, remove item
func removeItemOnClick(inv : int, x : int, y: int):
	removeItem.emit(inv, x, y)


# TODO: Keep going, if you lock in, you can do anything.
# TODO: Everything kind of works, but trying to make anything a @tool fails due
# to G_INVENTORYHANDLER being null. I do not know why this is, but I assume it
# to be due to me not understanding autoloads/globals.
# The issues right now are:
# 1) Wiring up signals with everything.
# 2) Making the inventories actually appear in correct locations and look right
# 3) 

# on drag, do stuff
func handleDrag(invIndex : int, x : int, y : int):
	
	var inv = invHandler.Inventories[invIndex]
	
	dragData = inv.getItemByCoords(x, y, 0)
	print("drag data: " + str(x) + " " + str(y))
	dragPreviousLocation = inv.getItemByCoords(x, y, 1)
	
	dragShape = dragData.rotateGrid(int(dragPreviousLocation.z), 1)
	dragRotPos.x = x - dragPreviousLocation.x
	dragRotPos.y = y - dragPreviousLocation.y
	dragRotPos.z = dragPreviousLocation.z
	
	inv.removeItemByCoords(x, y)
	
	# create preview for drag data, this is assuming it is destroyed
	# after the drag ends, as specified in the docs
	dragPanelShape = Control.new()
	constructDragPreview()
	set_drag_preview(dragPanelShape)
	
	isDragging = true
	return 1

## Highlight the cells that would be affected by insertion.
## Do not care about this right now to be honest.
#func previewItemOutline(x: int, y: int):
	#pass
	#print("p( "+ str(x) + ", " + str(y)+ ")")

## The drag endpoint.
func insertItem(invIndex : int, x: int, y: int):
	
	var inv = invHandler.Inventories[invIndex]
	
	var xd = x - dragRotPos.x;
	var yd = y - dragRotPos.y;
	
	print("0( "+ str(xd) + ", " + str(yd)+ ")")
	
	var shape : gridShape = dragData.rotateGrid(dragRotPos.z, 1);
	var pShape = dragData.rotateGrid(dragPreviousLocation.z, 1)
	
	shape.printGrid()
	
	if inv.spaceCheck(xd, yd, shape) == 1:
		inv.addItem(xd, yd, dragRotPos.z, dragData)
	elif inv.spaceCheck(dragPreviousLocation.x, dragPreviousLocation.y, pShape) == 1:
		inv.addItem(dragPreviousLocation.x, dragPreviousLocation.y,
		dragPreviousLocation.z, dragData);
	else:
		#dropItemIntoWorld()
		pass;
	isDragging = false
	dragPanelShape = null

## Creates the control node that represents the drag preview.
func constructDragPreview():
	var xT = dragRotPos.x
	var yT = dragRotPos.y
	
	# clear all previous children, in case of rotating the shape
	for n in dragPanelShape.get_children():
			n.queue_free()
	
	for i in range(0, dragShape.Grid.size()):
		if dragShape.Grid[i]:
			var k : Panel = Panel.new()
			
			k.size = Vector2(cellSize,cellSize)
			var xy = dragShape.getGridCoords(i)
			k.position.x = ((xy[0] - xT) * cellSize) - (cellSize/2)
			k.position.y = ((xy[1] - yT) * cellSize) - (cellSize/2)
			
			dragPanelShape.add_child(k)
	


func dropItemIntoWorld(x : int, y : int):
	print(str(x) + ", " + str(y))

## reconfigure inventory ui based on the actual inventory's contents
#func refreshInventory():
	#for i in range(0,cellList.size()):
		#if INV_PATH.testInv.Grid[i]:
			#cellList[i].text = str(INV_PATH.testInv.Grid[i])
			#cellList[i].occupied = true
		#else:
			#cellList[i].text = ""
			#cellList[i].occupied = false

func close():
	
	pass

func _input(e: InputEvent):
	if e is InputEventMouseButton:
		if isDragging:
			# TODO: Bind SPACE to mirroring item.
			if e.button_index == MOUSE_BUTTON_WHEEL_UP and e.pressed:
				if dragRotPos.z & 4:
					dragRotPos.z = (dragRotPos.z & ~3) | ((dragRotPos.z - 1) & 3)
				else:
					dragRotPos.z = (dragRotPos.z & ~3) | ((dragRotPos.z + 1) & 3)
				var xy = dragShape.rotateCoords(dragRotPos.x,dragRotPos.y,1)
				dragRotPos.x = xy[0]
				dragRotPos.y = xy[1]
				dragShape.rotateGrid(1)
				constructDragPreview()
				print(str(dragRotPos.z))
				
			elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN and e.pressed:
				if dragRotPos.z & 4:
					dragRotPos.z = (dragRotPos.z & ~3) | ((dragRotPos.z + 1) & 3)
				else:
					dragRotPos.z = (dragRotPos.z & ~3) | ((dragRotPos.z - 1) & 3)
				var xy = dragShape.rotateCoords(dragRotPos.x,dragRotPos.y,3)
				dragRotPos.x = xy[0]
				dragRotPos.y = xy[1]
				dragShape.rotateGrid(3)
				constructDragPreview()
				print(str(dragRotPos.z))
			#elif e.button_index == KEY_SPACE and e.pressed:
				

func refreshAll():
	for i in invList:
		i.refreshInventory()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
