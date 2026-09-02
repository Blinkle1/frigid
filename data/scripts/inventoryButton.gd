extends Button
class_name InventoryButton

signal inventoryPressed(x : int, y : int)

var x : int
var y : int


func _pressed():
	inventoryPressed.emit(x, y)
