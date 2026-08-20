extends Node2D
## Procedural, endless obstacle spawner.
## Spawns pipe pairs (duo_obstacle) ahead of the player as it flies right,
## despawns them once they are well behind, and emits `scored` when the
## player clears each pair.

signal scored

const OBSTACLE_SCENE := preload("res://duo_obstacle.tscn")

# --- Tunables (adjust in the editor Inspector or here) ---------------------
## X of the first procedural pipe. Kept past the authored StartingLine intro
## so they never overlap.
@export var first_spawn_x: float = 2200.0
## Horizontal distance between consecutive pipe pairs.
@export var spacing: float = 600.0
## Spawn the next pair once the player is within this distance of its slot.
@export var spawn_ahead: float = 1400.0
## Free a pair once the player is this far past it.
@export var despawn_behind: float = 900.0
## The pipe collision sits ~this many px right of the duo_obstacle origin.
## Only affects when the score ticks over; tweak if it feels off.
@export var pipe_x_offset: float = 544.0
## Vertical range for the pipe-pair origin. Higher = gap lower on screen.
@export var gap_y_min: float = 40.0
@export var gap_y_max: float = 320.0
# --------------------------------------------------------------------------

@export var player_path: NodePath = ^"../Player"
@onready var _player: Node2D = get_node_or_null(player_path)

var _next_spawn_x: float
var _active: Array = []  # each entry: { "node": Node2D, "scored": bool }


func _ready() -> void:
	_next_spawn_x = first_spawn_x


func _process(_delta: float) -> void:
	# Only run once the player is live (unfrozen) and present.
	if _player == null or _player.freeze:
		return

	var px: float = _player.global_position.x

	# Spawn any pairs whose slot the player is approaching.
	while px + spawn_ahead > _next_spawn_x:
		_spawn(_next_spawn_x)
		_next_spawn_x += spacing

	# Award score for cleared pairs and cull ones left behind.
	for entry in _active.duplicate():
		var node: Node2D = entry["node"]
		if not is_instance_valid(node):
			_active.erase(entry)
			continue
		var pass_x: float = node.global_position.x + pipe_x_offset
		if not entry["scored"] and px > pass_x:
			entry["scored"] = true
			scored.emit()
		if px - pass_x > despawn_behind:
			_active.erase(entry)
			node.queue_free()


func _spawn(x: float) -> void:
	var ob: Node2D = OBSTACLE_SCENE.instantiate()
	ob.global_position = Vector2(x, randf_range(gap_y_min, gap_y_max))
	add_child(ob)
	_active.append({ "node": ob, "scored": false })
