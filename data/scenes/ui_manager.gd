extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var settings_menu = $SettingsMenu
@onready var map_ui = $MapUI
@onready var resume_btn = $PauseMenu/VBoxContainer/ResumeButton
@onready var settings_btn = $PauseMenu/VBoxContainer/SettingsButton
@onready var quit_btn = $PauseMenu/VBoxContainer/QuitButton
@onready var masteraudioslider = $SettingsMenu/VBoxContainer/MasterAudioSlider
@onready var res_btn = $SettingsMenu/VBoxContainer/ResolutionButton
@onready var fullscreen_btn = $SettingsMenu/VBoxContainer/FullscreenButton
@onready var back_btn = $SettingsMenu/BackButton

enum MenuState { NONE, PAUSE, SETTINGS, MAP }
var current_menu_state = MenuState.NONE
var previous_state = MenuState.NONE

func _ready():
	# Route all button clicks through the state handler
	resume_btn.pressed.connect(func(): change_menu(MenuState.NONE))
	settings_btn.pressed.connect(func(): change_menu(MenuState.SETTINGS))
	back_btn.pressed.connect(go_back)
	quit_btn.pressed.connect(quit_game)
	
	masteraudioslider.value_changed.connect(_on_master_volume_changed)
	res_btn.item_selected.connect(_on_resolution_changed)
	fullscreen_btn.item_selected.connect(_on_screen_mode_changed)
	
	res_btn.add_item("1920x1080")
	res_btn.add_item("1280x720")
	
	fullscreen_btn.add_item("Windowed")
	fullscreen_btn.add_item("Fullscreen")
	fullscreen_btn.add_item("Borderless")

func change_menu(new_state):
	# 1. Update the tracking variable
	previous_state = current_menu_state
	current_menu_state = new_state
	
	# 2. Toggle visibility based on state
	pause_menu.visible = (current_menu_state == MenuState.PAUSE)
	settings_menu.visible = (current_menu_state == MenuState.SETTINGS)
	map_ui.visible = (current_menu_state == MenuState.MAP)
	
	# 3. Handle Game/Mouse state
	if current_menu_state == MenuState.NONE:
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
func go_back():
	change_menu(previous_state)

func toggle_pause():
	if current_menu_state == MenuState.PAUSE:
		change_menu(MenuState.NONE)
	else:
		change_menu(MenuState.PAUSE)

func _input(event):
	# Handle Pause
	if event.is_action_pressed("pause"):
		toggle_pause()
		
	# Handle Map 
	elif event.is_action_pressed("map"):
		if current_menu_state == MenuState.NONE:
			change_menu(MenuState.MAP)
		elif current_menu_state == MenuState.MAP:
			change_menu(MenuState.NONE)

func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100))
	
func _on_resolution_changed(index):
	match index:
		0: get_window().size = Vector2i(1920, 1080)
		1: get_window().size = Vector2i(1280, 720)

func _on_screen_mode_changed(index):
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func quit_game():
	get_tree().quit()
