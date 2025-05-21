extends Node


@export var max_speed: int = 50
@export var acceleration: float = 5

var current_velocity = Vector2.ZERO

var slow_factor = 0.0
var slow_timer = 0.0

func _process(delta):
	if slow_timer > 0:
		slow_timer -= delta
		if slow_timer <= 0:
			slow_factor = 0.0

func move_to_player(mob: CharacterBody2D):
	var direction = get_direction()
	var velocity = accelerate_to_direction(direction)
	mob.velocity = velocity
	mob.move_and_slide()

func get_direction():
	var mob = owner as Node2D
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player != null:
		return (player.global_position - mob.global_position).normalized()
	return Vector2(0,0)


func accelerate_to_direction(direction: Vector2):
	var effective_max_speed = max_speed * (1.0 - slow_factor)
	var final_velocity = effective_max_speed * direction
	current_velocity = current_velocity.lerp(final_velocity, 1 - exp(-acceleration * get_process_delta_time()))
	return current_velocity


func apply_slow(factor: float, duration: float):
	if factor > slow_factor:
		slow_factor = clamp(factor, 0.0, 1.0)
		slow_timer = duration
