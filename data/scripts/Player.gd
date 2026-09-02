extends CharacterBody3D

var speed = 0
const WALK_SPEED = 3.0
const SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 4.8
const SENSITIVITY = 0.0015

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var foot_cast = $FootCast
@onready var foostep = $AudioStreamPlayer3D
@onready var ui_manager = $"../UIManager"
@onready var interaction_ray = $Head/InteractionRay

var footstep_sounds = [
	preload("res://data/sfx/footstep1.wav"),
	preload("res://data/sfx/footstep2.wav"),
	preload("res://data/sfx/footstep3.wav")
]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var _comment = "
	interaction_ray.global_rotation[0] = head.global_rotation[1]
	interaction_ray.global_rotation[1] = head.global_rotation[2]
	interaction_ray.global_rotation[2] = head.global_rotation[0]
	#"
		
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# If any menu is open, disable camera movement.
		# (MenuState.NONE == 0) because enums are secretly ints that count up from 0
		if ui_manager.current_menu_state == 0: 
			self.rotate_y(-event.relative.x * SENSITIVITY)
			head.rotate_x(-event.relative.y * SENSITIVITY)
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			var _comment2 = "
			print('=====')
			print(camera.global_rotation)
			print(interaction_ray.global_rotation)
			print(head.global_rotation)
			#"


func _physics_process(delta):
	var direction
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# If any menu is open, disable player movement.
	if ui_manager.current_menu_state == 0:
		# Handle Jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# Handle Sprint.
		if Input.is_action_pressed("sprint"):
			speed = SPRINT_SPEED
		else:
			speed = WALK_SPEED
		
		# Get the input direction and handle the movement/deceleration.
		var input_dir = Input.get_vector("left", "right", "up", "down")
		direction = (self.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		#direction = (self.transform.basis * transform.basis * Vector3(0,0,0)).normalized()
		direction = (self.transform.basis * Vector3(0,0,0)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()
	
	# Detect surface and play sound
	if is_on_floor() and direction.length() > 0:
		# Check if we are at the right point in the bob cycle (approx top/bottom)
		# Using a simple check to trigger only when the bob hits the peak
		if sin(t_bob * BOB_FREQ) > 0.95 and $AudioStreamPlayer3D.playing == false:
			play_footstep()

func play_footstep():
	var surface = foot_cast.get_collider()
	# Grab a random sound from the array
	$AudioStreamPlayer3D.volume_db = -20.0
	$AudioStreamPlayer3D.stream = footstep_sounds.pick_random()
	
	# Optional: randomize pitch slightly for variety
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.9, 1.1)
	
	$AudioStreamPlayer3D.play()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
