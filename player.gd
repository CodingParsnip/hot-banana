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
	
	if (!freeze):
		motion.y += GRAVITY
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta


		# Handle jump.
		if Input.is_action_pressed("ui_accept") and $JumpButtonTimer.is_stopped():
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jump")
			$JumpAnimTimer.start()
			$JumpButtonTimer.start()




		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)


		move_and_slide()
		var collision = get_last_slide_collision()
		if collision:
			var hit = collision.get_collider()
			if hit.name.contains("obstacle"):
				print(hit.name)
				emit_signal("hit")
				$AnimatedSprite2D.play("death")





func _on_jump_anim_timer_timeout():
	$AnimatedSprite2D.play("fall")

func _ready():
	$JumpAnimTimer.start()
