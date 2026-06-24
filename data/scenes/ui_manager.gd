extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var map_ui = $MapUI
@onready var resume_btn = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_btn = $PauseMenu/VBoxContainer/QuitButton

func _ready():
	# Hook up the button clicks automatically
	resume_btn.pressed.connect(toggle_pause)
	quit_btn.pressed.connect(quit_game)

func _input(event):
	# Handle Pause
	if event.is_action_pressed("pause"):
		toggle_pause()
		
	# Handle Map (Only allow opening map if game ISN'T paused)
	elif event.is_action_pressed("map") and not get_tree().paused:
		map_ui.visible = !map_ui.visible

func toggle_pause():
	# Flip the current pause state
	var is_paused = !get_tree().paused
	get_tree().paused = is_paused
	pause_menu.visible = is_paused
	
	# Close map if we pause while it's open
	if is_paused:
		map_ui.visible = false
	
	# Handle the mouse cursor
	if is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func quit_game():
	get_tree().quit()
