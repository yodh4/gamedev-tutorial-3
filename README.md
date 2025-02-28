1. Fitur Double Jump

    Untuk implementasi fitur ini saya menambahkan
    ```
    var is_double_jumped = false
    var isJumped = false
    ```
    dan memodifikasi conditional jump serta menambahkan conditional untuk double jump
    ```
    elif is_on_floor() and Input.is_action_just_pressed("ui_up"):
		walk_speed = 200
        velocity.y = jump_speed
		is_double_jumped = false
		isJumped = true
	elif not is_on_floor() and isJumped and not is_double_jumped and Input.is_action_just_pressed("ui_up"):
		walk_speed = 200
        velocity.y = jump_speed
		isJumped = true
		is_double_jumped = true
    ```

2. Fitur Dashing

    Untuk implementasi fitur ini saya menambahkan
    ```
    @export var dash_speed = 500.0     
    @export var dash_duration = 0.2     
    @export var double_tap_time = 0.3
    var dash_timer = 0.0
    var dash_direction = 0         
    var last_left_tap = -10.0
    var last_right_tap = -10.0
    ```

    lalu untuk mendeteksi input dash saya menambahkan conditional berikut
    ```
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
    ```

3. Fitur Crouching

    Untuk implementasi fitur ini saya hanya menambahkan conditional seperti berikut
    ```
    if Input.is_action_pressed("ui_down"):
		isCrouched = true
        walk_speed = 100
		_animated_sprite.play("crouch")
    ```

4. Fitur Walk Animation dan Revert Sprite
    Untuk implementasi fitur ini saya menambahkan condtional berikut
    ```
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
    ```