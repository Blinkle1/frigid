extends RigidBody3D
class_name InteractableItem

@export var ItemHighlightMesh : MeshInstance3D
@export var ItemHighlightMesh2 : MeshInstance3D
@export var item_data : ItemData
@onready var tooltip = $Label3D

func _ready():
	if tooltip:
		tooltip.visible = false
	else:
		push_error("BRO! I cannot find the Label3D node!")

func _on_interaction_area_body_entered(body):
	print("Collision detected with: ", body.name, " (Type: ", body.get_class(), ")")
	# This will print the exact name of whatever touches the axe to your console
	print("Something touched the axe! It is named: ", body.name)
	
	if body.name == "CharacterBody3D": 
		tooltip.visible = true

func _on_interaction_area_body_exited(body):
	if body.name == "CharacterBody3D":
		tooltip.visible = false

func GainFocus():
	ItemHighlightMesh.visible = true
	tooltip.visible = true

func LoseFocus():
	ItemHighlightMesh.visible = false
	tooltip.visible = false
