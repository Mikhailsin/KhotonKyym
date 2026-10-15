extends Button

@onready var anim_light = get_node("../AnimatedSprite2D2")
@onready var anim_sprite = get_node("../AnimatedSprite2D")
@onready var camera = get_node("../Camera2D")

func _on_pressed() -> void:
	anim_sprite.play("default")
	await anim_sprite.animation_finished
	var tween = create_tween().set_parallel(true)
	tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	anim_light.play("light")
	await tween.finished
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://scenes/screens/mainPage/mainPage.tscn")
