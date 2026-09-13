@tool
extends RigidBody3D
class_name InteractableItem
# todo: remove this todo
@export var ItemHighlightMesh : MeshInstance3D
@export var ItemHighlightMesh2 : MeshInstance3D
@export var item_data : ItemData = null
@onready var tooltip = $Label3D

var debug = true

func _ready():
	
	
	if debug:
		item_data = ItemData.new(0)
	var m : MeshInstance3D = MeshInstance3D.new()
	m.mesh = item_data.Model;
	self.add_child(m)
	
	var c : CollisionShape3D = CollisionShape3D.new()
	self.add_child(c)
	c.make_convex_from_siblings()
	
	
	
	if tooltip:
		tooltip.visible = false
	else:
		push_error("BRO! I cannot find the Label3D node!")
	

func _on_interaction_area_body_entered(body):
	#print("Collision detected with: ", body.name, " (Type: ", body.get_class(), ")")
	# This will print the exact name of whatever touches the axe to your console
	# print("Something touched the axe! It is named: ", body.name)
	
	if body.name == "CharacterBody3D": 
		tooltip.visible = true

func _on_interaction_area_body_exited(body):
	if body.name == "CharacterBody3D":
		tooltip.visible = false

func GainFocus():
	#ItemHighlightMesh.visible = true
	tooltip.visible = true

func LoseFocus():
	#ItemHighlightMesh.visible = false
	tooltip.visible = false

func _process(delta):
	# This runs if godot is in editor mode
	if Engine.is_editor_hint():
		if item_data == null:
			item_data = ItemData.new(0)
