extends CharacterBody2D


@onready var timer = $Timer
@onready var hurtbox = $Hurtbox

const MAX_SPEED = 200.0
const ACCEL = 10.0
const JUMP_FORCE = -300.0
const WALL_JUMP_FORCE = 300.0
const DODGE_FORCE = 300.0
const X_KNOCKBACK = -350.0
const Y_KNOCKBACK = -200.0
const DODGE_TIME = 0.5
const COYOTE_TIME = 0.1
const MAX_JUMPS = 2


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_count = 0
var direction = 0
var action_time = 0.0
var coyote_time = 0.0
var action_cd = 0.0
var wall_slide_force = 10.0
var is_attacking = false
var can_dmg = true



func _process(delta):
	handle_input()


func _physics_process(delta):
	handle_movement(delta)
	
	move_and_slide()


func handle_input():
	direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("jump"):
		jump()
	
	

func handle_movement(delta):
	
	if is_on_floor():
		print("on floor")
		jump_count = MAX_JUMPS
		coyote_time = 0.0
		
		if direction:
			velocity.x = direction * MAX_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, MAX_SPEED)
	elif not is_on_floor():
		print("not on floor")
		velocity.y += gravity * delta
		coyote_time += delta
				
		if direction:
			velocity.x = direction * MAX_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (0.035 * MAX_SPEED))


func jump():
	if is_on_floor():
		velocity.y = JUMP_FORCE

	else:
		if coyote_time < COYOTE_TIME:
			velocity.y = JUMP_FORCE
			jump_count -= 1
		else:
			if jump_count > 0:
				velocity.y = JUMP_FORCE
				jump_count = 0




