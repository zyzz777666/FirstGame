extends Node

@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var upgrade_pool: UpgradePool = UpgradePool.new()
var fallback_pool: UpgradePool = UpgradePool.new()

var upgrade_scythe_rate = preload("res://resources/upgrades/scythe_rate.tres")
var upgrade_scythe_damage = preload("res://resources/upgrades/scythe_damage.tres")

var upgrade_throw_axe = preload("res://resources/upgrades/throw_axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_axe_push_away = preload("res://resources/upgrades/axe_push_away.tres")

var upgrade_move_speed = preload("res://resources/upgrades/move_speed.tres")
var upgrade_max_health = preload("res://resources/upgrades/max_health.tres")

var upgrade_frost_sword = preload("res://resources/upgrades/frost_sword.tres")
var upgrade_frost_sword_damage = preload("res://resources/upgrades/frost_sword_damage.tres")


var current_upgrades = {}


func _ready():
	upgrade_pool.add_upgrade(upgrade_scythe_rate, 10)
	upgrade_pool.add_upgrade(upgrade_scythe_damage, 10)
	upgrade_pool.add_upgrade(upgrade_throw_axe, 10)
	upgrade_pool.add_upgrade(upgrade_move_speed, 7)
	upgrade_pool.add_upgrade(upgrade_frost_sword, 10)
	
	fallback_pool.add_upgrade(upgrade_max_health, 10)
	
	experience_manager.level_up.connect(on_level_up)
	
	
func apply_upgrade (upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"upgrade": upgrade,
			"quantity": 1
		}
		
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
	
	update_upgrade_pool(upgrade)
	
	Global.ability_upgrade_added.emit(upgrade, current_upgrades)
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_upgrade(upgrade)


func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_throw_axe.id:
		upgrade_pool.add_upgrade(upgrade_axe_damage, 10)
		upgrade_pool.add_upgrade(upgrade_axe_push_away, 10)
	if chosen_upgrade.id == upgrade_frost_sword.id:
		upgrade_pool.add_upgrade(upgrade_frost_sword_damage, 10)
	
	
func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade]
	var max_upgrades = 3
	
	var main_pool_available = min(upgrade_pool.upgrades.size(), max_upgrades)
	for i in main_pool_available:
		if upgrade_pool.upgrades.size() == 0 or chosen_upgrades.size() >= max_upgrades:
			break
		var chosen_upgrade = upgrade_pool.pick_upgrade(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	if chosen_upgrades.size() < max_upgrades and fallback_pool.upgrades.size() > 0:
		var remaining_slots = max_upgrades - chosen_upgrades.size()
		var fallback_available = min(fallback_pool.upgrades.size(), remaining_slots)
		
		for i in fallback_available:
			if fallback_pool.upgrades.size() == 0:
				break
			var chosen_upgrade = fallback_pool.pick_upgrade(chosen_upgrades)
			chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades
		
		
func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	
	
func on_level_up (current_level):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	if chosen_upgrades.size() > 0:
		upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
		upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
	else:
		upgrade_screen_instance.queue_free()
