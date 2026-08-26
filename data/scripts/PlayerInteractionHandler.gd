extends RayCast3D
# The thing that allows you to pick up items.


# This requires Collision Masks 1 and 2 to properly function, 1 is for world
# geometry and obstacles, 2 is for the items.

signal OnItemPickedUp(item)

# for things like buttons/doors/levers
signal onInteraction(object)

signal onNewSelectedItem(prev, new)

#@export var focusedItem : Node

# to keep this applicable to not just items but things like doors and buttons,
# just gonne keep this as Node until a proper class is created
var lastInteractable = null;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		print("INTERACT PRESSED!");
		if (lastInteractable == null):
			print("No interactable selected.")
		else:
			print("Item: ", lastInteractable)
			PickupItem(lastInteractable)


# Do not remove this function, even if items are the only interactable things.
func PickupItem(focusedItem):
	if focusedItem == null:
		return
		
	if focusedItem.item_data != null:
		print("Picked up: ", focusedItem.item_data.ItemName)
		OnItemPickedUp.emit(focusedItem.item_data)
		focusedItem.queue_free()
	else:
		printerr("Bro, you forgot to drag Axe_Data.tres into the floor item!")

# tl;dr: If ray is over an item, give it focus, else, lose focus on the item.
func _physics_process(delta) -> void:
	if not is_colliding():
		if lastInteractable != null:
			lastInteractable.LoseFocus()
			lastInteractable = null;
	elif is_colliding():
		var k : Node = get_collider()
		if (lastInteractable != k) and (k is InteractableItem):
			# i'm checking for pestilence
			# print("found one")
			k.GainFocus()
			lastInteractable = k;
		elif (lastInteractable != null) and (k is not InteractableItem):
				lastInteractable.LoseFocus()
				lastInteractable = null
	
	
	





# space #
