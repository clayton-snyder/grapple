extends Control

const SCN_SURVIVAL : PackedScene = preload("res://Scenes/level/survivaldemo/survivaldemo_level.tscn")
const SCN_TUTORIAL : PackedScene = preload("res://Scenes/level/tutorial/tutorial_level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TutorialButton_pressed():
	get_tree().change_scene_to(SCN_TUTORIAL)


func _on_ExitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene_to(SCN_SURVIVAL)
