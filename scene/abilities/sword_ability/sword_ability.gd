extends Node2D
class_name SwordAbility

@onready var hit_box_component: HitBoxComponent = $Sprite2D/HitBoxComponent

var attached_player = null
var offset = Vector2.ZERO
var initial_direction = 1

func attach_to_player(player, custom_offset = null):
	attached_player = player

	if player.has_node("AnimatedSprite2D"):
		initial_direction = sign(player.get_node("AnimatedSprite2D").scale.x)
	
	if custom_offset != null:
		offset = custom_offset
	else:
		offset = Vector2(40.0 * initial_direction, 0.0)

func _process(delta):
	if attached_player != null:
		global_position = attached_player.global_position + offset
