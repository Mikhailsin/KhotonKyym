extends Node

var scores: Dictionary = {
	"game1": 0,
	"game2": 0,
	"game3": 0,
}
var current_game: String = ""

func _ready() -> void:
	Signals.IncrementScore.connect(_on_increment_score)

func _on_increment_score(incr: int) -> void:
	if current_game != "":
		scores[current_game] += incr

func reset_score() -> void:
	if current_game != "":
		scores[current_game] = 0

func get_total() -> int:
	var total := 0
	for v in scores.values():
		total += v
	return total

func save_result() -> void:
	pass 
