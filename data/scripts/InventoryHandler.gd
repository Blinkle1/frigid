extends Node
class_name InventoryHandler

#@export var PlayerBody : CharacterBody3D
#@export_flags_3d_physics var CollisionMask : int
#@export var ItemSlotsCount : int = 4
#@export var InventoryGrid : GridContainer
#@export var InventorySlotPrefab : PackedScene = preload("res://data/inventory/InventorySlot.tscn")
#@export var axe_in_hand : Node3D
#@export var AxeAnimator : AnimationPlayer
#
#var InventorySlots : Array[InventorySlot] = []
#var EquippedSlot : int = -1

## Stuff that is held in David's hands.
var hands : Array[InteractableItem] = []
## All the Spacial Inventories the player has.
var inventories : Array[SpacialInventory] = [];

var testInv : SpacialInventory;

@export var inventoryCount : int = 2

func _ready():
	for n in range(0,inventoryCount):
		var k = Global.DEFAULTS.data.inventories[n]
		var inv = SpacialInventory.new(k.Width, k.Height)
		inv.ItemLimit = k.ItemLimit;
		inv.EnableItemLimit = k.EnableItemLimit;
		inv.WeightLimit = k.WeightLimit;
		inv.CountOnlyUniqueItems = k.CountOnlyUniqueItems;
		
		inventories.append(inv)
	Global.G_INVENTORYHANDLER = self

# If this function is slow, it should swap algorithms depending on the number
# of empty cells. The higher the number of empty cells the better the below
# algorithm works. With lower numbers of empty cells, this should instead
# search for empty cells.

## Place an item into a random spot in the inventory.
func PickupItem(item : ItemData):
	
	
	var width = range(0, inventories[0].Width)
	var height = range(0,inventories[0].Height)
	
	var rotationList = range(0,8)
	
	seed(1)
	rotationList.shuffle()
	width.shuffle()
	height.shuffle()
	var broke = false
	var shape
	#shape = item.rotateGrid(0, 1);
	#print(shape.Width)
	#return 0
	
	# given each cell and each possible rotation, find a valid spot
	for x in width:
		for y in height:
			for r in rotationList:
				shape = item.rotateGrid(r, 1);
				if inventories[0].spaceCheck(x, y, shape) == 1:
					#print(str(x), str(y), str(r))
					inventories[0].addItem(x, y, r, item)
					broke = true
					break
				else:
					pass#print(str(x) + str(y) + str(testInv.spaceCheck(x, y, shape)))
			if broke:
				break
		if broke:
			break
	
	
	if broke:
		#testInv.printGrid()
		return 1
	else:
		return 0

#func ItemEquipped(slotID : int):
	#if (EquippedSlot != -1):
		#InventorySlots[EquippedSlot].FillSlot(InventorySlots[EquippedSlot].SlotData, false)
	#
	#if (slotID != EquippedSlot && InventorySlots[slotID].SlotData != null):
		#InventorySlots[slotID].FillSlot(InventorySlots[slotID].SlotData, true)
		#EquippedSlot = slotID
		#axe_in_hand.visible = true
	#else:
		#EquippedSlot = -1
		#axe_in_hand.visible = false


## Create an Interactable Item
func createInteractableItem():
	
	return 0
	

func getItem(invIndex : int, x : int, y : int):
	return inventories[invIndex].getItemByCoords(x, y)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("drop") and EquippedSlot != -1:
		#var itemToDrop = InventorySlots[EquippedSlot].SlotData
		#
		#var newItem = load(itemToDrop.ItemModelPrefab).instantiate() as Node3D
		#PlayerBody.get_parent().add_child(newItem)
		#
		## Spawn exactly in the 3D center of the camera
		#newItem.global_position = GetDropPosition()
		#
		#InventorySlots[EquippedSlot].FillSlot(null, false)
		#axe_in_hand.visible = false
		#EquippedSlot = -1
	#elif event.is_action_pressed("attack") and EquippedSlot != -1:
		#if not AxeAnimator.is_playing():
			#AxeAnimator.play("swing")

#func GetDropPosition() -> Vector3:
	#var cam = get_viewport().get_camera_3d()
	#
	## Pure 3D math: Start exactly at the camera lens
	#var ray_start = cam.global_position
	#
	## Shoot exactly 3 meters mathematically straight forward in the 3D world
	#var ray_end = ray_start + (-cam.global_transform.basis.z * 2.0) 
	#
	#var space_state = PlayerBody.get_world_3d().direct_space_state
	#var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, CollisionMask)
	#
	## Ignore the player's own body so we don't hit ourselves
	#query.exclude = [PlayerBody.get_rid()]
	#
	#var result = space_state.intersect_ray(query)
	#
	#if result:
		## Hit a wall/floor? Spawn right there, bumped up slightly
		#return result["position"] + Vector3(0, 0.2, 0)
	#else:
		## Hit nothing? Spawn in empty air exactly in front of the camera
		#return ray_end

func _on_interaction_ray_on_item_picked_up(item: Variant) -> void:
	
	#for x in range(0,8):
		#var test : gridShape = gridShape.new(2,4)
		#test.Grid = [0,1,2,3,4,5,6,7]#[1,1,1,1,0,1,0,1]
		#test.rotateGrid(x,0)
		#print("\n=" + str(x) + "=")
		#test.printGrid()
		#
	#
	#return
	
	if (PickupItem(item.item_data)):
		item.queue_free()
	else:
		print("penis")

func addInventory(width : int, height : int):
	inventories.append(SpacialInventory.new(width, height));










#
