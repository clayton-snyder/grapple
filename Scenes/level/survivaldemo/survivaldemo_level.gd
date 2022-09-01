extends Node2D

var SCN_GAME_OVER : PackedScene = preload("res://Scenes/GameOver/GameOver.tscn")

var lava_curr_speed : float = 60.0
export var lava_base_speed : float = 40.0
export var lava_boost_dist : float = 1000.0
export var lava_speed_boost : float = 25.0
export var min_lava_dist : float = 2350.0
var player_dead : bool = false

var point_create_y : float = 0.0
var point_create_timer : float = 0.0
var death_zone_dist : float = 0.0
export var point_create_rate : float = 0.5
var rng : RandomNumberGenerator
var player_start_y : float
var player_dist_travelled : float

var point_scene = preload("res://Terrain/grapplable/grapplable.tscn")

func _ready():
	player_dead = false
	death_zone_dist = $death_zone.position.y - $player.position.y
	rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(10):
		increment_point()
	player_start_y = $player.global_position.y

func _process(delta):
	if player_dead:
		$player.velocity = Vector2.ZERO
		return
	
	death_zone_dist = $death_zone.position.y - $player.position.y

	if death_zone_dist > min_lava_dist:
		$death_zone.position.y = $player.position.y + min_lava_dist
	if death_zone_dist > lava_boost_dist:
		lava_curr_speed = lava_base_speed + lava_speed_boost
	else:
		lava_curr_speed = lava_base_speed
	$death_zone.position.y -= lava_curr_speed * delta
	point_create_timer += delta
	if point_create_timer >= point_create_rate:
		point_create_timer = 0
		increment_point()
	
	$TileMap.position.y = $player.position.y
	
	player_dist_travelled = -($player.global_position.y - player_start_y)
	$HUD/Label.text = "Score: %s" % int(player_dist_travelled)

func _on_death_zone_area_entered(area: Area2D):
	$LavaSizzleAudioPlayer.play()
	player_dead = true
	$player.visible = false
	yield($LavaSizzleAudioPlayer, "finished")
	player_died()

func player_died():
	Global.last_score = int(player_dist_travelled)
	Global.high_score = max(Global.last_score, Global.high_score)
	get_tree().change_scene_to(SCN_GAME_OVER)

func increment_point():
	var new_point = point_scene.instance()
	new_point.position.x = rng.randf_range(100, 650.0)
	new_point.position.y = point_create_y
	self.add_child_below_node($player, new_point)
	point_create_y -= 150
