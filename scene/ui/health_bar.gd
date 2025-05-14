extends CanvasLayer

@export var health_component: HealthComponent
@onready var texture_progress_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

func _ready() -> void:
	texture_progress_bar.value = 1
	health_component.health_changed.connect(on_health_changed)

func on_health_changed():
	texture_progress_bar.value = health_component.get_health_value()
	
