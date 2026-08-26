extends Node
class_name InventoryHandler

@export var PlayerBody : CharacterBody3D
@export_flags_3d_physics var CollisionMask : int
@export var ItemSlotsCount : int = 4
@export var InventoryGrid : GridContainer
@export var InventorySlotPrefab : PackedScene = preload("res://data/inventory/InventorySlot.tscn")
@export var axe_in_hand : Node3D
@export var AxeAnimator : AnimationPlayer

var InventorySlots : Array[InventorySlot] = []
var EquippedSlot : int = -1

## All the Spacial Inventories the player has.
var Inventories : Array[SpacialInventory] = [];

@export var testInv : SpacialInventory;


func _ready():
	for i in ItemSlotsCount:
		var slot = InventorySlotPrefab.instantiate() as InventorySlot
		InventoryGrid.add_child(slot)
		slot.InventorySlotID = i
		slot.OnItemDropped.connect(ItemDroppedOnSlot.bind())
		slot.OnItemEquiped.connect(ItemEquipped.bind())
		InventorySlots.append(slot)
	
	self.testInv = SpacialInventory.new(7, 8);

func PickupItem(item : ItemData):
	var foundSlot : bool = false
	for slot in InventorySlots:
		if (!slot.SlotFilled):
			slot.FillSlot(item, false)
			foundSlot = true
			ItemEquipped(slot.InventorySlotID) 
			break
	
	# If inventory is full, drop the item we just tried to pick up
	if (!foundSlot):
		var dropped_item = load(item.ItemModelPrefab).instantiate() as Node3D
		PlayerBody.get_parent().add_child(dropped_item)
		dropped_item.global_position = GetDropPosition()

func ItemEquipped(slotID : int):
	if (EquippedSlot != -1):
		InventorySlots[EquippedSlot].FillSlot(InventorySlots[EquippedSlot].SlotData, false)
	
	if (slotID != EquippedSlot && InventorySlots[slotID].SlotData != null):
		InventorySlots[slotID].FillSlot(InventorySlots[slotID].SlotData, true)
		EquippedSlot = slotID
		axe_in_hand.visible = true
	else:
		EquippedSlot = -1
		axe_in_hand.visible = false

func ItemDroppedOnSlot(fromSlotID : int, toSlotID : int):
	if EquippedSlot != -1:
		if EquippedSlot == fromSlotID:
			EquippedSlot = toSlotID
		elif EquippedSlot == toSlotID:
			EquippedSlot = fromSlotID
	
	var toSlotItem = InventorySlots[toSlotID].SlotData
	var fromSlotItem = InventorySlots[fromSlotID].SlotData
	
	InventorySlots[toSlotID].FillSlot(fromSlotItem, EquippedSlot == toSlotID)
	InventorySlots[fromSlotID].FillSlot(toSlotItem, EquippedSlot == fromSlotID)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drop") and EquippedSlot != -1:
		var itemToDrop = InventorySlots[EquippedSlot].SlotData
		
		var newItem = load(itemToDrop.ItemModelPrefab).instantiate() as Node3D
		PlayerBody.get_parent().add_child(newItem)
		
		# Spawn exactly in the 3D center of the camera
		newItem.global_position = GetDropPosition()
		
		InventorySlots[EquippedSlot].FillSlot(null, false)
		axe_in_hand.visible = false
		EquippedSlot = -1
	elif event.is_action_pressed("attack") and EquippedSlot != -1:
		if not AxeAnimator.is_playing():
			AxeAnimator.play("swing")

func GetDropPosition() -> Vector3:
	var cam = get_viewport().get_camera_3d()
	
	# Pure 3D math: Start exactly at the camera lens
	var ray_start = cam.global_position
	
	# Shoot exactly 3 meters mathematically straight forward in the 3D world
	var ray_end = ray_start + (-cam.global_transform.basis.z * 2.0) 
	
	var space_state = PlayerBody.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, CollisionMask)
	
	# Ignore the player's own body so we don't hit ourselves
	query.exclude = [PlayerBody.get_rid()]
	
	var result = space_state.intersect_ray(query)
	
	if result:
		# Hit a wall/floor? Spawn right there, bumped up slightly
		return result["position"] + Vector3(0, 0.2, 0)
	else:
		# Hit nothing? Spawn in empty air exactly in front of the camera
		return ray_end

func _on_interaction_ray_on_item_picked_up(item: Variant) -> void:
	PickupItem(item)

func addInventory(width : int, height : int):
	Inventories.append(SpacialInventory.new(width, height));










#
