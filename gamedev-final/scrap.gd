extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player detected, calling add_scrap()")
		get_tree().current_scene.add_scrap()
		print("Calling queue_free()")
		queue_free()
