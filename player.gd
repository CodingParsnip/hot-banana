extends CharacterBody2D

signal hit

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var motion = Vector2()
var GRAVITY = 20

var freeze = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	#When no longer frozen, add gravity and handle inputs
	if (!freeze):		
		velocity.x = move_toward(velocity.x, 500, SPEED)
		motion.y += GRAVITY
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_pressed("ui_accept") and $JumpButtonTimer.is_stopped():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump")
			$JumpAnimTimer.start()
			$JumpButtonTimer.start()

		move_and_slide()
		var collision = get_last_slide_collision()
		if collision:
			var touch = collision.get_collider()
			if touch.name.contains("obstacle") || touch.name.contains("floor"):
				print(touch.name)
				emit_signal("hit")
				$AnimatedSprite2D.play("death")


func _on_jump_anim_timer_timeout():
	$AnimatedSprite2D.play("fall")

func _ready():
	$JumpAnimTimer.start()
