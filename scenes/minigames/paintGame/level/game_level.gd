extends Node2D

@export_file("*.tscn") var next_scene: String = ""
@export var game_duration: float = 15.0
@export var start_delay: float = 2.0
@onready var dot: CharacterBody2D = $Dot
@onready var contur: Node2D = $Contur
@onready var timer_label: Label = $TimerLabel
var time_left: float = 0.0
var timer_running: bool = false

func _ready() -> void:
	Global.current_game = "game1" 
	Global.reset_score()
	contur.hide()
	dot.modulate.a = 0.0
	dot.set_physics_process(false)
	timer_label.hide()
	await get_tree().create_timer(start_delay).timeout
	contur.show()
	dot.modulate.a = 1.0
	dot.set_physics_process(true)
	timer_label.show()
	time_left = game_duration
	timer_running = true
	_update_timer_label()

func _process(delta: float) -> void:
	if not timer_running:
		return
	time_left -= delta
	if time_left <= 0.0:
		time_left = 0.0
		_update_timer_label()
		timer_running = false
		_end_game()
		return
	_update_timer_label()

func _update_timer_label() -> void:
	timer_label.text = str(ceil(time_left))

func _end_game() -> void:
	Global.save_result()
	if next_scene != "":
		get_tree().change_scene_to_file(next_scene)
