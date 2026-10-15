extends Node

var count_300: int = 0
var count_100: int = 0
var count_50: int = 0
var count_0: int = 0

func _ready() -> void:
	Signals.RegisterHit.connect(_on_register_hit)

func _on_register_hit(hit_value: int) -> void:
	match hit_value:
		300: count_300 += 1
		100: count_100 += 1
		50:  count_50 += 1
		_:   count_0 += 1

func get_accuracy() -> float:
	var total: int = count_300 + count_100 + count_50 + count_0
	if total == 0:
		return 0.0
	return float(300 * count_300 + 100 * count_100 + 50 * count_50) / float(300 * total)
	
func finish_minigame() -> int:
	var acc: float = get_accuracy()
	var score: int = int(acc * 1_000_000.0)
	if Global.current_game != "":
		Global.scores[Global.current_game] = score
	_reset()
	print("acc=", acc, " | score=", score, " | total=", Global.get_total())
	return score

func _reset() -> void:
	count_300 = 0
	count_100 = 0
	count_50 = 0
	count_0 = 0
