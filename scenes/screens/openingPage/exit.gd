extends Button

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		_on_pressed()

func _on_pressed() -> void:
	get_tree().quit()
