extends Button
class_name InventoryButton

signal drag_start(x : int, y : int)
signal drag_end(x : int, y : int)
signal hovered(x : int, y : int)

var x : int
var y : int

var occupied : bool

func _pressed():
	pressed.emit(x, y)

func _button_down():
	pass

func _get_drag_data(_at_position):
	if !self.occupied:
		return null
	
	drag_start.emit(x, y)
	
	
	return 1

func _can_drop_data(_at_position, _data):
	hovered.emit(x,y)
	return 1
	
func _drop_data(_at_position, _data):
	drag_end.emit(x,y)
