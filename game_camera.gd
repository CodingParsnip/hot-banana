extends Camera2D
## Follows the player horizontally, keeping it a fixed margin from the left
## edge (like the fixed-position bird in Flappy Bird). Vertical framing stays
## put so the whole play column is always visible.

## How far from the left edge the player sits, in pixels.
@export var follow_margin: float = 64.0
@export var player_path: NodePath = ^"../Player"

@onready var _player: Node2D = get_node_or_null(player_path)


func _process(_delta: float) -> void:
	if _player:
		global_position.x = _player.global_position.x - follow_margin
