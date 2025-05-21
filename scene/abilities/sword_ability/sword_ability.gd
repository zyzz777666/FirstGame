extends Node2D
class_name SwordAbility

@onready var hit_box_component: HitBoxComponent = $Sprite2D/HitBoxComponent

var attached_player = null
var offset = Vector2.ZERO
var initial_direction = 1
var slow_factor = 0.3
var slow_duration = 1.0

func attach_to_player(player, custom_offset = null):
	attached_player = player

	if player.has_node("AnimatedSprite2D"):
		initial_direction = sign(player.get_node("AnimatedSprite2D").scale.x)
	
	if custom_offset != null:
		offset = custom_offset
	else:
		offset = Vector2(40.0 * initial_direction, 0.0)
	
	hit_box_component.slow_factor = slow_factor
	hit_box_component.slow_duration = slow_duration
	
	
func _process(delta):
	if attached_player != null:
		global_position = attached_player.global_position + offset


func set_slow_parameters(factor: float, duration: float):
	slow_factor = factor
	slow_duration = duration
	if hit_box_component:
		hit_box_component.slow_factor = factor
		hit_box_component.slow_duration = duration
