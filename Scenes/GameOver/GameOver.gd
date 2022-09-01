extends Control

const score_format_str : String = "You travelled %s pixels before being burned to a crisp.\n"


func _ready():
	$ScoreLabel.text = score_format_str % Global.last_score
	if Global.last_score == Global.high_score:
		$ScoreLabel.text += "New hiscore!"
	else:
		$ScoreLabel.text += "Your hiscore is %s." % Global.high_score

func _on_ExitButton_pressed():
	get_tree().quit()

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")

func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://Scenes/level/survivaldemo/survivaldemo_level.tscn")
