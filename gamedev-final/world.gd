extends Node2D

@export var scrap_needed := 3

var scrap := 0
var game_won := false

@onready var scrap_label: Label = $UI/Label
@onready var win_panel = $UI/Control

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

	win_panel.visible = true
	get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
