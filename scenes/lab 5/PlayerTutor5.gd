extends CharacterBody2D

@export var gravity = 200.0
@export var walk_speed = 200
@export var jump_speed = -200
@export var dash_speed = 500.0      
@export var dash_duration = 0.2     
@export var double_tap_time = 0.3  

@export var sfx_jump: AudioStream 

var is_double_jumped = false
var isJumped = false
var isCrouched = false

var dash_timer = 0.0
var dash_direction = 0            
var last_left_tap = -10.0
var last_right_tap = -10.0

@onready var _animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	velocity.y += delta * gravity
	
	if dash_timer > 0:
		dash_timer -= delta
		velocity.x = dash_direction * dash_speed
		if dash_timer <= 0:
			dash_direction = 0
	else:
		# left dash
		if Input.is_action_just_pressed("ui_left"):
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time - last_left_tap < double_tap_time:
				dash_direction = -1
				dash_timer = dash_duration
				_animated_sprite.play("dash")
			last_left_tap = current_time

		# right dash
		if Input.is_action_just_pressed("ui_right"):
			var current_time = Time.get_ticks_msec() / 1000.0
			if current_time - last_right_tap < double_tap_time:
				dash_direction = 1
				dash_timer = dash_duration
				_animated_sprite.play("dash")
			last_right_tap = current_time

	if dash_timer <= 0:
		if Input.is_action_pressed("ui_left"):
			walk_speed = 200
			if (isCrouched):
				walk_speed = 100
			_animated_sprite.flip_h = true
			isCrouched = false
			velocity.x = -walk_speed
			_animated_sprite.play("walk")
		elif Input.is_action_pressed("ui_right"):
			walk_speed = 200
			if (isCrouched):
				walk_speed = 100
			_animated_sprite.flip_h = false
			isCrouched = false
			velocity.x = walk_speed
			_animated_sprite.play("walk")
		else:
			walk_speed = 200
			velocity.x = 0
			_animated_sprite.play("default")

	if is_on_floor() and isCrouched and Input.is_action_just_pressed("ui_up"):
		walk_speed = 200
		isCrouched = false
		_animated_sprite.play("default")
	elif is_on_floor() and Input.is_action_just_pressed("ui_up"):
		walk_speed = 200
		velocity.y = jump_speed
		load_sfx(sfx_jump)
		%sfx_player.play()
		is_double_jumped = false
		isJumped = true	
	elif not is_on_floor() and isJumped and not is_double_jumped and Input.is_action_just_pressed("ui_up"):
		walk_speed = 200
		velocity.y = jump_speed
		load_sfx(sfx_jump)
		%sfx_player.play()
		isJumped = true
		is_double_jumped = true

	if Input.is_action_pressed("ui_down"):
		isCrouched = true
		walk_speed = 100
		_animated_sprite.play("crouch")

	move_and_slide()

func load_sfx(sfx_to_load):
	if %sfx_player.stream != sfx_to_load:
		%sfx_player.stop()
		%sfx_player.stream = sfx_to_load
