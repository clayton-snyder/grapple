extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to(load("res://Scenes/MainMenu/MainMenu.tscn"))

func _on_lava_pit_1_area_entered(area):
	$player.velocity = Vector2.DOWN * 250
	$player.global_position = $lava_pit_1_respawn.global_position

func _on_lava_pit_2_area_entered(area):
	$player.velocity = Vector2.DOWN * 250
	$player.global_position = $lava_pit_2_respawn.global_position

func _on_level_bounds_area_entered(area):
	get_tree().change_scene_to(load("res://Scenes/MainMenu/MainMenu.tscn"))
