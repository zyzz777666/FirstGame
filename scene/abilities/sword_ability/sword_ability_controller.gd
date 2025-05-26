extends Node

@export var sword_ability_scene: PackedScene
@export var spawn_distance: float = 40.0
@export var slow_factor: float = 0.5
@export var slow_duration: float = 2.0
@export var damage_frost_sword = 10.0

var damage_frost_sword_mulriplier = 1.0


func _ready():
	Global.ability_upgrade_added.connect(on_upgrade_added)

	
func _on_timer_timeout() -> void:
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var front_layer = get_tree().get_first_node_in_group("front_layer") as Node2D
	
	var closest_enemy = find_closest_enemy(player.global_position)
	
	var sword_ability_instance = sword_ability_scene.instantiate() as SwordAbility
	front_layer.add_child(sword_ability_instance)
	
	var direction = 1
	var offset = Vector2.ZERO
	
	if closest_enemy != null:
		direction = 1 if closest_enemy.global_position.x > player.global_position.x else -1
		offset = Vector2(spawn_distance * direction, 0.0)
	else:
		if player.has_node("AnimatedSprite2D"):
			direction = sign(player.get_node("AnimatedSprite2D").scale.x)
		offset = Vector2(spawn_distance * direction, 0.0)
	
	
	sword_ability_instance.global_position = player.global_position + offset
	sword_ability_instance.scale.x = direction
	sword_ability_instance.hit_box_component.damage = damage_frost_sword * damage_frost_sword_mulriplier
	
	sword_ability_instance.set_slow_parameters(slow_factor, slow_duration)
	
	sword_ability_instance.attach_to_player(player, offset)


func find_closest_enemy(from_position: Vector2) -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return null
		
	var closest_enemy = null
	var closest_distance = INF
	
	for enemy in enemies:
		if enemy is Node2D:
			var distance = from_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
	
	return closest_enemy

func on_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "frost_sword_damage":
		damage_frost_sword_mulriplier = 1 + (current_upgrades["frost_sword_damage"]["quantity"] * .10)
