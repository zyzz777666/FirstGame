extends Node2D
class_name AxeAbility

@onready var hit_box_component = $HitBoxComponent

const BASE_ROTATIONS: int = 2
const BASE_DURATION: float = 3.0

var axe_max_radius: int = 100
var base_direction: Vector2 = Vector2.RIGHT
var has_push_away_upgrade: bool = false
var additional_rotation: int = 0
var player_position: Vector2 = Vector2.ZERO
var player_ref: Node2D = null

var _total_rotations: int = BASE_ROTATIONS

func _ready():
	base_direction = base_direction.rotated(randf_range(0 , TAU))
	
	_total_rotations = BASE_ROTATIONS + additional_rotation
	
	var duration: float = BASE_DURATION * float(_total_rotations) / float(BASE_ROTATIONS)
	
	var tween = create_tween()
	tween.tween_method(rotation_animation, 0.0, _total_rotations, duration)
	tween.tween_callback(queue_free)
	

func rotation_animation(rotations):
	var percent = rotations / _total_rotations
	var axe_current_radius = percent * axe_max_radius
	var axe_current_direction = base_direction.rotated(rotations * TAU)
	
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player== null:
		return
		
	global_position = player.global_position + (axe_current_direction * axe_current_radius)
