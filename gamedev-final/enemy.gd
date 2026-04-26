extends CharacterBody2D

const SPEED = 100.0
var direction = -1

@onready var ray = $RayCast2D

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	ray.target_position = Vector2(direction * 60, 80)
	
	if is_on_wall() or not ray.is_colliding():
		direction *= -1
		velocity.x = direction * SPEED

	move_and_slide()
	
	$AnimatedSprite2D.flip_h = direction < 0

func _on_area_2d_body_entered(body):
	if not body.has_method("take_damage"):
		return

	# Check if player is falling and above the enemy (stomp)
	if body.velocity.y > 0:
		# Stomped! Kill the enemy
		body.velocity.y = -300.0  # bounce the player up
		queue_free()
	elif not body.invincible:
		body.take_damage(1)
