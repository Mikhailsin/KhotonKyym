extends Node2D

const POINTS_PER_CORRECT = 333333
@onready var hat_sprite = $Katya/HatSprite
@onready var jacket_sprite = $Katya/JacketSprite
@onready var accessory_sprite = $Katya/AccessorySprite
@onready var memorize_timer = $MemorizeTimer
@onready var cycle_timer = $CucleTimer
@export var hat_textures: Array[Texture2D] = []
@export var jacket_textures: Array[Texture2D] = []
@export var accessory_textures: Array[Texture2D] = []
enum State { MEMORIZE, GUESS_HAT, GUESS_JACKET, GUESS_ACCESSORY, EVALUATE, DONE }
var current_state: State = State.MEMORIZE
var target_hat: int
var target_jacket: int
var target_accessory: int
var current_guess_index: int = 0
var chosen_hat: int = -1
var chosen_jacket: int = -1
var chosen_accessory: int = -1
var total_score: int = 0
var correct_count: int = 0

func _ready():
	Global.current_game = "game3"
	Global.reset_score()
	hide_all_clothes()
	start_round()

func start_round():
	target_hat = randi() % 3
	target_jacket = randi() % 3
	target_accessory = randi() % 3
	hat_sprite.texture = hat_textures[target_hat]
	jacket_sprite.texture = jacket_textures[target_jacket]
	accessory_sprite.texture = accessory_textures[target_accessory]
	hat_sprite.show()
	jacket_sprite.show()
	accessory_sprite.show()
	current_state = State.MEMORIZE
	memorize_timer.start()

func _on_memorize_timer_timeout():
	hide_all_clothes()
	current_state = State.GUESS_HAT
	start_guessing_phase()

func start_guessing_phase():
	current_guess_index = 0
	update_guess_visuals()
	cycle_timer.start()

func _on_cycle_timer_timeout():
	current_guess_index = (current_guess_index + 1) % 3
	update_guess_visuals()

func update_guess_visuals():
	match current_state:
		State.GUESS_HAT:
			hat_sprite.texture = hat_textures[current_guess_index]
			hat_sprite.show()
		State.GUESS_JACKET:
			jacket_sprite.texture = jacket_textures[current_guess_index]
			jacket_sprite.show()
		State.GUESS_ACCESSORY:
			accessory_sprite.texture = accessory_textures[current_guess_index]
			accessory_sprite.show()

func _input(event):
	if event.is_action_pressed("play"): # Пробел
		if current_state in [State.GUESS_HAT, State.GUESS_JACKET, State.GUESS_ACCESSORY]:
			confirm_choice()

func confirm_choice():
	cycle_timer.stop()
	match current_state:
		State.GUESS_HAT:
			chosen_hat = current_guess_index
			current_state = State.GUESS_JACKET
			start_guessing_phase()
		State.GUESS_JACKET:
			chosen_jacket = current_guess_index
			current_state = State.GUESS_ACCESSORY
			start_guessing_phase()
		State.GUESS_ACCESSORY:
			chosen_accessory = current_guess_index
			current_state = State.EVALUATE
			evaluate_results()

func evaluate_results():
	# Считаем очки
	if chosen_hat == target_hat:
		Signals.IncrementScore.emit(POINTS_PER_CORRECT) 
		correct_count += 1
		
	if chosen_jacket == target_jacket:
		Signals.IncrementScore.emit(POINTS_PER_CORRECT) 
		correct_count += 1
		
	if chosen_accessory == target_accessory:
		Signals.IncrementScore.emit(POINTS_PER_CORRECT) 
		correct_count += 1
	print("Очки за игру 3: ", Global.scores["game3"])
	print("Всего очков за все игры: ", Global.get_total())
	if correct_count == 0:
		pass 
	else:
		finish_game()

func finish_game():
	current_state = State.DONE
	get_tree().change_scene_to_file("res://scenes/screens/resultPage/ResultPage.tscn")

func hide_all_clothes():
	hat_sprite.hide()
	jacket_sprite.hide()
	accessory_sprite.hide()


func _on_cucle_timer_timeout() -> void:
	current_guess_index = (current_guess_index + 1) % 3
	update_guess_visuals()
