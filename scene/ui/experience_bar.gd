extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var texture_progress_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

func _ready() -> void:
	texture_progress_bar.value = 0
	experience_manager.experience_update.connect(on_experience_updated)
	
func on_experience_updated(current_experience: float, target_experience: float):
	var current_value = current_experience / target_experience
	texture_progress_bar.value = current_value
