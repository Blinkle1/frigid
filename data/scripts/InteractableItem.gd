# Set as @tool so procedurally generated models actually appear in
# the editor.
# TODO: There's an error here regarding pathing of nodes? Something to do with:
# 1. the @tool tag and: 2. _process() creating a new ItemData instance. I do not
# know what this error really means, but I would prefer it be fixed now than
# leaving it to fester in future builds.
@tool
extends RigidBody3D

class_name InteractableItem

var item_data : ItemData = null
@onready var tooltip = $Label3D
@onready var mesh : MeshInstance3D = $Mesh
@onready var collide : CollisionShape3D = $Collision
# May need to change if the item's model has several types of materials. 
var mater : Material
var test : int = 0
var debug = true
@export var debugID : int = 0;


func _ready():
	
	if debug:
		item_data = ItemData.new(debugID)
	mesh.mesh = item_data.Model;
	
	collide.make_convex_from_siblings()
	
	# May need to change if model has multiple materials associated with it.
	mater = mesh.mesh.surface_get_material(0)
	
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

# TODO: Make focused item additionally have an animation when focused, like
# an enchanted item in minecraft: makes it easier to see what is highlighted.

func GainFocus():
	var m : Material = mater.duplicate()
	#m.albedo_color = Color.WHITE
	m.emission = Color(0.5,0.5,0.5,1)
	m.emission_enabled = true
	
	mesh.mesh.surface_set_material(0, m)
	tooltip.visible = true

func LoseFocus():
	mesh.mesh.surface_set_material(0, mater)
	#ItemHighlightMesh.visible = false
	tooltip.visible = false

func _process(_delta):
	# This runs if godot is in editor mode
	if Engine.is_editor_hint():
		#
		if item_data == null:
			item_data = ItemData.new(0)
			print("1")
		else:
			pass
			#item_data.get_path()
