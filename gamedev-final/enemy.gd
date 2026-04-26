extends CharacterBody2D

const SPEED = 100.0
var direction = 1
var can_turn = true

@onready var ray = $RayCast2D

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	ray.target_position = Vector2(direction * 30, 40)

	if can_turn and (is_on_wall() or not ray.is_colliding()):
		direction *= -1
		can_turn = false
		get_tree().create_timer(0.2).timeout.connect(func(): can_turn = true)

	velocity.x = direction * SPEED
	move_and_slide()

	$AnimatedSprite2D.flip_h = direction < 0

# Called by the full-body Area2D - damage only
func _on_area_2d_body_entered(body):
	if not body.has_method("take_damage"):
		return
	if not body.invincible:
		body.take_damage(1)

# Called by the StompArea on top - stomp only
func _on_stomp_area_body_entered(body):
	if not body.has_method("take_damage"):
		return
	if body.velocity.y > 0:
		body.velocity.y = -300.0
		queue_free()
