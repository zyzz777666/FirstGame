extends Node
class_name DamageComponent

signal damage_dealt(amount: float, target: Node)

@export var damage_amount: float = 1.0
@export var can_deal_damage: bool = true

func deal_damage(target_health_component: HealthComponent) -> bool:
	if !can_deal_damage or target_health_component == null:
		return false

	target_health_component.take_damage(damage_amount)
	damage_dealt.emit(damage_amount, target_health_component.owner)
	return true
