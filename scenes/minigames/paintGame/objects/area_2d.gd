extends Area2D

const POINTS_PER_BALL: int = 10_000

func _on_body_entered(body: Node2D) -> void:
	Signals.IncrementScore.emit(POINTS_PER_BALL)
	queue_free()
