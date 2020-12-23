extends KinematicBody2D

# Bugs:
## Need to figure out how to fix the lerp issue. # FIXED (only lerp if on floor)
## if you let go of mouse in-air you get the weird jump thing
## divide by 0 if you rappel all the way up # FIXED
## direction doesn't work when you let go of point if you're swinging left (????) (has to do with multiplying l_vel by -1) # FIXED
## Set dist properly
## Gain too much speed when rappelling all the way up

var velocity : Vector2 = Vector2(0, 0)
var swing_vel : Vector2 = Vector2(0, 0)
var swing_scalar : float = 2.0
var a_vel : float = 0.0
var new_point : Vector2 = Vector2(0, 0)
var local_vec : Vector2 = Vector2(0, 0)
var ng_vel : float = 0.0
var move_speed : float = 200.0
var jump_power : float = 400.0
var gravity_swing : float = 1300.0
var gravity_norm : float = 900.0
var dist : float = 50.0

var attached : bool = false
var attached_to : Node2D
var rappel_speed : float = 170.0
var rappel_max_len : float = 170.0
var rappel_min_len : float = 40.0

const TERMINAL_VEL : float = 50000.0
const NORMAL_FLOOR : Vector2 = Vector2.UP

func _process(delta):
	if Input.is_action_just_pressed("player_shoot"):
		$hook.throw()
	if Input.is_action_just_released("player_shoot"):
		$hook.release()
		detach()

func _physics_process(delta):
	var x = 0
	if attached:
		var angle = Vector2.DOWN.angle_to(self.get_global_position() - attached_to.get_global_position())
		var a_accel : float =  (-gravity_swing / dist * sin(angle))
		a_vel += (a_accel * delta)
		var new_angle = angle + (a_vel * delta)
		new_point = (Vector2.DOWN.normalized() * dist).rotated(new_angle) + attached_to.get_global_position()
		local_vec = new_point - self.get_global_position()
		var coll : KinematicCollision2D = self.move_and_collide(local_vec)
		if coll:
			a_vel = 0
		
		if Input.is_action_pressed("player_up"):
			dist = max(dist - (rappel_speed * delta), rappel_min_len)
		if Input.is_action_pressed("player_down"):
			dist = min(dist + (rappel_speed * delta), rappel_max_len)
			
	else:
		if Input.is_action_pressed("player_left"):
			velocity.x = -1 * move_speed
		if Input.is_action_pressed("player_right"):
			velocity.x = move_speed
		if Input.is_action_just_pressed("player_jump") and self.is_on_floor():
			velocity.y = jump_power * -1

		velocity = self.move_and_slide(velocity, NORMAL_FLOOR)
		if self.is_on_floor():
			velocity.x = lerp(velocity.x, 0, 0.2)
		velocity.y = min(TERMINAL_VEL, velocity.y + gravity_norm * delta)

func attach_to(attached_to_body : Node2D):
	print("called attach_to with " + attached_to_body.get_name())
	attached = true
	attached_to = attached_to_body

func detach():
	var l_speed = (2 * PI * dist) * (a_vel / (2 * PI))
	var new_dir = local_vec.normalized()
	velocity = new_dir * abs(l_speed)
	attached = false
	attached_to = null
