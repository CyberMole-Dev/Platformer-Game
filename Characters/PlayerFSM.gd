extends StateMachine

func _ready():
	_init_states()
	call_deferred("set_state", states.idle)

func _init_states():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("double_jump")
	add_state("wall_slide")

func _input(event):
	if [states.idle, states.run, states.jump, states.fall].has(state):
		if event.is_action_pressed("jump") and parent.extra_jumps < 1:
			parent._jump()
	elif state == states.wall_slide:
		if event.is_action_pressed("jump"):
			parent._wall_jump()
			set_state(states.jump)
	
	if state == states.jump:
		if event.is_action_released("jump"):
			parent._variable_jump()

func _state_logic(delta):
	parent._update_move_direction()
	parent._update_wall_direction()
	if state != states.wall_slide:
		parent._handle_movement()
	parent._apply_gravity(delta)
	if state == states.wall_slide:
		parent._apply_wall_gravity()
	parent._apply_movement()

func _get_transition(_delta):
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.move_direction != 0:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				else:
					return states.fall
			elif parent.move_direction == 0:
				return states.idle
		states.jump:
			if parent.velocity.y >= 0:
					return states.fall
			elif parent.velocity.y < 0 and parent.extra_jumps == 1:
				return states.double_jump
			elif parent.is_on_floor():
				return states.idle
		states.fall:
			if parent.wall_direction != 0:
				return states.wall_slide
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.double_jump
		states.double_jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
					return states.fall
		states.wall_slide:
			if parent.is_on_floor():
				return states.idle
			if parent.wall_direction == 0:
				return states.fall
	print(parent.sprite.scale.x)
	return null
	

func _enter_state(new_state, _old_state):
	match new_state:
		states.idle:
			parent.sprite.play("Idle")
		states.run:
			parent.sprite.play("Run")
		states.jump:
			parent.sprite.play("Jump")
		states.fall:
			parent.sprite.play("Fall")
		states.double_jump:
			parent.sprite.play("DoubleJump")
		states.wall_slide:
			parent.sprite.play("WallSlide")
			parent.sprite.scale.x = parent.wall_direction
