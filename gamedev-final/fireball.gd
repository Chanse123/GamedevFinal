extends Area2D
class_name Fireball

@export var speed := 450.0
@export var lifetime := 3.0

var direction := Vector2.RIGHT
@onready var anim: AnimatedSprite2D = $Anim
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("projectile")
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	if anim.sprite_frames and anim.sprite_frames.has_animation("fly"):
		anim.play("fly")
	else:
		anim.play() # plays default animation if you set one
		
	body_entered.connect(func(body: Node) -> void:
		if body.is_in_group("player") and body.has_method("take_projectile_hit"):
			body.take_projectile_hit(self, direction.x)
			return
		queue_free()
	)
	if has_node("VisibleOnScreenNotifier2D"):
		$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
