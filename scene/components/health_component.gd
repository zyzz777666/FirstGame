extends Node
class_name HealthComponent

signal died
signal health_changed
signal healed
signal damaged

@export var max_health: float = 10
@export var damage_text_scene: PackedScene
var current_health: float


func _ready():
	current_health = max_health
	Global.ability_upgrade_added.connect(on_ability_upgrade_added)


func take_damage(damage):
	var damage_text_instance = damage_text_scene.instantiate() as Node2D
	var front_layer = get_tree().get_first_node_in_group("front_layer") as Node2D
	front_layer.add_child(damage_text_instance)
	damage_text_instance.global_position = owner.global_position
	damage_text_instance.damage_text(damage)
	current_health = max(current_health - damage, 0)
	damaged.emit()
	health_changed.emit()
	Callable(check_death).call_deferred()
		

func take_heal(heal):
	current_health = min(current_health + heal, max_health)
	healed.emit()
	health_changed.emit()
	
func on_health_bottle_collected(health: float):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.health_component.take_heal(health)
		
	
func get_health_value():
	return current_health / max_health
	
	
func check_death():
	if current_health == 0:
		died.emit()

func is_alive() -> bool:
	return current_health > 0

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "max_health" and owner.is_in_group("player"):
		var health_percent = get_health_value()
		max_health += 2
		current_health = max_health * health_percent
		
		if current_health <= 0:
			current_health = 1
			
		health_changed.emit()
	
