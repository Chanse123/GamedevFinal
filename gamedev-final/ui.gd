extends CanvasLayer

var hearts = []

func _ready():
	hearts = $Hearts.get_children()

func update_hearts(current_health):
	if hearts.is_empty():
		return   # safety check

	for i in range(hearts.size()):
		hearts[i].visible = i < current_health
