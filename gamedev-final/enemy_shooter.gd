extends CharacterBody2D
class_name EnemyShooter

@export var move_speed := 80.0
@export var gravity := 1100.0

@export var fireball_scene: PackedScene
@export var shoot_interval := 1.2
@export var fireball_speed := 450.0

# Animation names (set these to match your SpriteFrames)
@export var anim_idle := "idle"
@export var anim_walk := "walk"
@export var anim_shoot := "shoot" # or "cast"

var facing := 1 # 1 = right, -1 = left

@onready var wall_ray: RayCast2D = $WallRay
@onready var floor_ray: RayCast2D = $FloorRay
@onready var timer: Timer = $ShootTimer

@onready var visuals: Node2D = $Visuals
@onready var anim: AnimatedSprite2D = $Visuals/Anim
@onready var wand_tip: Marker2D = $Visuals/WandTip

func _ready() -> void:
	_apply_facing()

	# start moving animation
	if anim.sprite_frames and anim.sprite_frames.has_animation(anim_walk):
		anim.play(anim_walk)
	elif anim.sprite_frames and anim.sprite_frames.has_animation(anim_idle):
		anim.play(anim_idle)

	timer.wait_time = shoot_interval
	timer.timeout.connect(_shoot)
	timer.start()

func _physics_process(delta: float) -> void:
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# patrol
	velocity.x = facing * move_speed
	move_and_slide()

	# turn around if wall ahead OR no ground ahead
	if wall_ray.is_colliding() or not floor_ray.is_colliding():
		_turn_around()

func _turn_around() -> void:
	facing *= -1
	_apply_facing()

func _apply_facing() -> void:
	# flip only visuals (wand tip flips with it)
	visuals.scale.x = facing

	# keep rays pointing forward (so edge/wall checks work)
	wall_ray.target_position.x = abs(wall_ray.target_position.x) * facing
	floor_ray.target_position.x = abs(floor_ray.target_position.x) * facing

func _shoot() -> void:
	if fireball_scene == null:
		return

	# shoot anim if exists
	if anim.sprite_frames and anim.sprite_frames.has_animation(anim_shoot):
		anim.play(anim_shoot)

	var f = fireball_scene.instantiate()
	f.global_position = wand_tip.global_position
	f.direction = Vector2.RIGHT if facing > 0 else Vector2.LEFT
	f.speed = fireball_speed
	get_tree().current_scene.add_child(f)

	# go back to walk (optional)
	if anim.sprite_frames and anim.sprite_frames.has_animation(anim_walk):
		anim.play(anim_walk)
