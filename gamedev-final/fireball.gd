extends Area2D
class_name Fireball

@export var speed := 450.0
@export var lifetime := 3.0

var direction := Vector2.RIGHT
@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	add_to_group("projectile")

	if anim.sprite_frames and anim.sprite_frames.has_animation("fly"):
		anim.play("fly")
	elif anim.sprite_frames:
		anim.play()

	# Only one body_entered connection here - remove the editor connection too
	body_entered.connect(_on_body_entered)

	if has_node("VisibleOnScreenNotifier2D"):
		$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

	get_tree().create_timer(lifetime).timeout.connect(queue_free)

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
