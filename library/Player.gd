extends CharacterBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var coyoteFrames = 6
var coyote = false
var lastFloor = false

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$CoyoteTimer.wait_time = coyoteFrames / 60.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	lastFloor = is_on_floor()


func _process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if velocity.y < 0: # Jump animation
		sprite.play("Jump")
	
	elif velocity.y > 0: # Falling animation
		sprite.play("Falling")
		
	elif direction == 1 and Input.is_action_pressed("ui_down"): # Crouch walk animation Right
		sprite.play("CrouchWalk")
		sprite.flip_h = false
	
	elif direction == -1 and Input.is_action_pressed("ui_down"): # Crouch walk animation Left
		sprite.play("CrouchWalk")
		sprite.flip_h = true
		
	elif direction == 1: # Run animation Right
		sprite.play("Run")
		sprite.flip_h = false
	
	elif direction == -1: # Run animation Left
		sprite.play("Run")
		sprite.flip_h = true
		
	elif Input.is_action_just_pressed("ui_down"):
		sprite.play("CrouchTransition")
		
	elif Input.is_action_pressed("ui_down"): # Crouch
		sprite.play("Crouch") 
			
	else: # Idle
		sprite.play("Idle")
		
