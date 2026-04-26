extends Area2D
class_name Fireball

@export var speed := 450.0
@export var lifetime := 3.0

var direction := Vector2.RIGHT
@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	add_to_group("projectile")
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	
	if direction.x < 0:
		$Anim.flip_h = true
	
	if anim.sprite_frames and anim.sprite_frames.has_animation("fly"):
		anim.play("fly")
	else:
		anim.play()
		
	body_entered.connect(func(body: Node) -> void:
		if body.is_in_group("player") and body.has_method("take_projectile_hit"):
			body.take_projectile_hit(self, direction.x)
			return
		queue_free()
	)
	if has_node("VisibleOnScreenNotifier2D"):
		$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	# Ignore the enemy that shot this
	if body.is_in_group("enemy_shooter"):
		return
	# Ignore other projectiles
	if body.is_in_group("projectile"):
		return
	# Hit player
	if body.is_in_group("player") and body.has_method("take_projectile_hit"):
		body.take_projectile_hit(self, direction.x)
		return
	# Hit anything else (walls, terrain)
	queue_free()
