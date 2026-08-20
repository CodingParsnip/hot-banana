extends CharacterBody2D

signal hit

const RUN_SPEED := 500.0        # cruising rightward speed
const ACCEL := 300.0            # how quickly we ramp up to RUN_SPEED
const JUMP_VELOCITY := -400.0

## Set true by Main until the countdown finishes; also re-set on death.
var freeze := true
var _dead := false

# Gravity from Project Settings so it matches any RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	$JumpAnimTimer.start()


func _physics_process(delta: float) -> void:
	if freeze or _dead:
		return

	# Constant rightward drive.
	velocity.x = move_toward(velocity.x, RUN_SPEED, ACCEL)

	# Gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Flap.
	if Input.is_action_pressed("ui_accept") and $JumpButtonTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
		$JumpAnimTimer.start()
		$JumpButtonTimer.start()

	move_and_slide()

	# Any contact with a pipe or the floor is fatal.
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider and (collider.is_in_group("obstacles") or collider.is_in_group("floor")):
			_die()
			break


func _die() -> void:
	if _dead:
		return
	_dead = true
	$AnimatedSprite2D.play("death")
	hit.emit()


func _on_jump_anim_timer_timeout() -> void:
	if not _dead:
		$AnimatedSprite2D.play("fall")
