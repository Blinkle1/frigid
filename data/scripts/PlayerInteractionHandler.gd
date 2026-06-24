extends Area3D


signal OnItemPickedUp(item)

@export var ItemTypes : Array[ItemData] = []

var NearbyBodies : Array[InteractableItem]


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		print("INTERACT PRESSED! Items nearby: ", NearbyBodies.size())
		PickupNearestItem()
		
func PickupNearestItem():
	if NearbyBodies.is_empty(): return
	
	var nearestItem : InteractableItem = null
	var nearestItemDistance : float = INF
	
	for item in NearbyBodies:
		var dist = item.global_position.distance_to(global_position)
		if dist < nearestItemDistance:
			nearestItemDistance = dist
			nearestItem = item
			
	if nearestItem != null:
		
		if nearestItem.item_data != null:
			print("Picked up: ", nearestItem.item_data.ItemName)
			OnItemPickedUp.emit(nearestItem.item_data)
			nearestItem.queue_free()
			NearbyBodies.remove_at(NearbyBodies.find(nearestItem))
		else:
			printerr("Bro, you forgot to drag Axe_Data.tres into the floor item!")

func OnObjectEnteredArea(body: Node3D):
	print("Something entered: ", body.name)
	if (body is InteractableItem):
		body.GainFocus()
		NearbyBodies.append(body)

func OnObjectExitedArea(body: Node3D):
	if (body is InteractableItem and NearbyBodies.has(body)):
		body.LoseFocus()
		NearbyBodies.remove_at(NearbyBodies.find(body))
