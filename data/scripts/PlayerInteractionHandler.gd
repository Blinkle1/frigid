extends RayCast3D
# The thing that allows you to pick up items.


# This requires Collision Masks 1 and 2 to properly function, 1 is for world
# geometry and obstacles, 2 is for the items.

signal OnItemPickedUp(item)

# for things like buttons/doors/levers
signal onInteraction(object)

signal onNewSelectedItem(prev, new)

#@export var focusedItem : Node

## The interactable you were looking at in the previous frame.
var currentInteractable = null;

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact")):
		print("INTERACT PRESSED!");
		if (currentInteractable == null):
			print("No interactable selected.")
		else:
			print("Item: ", currentInteractable)
			PickupItem(currentInteractable)


# Do not remove this function, even if items are the only interactable things.
func PickupItem(focusedItem):
	if focusedItem == null:
		return
	if focusedItem is InteractableItem:
		print("Picked up: ", focusedItem.item_data.ItemName)
		OnItemPickedUp.emit(focusedItem)
	else:
		print(focusedItem.get_class())
		printerr("Bro, you forgot to drag Axe_Data.tres into the floor item!")

# If ray is over an item, give it focus, else, lose focus on the item.
func _physics_process(delta) -> void:
	if not is_colliding():
		if currentInteractable != null:
			currentInteractable.LoseFocus()
			currentInteractable = null;
	else:
		var k : Node = get_collider()
		if (currentInteractable != k) and (k is InteractableItem):
			
			if (currentInteractable != null):
				currentInteractable.LoseFocus()
			k.GainFocus()
			currentInteractable = k;
		elif (currentInteractable != null) and (k is not InteractableItem):
				currentInteractable.LoseFocus()
				currentInteractable = null
	
	
	





# space #
