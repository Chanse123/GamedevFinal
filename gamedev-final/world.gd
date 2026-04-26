extends Node2D

@export var scrap_needed := 3

var scrap := 0
var game_won := false

@onready var scrap_label: Label = $UI/Label

func _ready() -> void:
	_update_scrap_label()

func add_scrap() -> void:
	scrap += 1
	print("add_scrap called, scrap is now: ", scrap)
	_update_scrap_label()
	if scrap >= scrap_needed:
		_trigger_win()

func _update_scrap_label() -> void:
	scrap_label.text = "Scrap: %d / %d" % [scrap, scrap_needed]

func _trigger_win() -> void:
	if game_won:
		return
	game_won = true
	# Show win message by reusing the scrap label, or add a WinLabel node
	scrap_label.text = "YOU WIN!  Scrap: %d / %d" % [scrap, scrap_needed]
	# Pause the game after a short delay so the player sees the message
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = true
