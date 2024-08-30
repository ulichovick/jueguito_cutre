extends CharacterBody2D

@onready var dash_cooldown = $dash_cooldown
@onready var dash_timer = $dash_timer
const SPEED = 130.0
const JUMP_VELOCITY = -300.0
var is_dashing : bool = false
var can_dash : bool = true
@onready var jump = $jump
@onready var state_machine = $AnimationTree["parameters/playback"]
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump.play()

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("Left", "Right")
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dash_timer.start()
		is_dashing = true
	
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction ==0:
			state_machine.travel("idle")
		else:
			state_machine.travel("run")
	else:
		state_machine.travel("jump")
	
	if not is_dashing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else: 
		if direction:
			state_machine.travel("roll")
			velocity.x = direction * SPEED * 3
		else:
			state_machine.travel("roll")
			velocity.x = move_toward(velocity.x, 0, SPEED*3)
	move_and_slide()


func _on_dash_timer_timeout():
	is_dashing = false
	dash_cooldown.start()
	can_dash = false

func _on_dash_cooldown_timeout():
	can_dash = true
