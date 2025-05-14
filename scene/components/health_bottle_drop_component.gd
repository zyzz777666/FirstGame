extends Node

@export var health_bottle_drop_percent = 0
@export var health_bottle_scene: PackedScene
@export var health_component: Node

func _ready() -> void:
	(health_component as HealthComponent).died.connect(on_died)

func on_died():
	if randf_range(1, 100) < health_bottle_drop_percent:	
		return
		
	if health_bottle_scene == null:
		return
	
	if not owner is Node2D:
		return
	
	var spawn_pos = (owner as Node2D).global_position
	var health_bottle_instance = health_bottle_scene.instantiate() as Node2D
	owner.get_parent().add_child(health_bottle_instance)
	health_bottle_instance.global_position = spawn_pos
