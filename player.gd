extends CharacterBody2D

## Emitted when the run ends. `cause` is "crash" (hit a pipe/floor) or
## "overheat" (the banana cooked itself).
signal hit(cause)
## Emitted each active frame with heat as a 0..1 ratio, for the HUD.
signal heat_changed(ratio)

const RUN_SPEED := 500.0        # cruising rightward speed
const ACCEL := 300.0            # how quickly we ramp up to RUN_SPEED
const JUMP_VELOCITY := -400.0

# --- Heat mechanic --------------------------------------------------------
const MAX_HEAT := 100.0
## Heat added by each flap.
@export var heat_per_flap: float = 14.0
## Heat shed per second while not flapping.
@export var cool_rate: float = 18.0
# --------------------------------------------------------------------------

const COOL_COLOR := Color(1, 1, 1)          # sprite tint at 0 heat
const HOT_COLOR := Color(1, 0.35, 0.25)     # sprite tint at max heat

## Set true by Main until the countdown finishes; also re-set on death.
var freeze := true
var heat := 0.0
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

	# Flap — costs heat.
	if Input.is_action_pressed("ui_accept") and $JumpButtonTimer.is_stopped():
		velocity.y = JUMP_VELOCITY
		heat = min(heat + heat_per_flap, MAX_HEAT)
		$AnimatedSprite2D.play("jump")
		$JumpAnimTimer.start()
		$JumpButtonTimer.start()

	# Passive cooling.
	heat = max(heat - cool_rate * delta, 0.0)

	var ratio := heat / MAX_HEAT
	heat_changed.emit(ratio)
	$AnimatedSprite2D.modulate = COOL_COLOR.lerp(HOT_COLOR, ratio)

	# Overheat: the banana bursts.
	if heat >= MAX_HEAT:
		_die("overheat")
		return

	move_and_slide()

	# Any contact with a pipe or the floor is fatal.
	for i in get_slide_collision_count():
		var collider := get_slide_collision(i).get_collider()
		if collider and (collider.is_in_group("obstacles") or collider.is_in_group("floor")):
			_die("crash")
			break


func _die(cause: String) -> void:
	if _dead:
		return
	_dead = true
	if cause == "overheat":
		$AnimatedSprite2D.modulate = HOT_COLOR
	$AnimatedSprite2D.play("death")
	hit.emit(cause)


func _on_jump_anim_timer_timeout() -> void:
	if not _dead:
		$AnimatedSprite2D.play("fall")
