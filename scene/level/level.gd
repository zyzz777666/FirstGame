extends Node

@export var end_screen_scene: PackedScene

@onready var player = %Player

var pause_menu_scene = preload("res://scene/ui/pause_menu.tscn")

func _ready():
	MusicPlayer.play()
	player.health_component.died.connect(on_died)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
	
	
func on_died():
	var end_screen_instance = end_screen_scene.instantiate() as EndScreen
	add_child(end_screen_instance)
	end_screen_instance.play_jingle()
