# Is there a reason to make this extend from Resource and not gridShape?
extends gridShape
## A class for containing the raw data (?) for items.
##
## Container for all the data needed to represent an item, such as it's Name,
## ID, Model.
class_name ItemData

## @experimental
## Don't know what this exactly does yet, but I'm thinking
## that some type of glossary, internal or external, could use this.
## Could also be used to quickly set up items, something like a prefab. [br]
## Feel free to remove this if this proves to be useless.
enum ITEMTYPE {
	SYRINGE,		## Syringe, potion-esque items.
	GUN,			## Gun type weapon.
	MELEE,			## Melee type weapon.
	KEY_LITERALLY,	## Keys for opening doors and locks.
	AMMO,			## Ammo for guns and stuff.
	
	OTHER,			## Miscellaneous items.
}

## ID of the item.
var ID : int;

## Name of item.
@export var ItemName : String
## The model of the item.
@export_file("*.tscn") var ItemModelPrefab : String

@export var Model : Mesh = null

# TODO: Make these variables changeable from the property editor.
# Do this via @tool and this link:
# (https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html)

## Type of item. (Ex: Syringe, Gun, Melee)
@export var Type : ITEMTYPE;
## Determines if an Item takes up space in inventory and can be dropped;
## essentially makes all inventory related variables moot. Feel free to remove
## this.
@export var IsKeyItem : bool;
## Grid representing the "shape" of the item in the inventory. The 1s create
## the actual shape of the item, and 0s are the empty space.	[br]
## 5x4 example (pickaxe):                      [br]
##       1 1 1 1 1                      [br]
##       0 0 1 0 0                      [br]
##       0 0 1 0 0                      [br]
##       0 0 1 0 0
# var Shape : gridShape = null;
## The weight of an Item, currently only to be used in inventory. We can drop
## this if we decide to not go through with weight. We can also change the type
## to INT if that would make calculations easier.
@export var Weight : float;
## Maximum items per stack. This is usally only 1 for things like weapons, and
## higher for things like ammo.
@export var MaxStack : int;
## Can this item be put in the pocket slots, is shown in the tooltip.
## Typically this would be true for small items, like a Syringe.
@export var canBePocket : bool;

func _init(id : int):
	# TODO: Later on, store this information in a file or something
	if id == 0:
		self.ID = id
		self.Width = 2
		self.Height = 5
		self.Grid = [1,1,
					 1,1,
					 0,1,
					 0,1,
					 0,1]
		self.ItemName = "Axe"
		self.Type = ITEMTYPE.MELEE
		self.Weight = 6
		self.MaxStack = 1
		self.IsKeyItem = false
		self.canBePocket = false
	else:
		printerr("ID does not point to an existing item.")
	
	# Generate model if no model for the item exists.
	if Model == null:
		createModel()
	
	


# TODO: This function is not done yet, as it does not adjust the underlying
# shape properly, all it does is change the Width and Height variables.
# TODO: Move this to gridShape.gd
## Function to be called when changing the size of an item in the properties
## menu. Any new cells/indexes created should be set to 0. Width and Height
## should never go below 1.                 [br]
## Returns 0, -1, -2, or -3 depending on if any size changes went out of bounds:
## 0 for none, -1 for Width, -2 for Height, -3 for both.
func adjustSize(widthChange : int = 0, heightChange : int = 0):
	var rVal = 0;
	
	if (self.Width + widthChange < 1):
		self.Width = 1;
		rVal -= 1;
	else:
		self.Width += widthChange;
	
	if (self.Height + heightChange < 1):
		self.Height = 1;
		rVal -= 2;
	else:
		self.Height += heightChange;
	
	return rVal;
	

# TODO: Fix the color not appearing on the mesh.

## Procedurally create model if the item doesn't have one. [Color] is the
## color of the model, it defaults to an opaque grey color. [br]
## Creates unneccessary triangles, but because this is a debugging/beta function,
## it doesn't really matter.
func createModel(surfaceColor: Color = Color(0.814, 0.0, 0.578, 1.0)):
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)

	# PackedVector**Arrays for mesh construction.
	var verts = PackedVector3Array()
	var colors = PackedColorArray()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var x 
	var y
	var i = 0
	var scale : float = 0.25
	
	var vecs = [
		Vector3.LEFT,
		Vector3.RIGHT,
		Vector3.UP,
		Vector3.DOWN,
		Vector3.FORWARD,
		Vector3.BACK,
	]
	
	var position = 0
	
	var gridSize = self.Grid.size()
	
	# keep this as a while loop
	while i < gridSize:
		if(self.Grid[i] == 1):
			var xy = self.getGridCoords(i)
			x = xy[0]
			y = xy[1]
			
			var newVerts = [
				Vector3(0+x, 0+y, 0), Vector3(1+x, 0+y, 0), 
				Vector3(0+x, 1+y, 0), Vector3(1+x, 1+y, 0), 
				
				Vector3(0+x, 0+y, 1), Vector3(1+x, 0+y, 1), 
				Vector3(0+x, 1+y, 1), Vector3(1+x, 1+y, 1), 
			]
			
			for v in range(0,newVerts.size()):
				newVerts[v].z -= 0.5
				newVerts[v].y -= self.Height/2.0
				newVerts[v].x -= self.Width/2.0
				newVerts[v] *= scale
			
			
			
			# Create data for faces.
			for v in range(0,vecs.size()/2):
				var o1 = []
				var o2 = []
				var r = range(0,8)
				verts.append_array(newVerts)
				for k in r:
					colors.append(surfaceColor)
					if k & (1<<v) == 0:
						normals.append(vecs[v*2])
						o1.append(k+position)
					else:
						normals.append(vecs[(v*2)+1])
						o2.append(k+position)
						
				var k
				if (v & 1):
					k = [ o1[2], o1[1], o1[0],   o1[2], o1[3], o1[1],
						  o2[0], o2[1], o2[2],   o2[1], o2[3], o2[2],]
				else:
					k = [ o1[0], o1[1], o1[2],   o1[1], o1[3], o1[2],
						  o2[2], o2[1], o2[0],   o2[2], o2[3], o2[1],]
				indices.append_array(k)
				
				position = verts.size()
				
				#print(o1)
				#print(o2)
				#print(k)
				#print("===")
			#print(verts)
			#print(indices)
				
		i += 1
	
	#print(verts.size())
	#print(indices.size())
	# Assign arrays to surface array.
	surface_array[Mesh.ARRAY_VERTEX] = verts
	surface_array[Mesh.ARRAY_COLOR] = colors
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	
	
	
	var m : ArrayMesh = ArrayMesh.new()
	m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	var mat : StandardMaterial3D = StandardMaterial3D.new()
	
	mat.albedo_color = surfaceColor
	
	print(mat.albedo_color)
	m.surface_set_material(0,mat)
	#m.set_surface_override_material(surfi, mat)
	# Create mesh surface from mesh array.
	self.Model = m
	
	return 1

















# just some blank space so i can scroll down in the editor, please dont remove #
