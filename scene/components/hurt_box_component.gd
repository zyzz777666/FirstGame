extends Area2D
class_name HurtBoxComponent


@export var health_component: HealthComponent
@export var hit_sound_component: AudioStreamPlayer2D


func _on_area_entered(area: Area2D):
	if not area is HitBoxComponent:
		return
		
	if health_component == null:
		return
		
	var hit_box_component = area as HitBoxComponent
	health_component.take_damage(hit_box_component.damage)
	hit_sound_component.play()
	
	if hit_box_component.slow_factor > 0 and hit_box_component.slow_duration > 0:
		var enemy = self.get_parent()
		if enemy and enemy.has_node("MovementComponent"):
			var movement_component = enemy.get_node("MovementComponent")
			movement_component.apply_slow(hit_box_component.slow_factor, hit_box_component.slow_duration)
			
	if hit_box_component.axe_ability and hit_box_component.axe_ability.has_push_away_upgrade:
		var enemy = self.get_parent()
		var player = hit_box_component.axe_ability.player_ref
		if enemy and player and enemy.health_component and enemy.health_component.is_alive():
			var direction = (enemy.global_position - player.global_position).normalized()
			var push_distance = 75
			enemy.global_position += direction * push_distance
