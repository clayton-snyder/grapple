extends Node2D

var velocity : Vector2 = Vector2.ZERO
var distance : float = 0.0
var firing : bool = false
var attached : bool = false
var attached_to : Node2D


const MAX_DIST : float = 175.0
const SPEED : float = 400.0

func throw():
	firing = true

# Called when mouse/trigger released to release grapple
func release():
	attached = false
	attached_to = null
	reset()

func _ready():
	$rope.set_collide_with_areas(true)
	$rope.set_collide_with_bodies(false)
	$rope.set_enabled(true)
	$rope.set_cast_to(Vector2.ZERO)

func _process(delta):
	if attached:
		self.rotation = Vector2.UP.angle_to(\
			attached_to.get_global_position() - self.get_parent().get_global_position())
#		$point.position.y = -get_parent().get_global_position().distance_to(attached_to.get_global_position())
		$point.position.y = -distance
	else:
		# rotate the hook and have point just travel on y
		self.rotation = Vector2.UP.angle_to(\
			get_global_mouse_position() - self.get_parent().get_global_position())
		if firing and distance < MAX_DIST:
			distance += SPEED * delta
			$point.position.y = -distance
		
		$rope.set_cast_to($point.position)
		
		if $rope.is_colliding() and firing:
			var collider = $rope.get_collider()
			print(collider.get_name())
			self.get_parent().attach_to(collider)
			attached = true
			attached_to = collider
			distance = get_parent().get_global_position().distance_to(attached_to.get_global_position())
	
	$rope/Line2D.clear_points()
	$rope/Line2D.add_point(self.position)
	$rope/Line2D.add_point($point.position)
	

func reset():
	firing = false
	$point.position = Vector2.ZERO
	distance = 0
	$rope/Line2D.clear_points()
	attached = false


