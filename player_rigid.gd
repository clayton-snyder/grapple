extends RigidBody2D

const SPEED : float = 200.0
const JUMP_POWER : float = 200.0
var move_dir : Vector2 = Vector2(0, 0)

func _integrate_forces(state):
	move_dir = Vector2(Input.get_action_strength("player_right") - Input.get_action_strength("player_left"), 0).normalized()
	state.linear_velocity.x = (move_dir * SPEED).x
	
	if Input.is_action_just_pressed("player_jump"):
		self.apply_central_impulse(Vector2.UP * JUMP_POWER)
