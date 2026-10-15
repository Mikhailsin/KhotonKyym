extends Node2D

@onready var label_first: Label = $first
@onready var label_second: Label = $second
@onready var label_third: Label = $third
@onready var label_total: Label = $all


func _ready() -> void:
	labels()
	
func labels():
	label_first.text = str(Global.scores["game1"])
	label_second.text = str(Global.scores["game2"])
	label_third.text = str(Global.scores["game3"])
	label_total.text = str(Global.get_total())
	
	
