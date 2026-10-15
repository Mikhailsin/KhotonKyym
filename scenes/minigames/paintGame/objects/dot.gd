extends CharacterBody2D

@export var speed: float = 200.0
@export var accel: float = 8.0     
@export var friction: float = 6.0
@export var min_dist: float = 5.0

@onready var trail: Line2D = get_node("../Contur/Line2D")

var _smooth_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	trail.add_point(global_position)

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")

	if input_dir != Vector2.ZERO:
		_smooth_dir = _smooth_dir.lerp(input_dir, accel * delta)
	else:
		_smooth_dir = _smooth_dir.lerp(Vector2.ZERO, friction * delta)

	if _smooth_dir.length() < 0.01:
		_smooth_dir = Vector2.ZERO

	velocity = _smooth_dir * speed
	move_and_slide()

	if trail.get_point_count() == 0 or global_position.distance_to(trail.get_point_position(trail.get_point_count() - 1)) >= min_dist:
		trail.add_point(global_position)
