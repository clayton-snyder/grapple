extends Node2D


var survive_time : float = 0.0

var level_scene = preload("res://Scenes/level/survivaldemo/survivaldemo_level.tscn")
var game_over_scene = preload("res://Scenes/level/survivaldemo/survivaldemogameover.tscn")

var is_game_over : bool = true

func _ready():
	Engine.set_target_fps(Engine.get_iterations_per_second())
	var game_over_node : Node2D = game_over_scene.instance()
	game_over_node.name = "game_over"
	self.add_child(game_over_node)
	$game_over/score_label.text = "Advised to fullscreen this window \n\nW A S D + spacebar, click and hold to shoot grapple. \n" +\
		"When you are hanging from a point, use A and D to swing left/right and build momentum\n\n\n\t\tSPACE to start"
#	play()

func _process(delta):
	survive_time += delta
	if Input.is_action_just_pressed("ui_select") and is_game_over:
		play()

func game_over():
	is_game_over = true
	$level.queue_free()
	var game_over_node : Node2D = game_over_scene.instance()
	game_over_node.name = "game_over"
	self.add_child(game_over_node)
	$game_over/score_label.text = "SCORE: " + str(int(survive_time)) + " seconds \n\nSPACE to replay"
	

func play():
	if is_game_over:
		$game_over.queue_free()
		is_game_over = false
	
	survive_time = 0
	var level_node : Node2D = level_scene.instance()
	level_node.name = "level"
	self.add_child(level_node, true)
