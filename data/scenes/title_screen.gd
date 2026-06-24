extends Control

# Match these names exactly to your Scene Tree!
@onready var video_player = $VideoStreamPlayer
@onready var button_container = $HBoxContainer 
@onready var play_btn = $HBoxContainer/PlayButton
@onready var quit_btn = $HBoxContainer/QuitButton

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# 1. Setup button logic
	play_btn.pressed.connect(start_game)
	quit_btn.pressed.connect(quit_game)

	# 2. Wait for the window, then play video
	await get_tree().create_timer(0.5).timeout
	video_player.play()
	
	# 3. The Magic Fade: Wait 5 seconds, then fade in buttons
	await get_tree().create_timer(5.0).timeout
	
	# Create a tween to animate the transparency (modulate:a)
	var tween = create_tween()
	# Transition from Alpha 0 to Alpha 1 over 1.5 seconds
	tween.tween_property(button_container, "modulate:a", 1.0, 1.5)

func start_game():
	get_tree().change_scene_to_file("res://data/scenes/mainscene.tscn")

func quit_game():
	get_tree().quit()
