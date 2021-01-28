extends KinematicBody2D

const UP = Vector2(0,-1)
const WALL_JUMP_VELOCITY = Vector2(400, -400)

export var move_speed = 140
export var max_jump_speed = -410
export var min_jump_speed = -150
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.4
export var gravity = 1500

var velocity = Vector2()
var is_jumping = false
var extra_jumps = 0
var move_direction
var wall_direction = 1

onready var sprite = $AnimatedSprite
onready var ray_right = $RayCastContainer/RayRight
onready var ray_left = $RayCastContainer/RayLeft

func _apply_gravity(delta):
	velocity.y += gravity * delta
	
	if is_jumping and velocity.y >= 0:
		is_jumping = false

func _apply_wall_gravity():
	var max_velocity = 64 if !Input.is_action_pressed("move_down") else 128
	velocity.y = min(velocity.y, max_velocity)

func _apply_movement():
	if is_on_floor():
		extra_jumps = 0
	
	var snap = Vector2.DOWN * 4 if !is_jumping else Vector2.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, UP)

func _update_move_direction():
	var press_right = Input.is_action_pressed("move_right")
	var press_left = Input.is_action_pressed("move_left")
	
	move_direction = -int(press_left) + int(press_right)

func _update_wall_direction():
	var wall_right = ray_right.is_colliding()
	var wall_left = ray_left.is_colliding()
	
	if wall_right:
		wall_direction = 1
	elif wall_left:
		wall_direction = -1
	else: 
		wall_direction = 0

func _handle_movement():
	if move_direction != 0:
		velocity.x = lerp(velocity.x, move_direction * move_speed, acceleration)
		sprite.scale.x = move_direction
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _jump():
	velocity.y = max_jump_speed
	is_jumping = true
	extra_jumps += 1

func _wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	wall_jump_velocity.x *= -wall_direction
	velocity = wall_jump_velocity
	sprite.scale.x *= -1
	extra_jumps = 0

func _variable_jump():
	if velocity.y < min_jump_speed:
		velocity.y = min_jump_speed
