extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# DASH SETTINGS
const DASH_SPEED = 700.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 0.5

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 1

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	# Cooldown timer
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Start dash
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer = DASH_COOLDOWN

		
		dash_direction = Input.get_axis("ui_left", "ui_right")
		if dash_direction == 0:
			dash_direction = -1 if $AnimatedSprite2D.flip_h else 1

	
	if is_dashing:
		dash_timer -= delta

		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  

		if dash_timer <= 0:
			is_dashing = false
	
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
	

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/3)
	
		if velocity.y < 0 :
			$AnimatedSprite2D.animation="jump"
		elif velocity.y > 0:
			$AnimatedSprite2D.animation = "fall"
	
	
		elif is_on_floor() and direction:
			$AnimatedSprite2D.animation="walk"
		else:
			$AnimatedSprite2D.animation="idle"
	
		if direction:
			$AnimatedSprite2D.flip_h = direction < 0
	move_and_slide()
