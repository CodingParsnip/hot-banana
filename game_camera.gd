extends Camera2D
## Frames the action: zooms in so the pipes fill the view (their caps run off
## the top and bottom edges) and keeps the banana on screen. Follows the player
## horizontally with a fixed left margin, and vertically within a band clamped
## so the floor/sky never open up into empty voids.

## Zoom factor. Higher = more zoomed in / bigger assets.
@export var zoom_level: float = 1.8
## Where the player sits horizontally, as a fraction from the left edge.
@export var follow_margin: float = 0.32
## World y of the ground; the vertical clamp is derived from this so the floor
## sits at the bottom edge and no void shows below it.
@export var floor_y: float = 648.0

@export var player_path: NodePath = ^"../Player"
@onready var _player: Node2D = get_node_or_null(player_path)

var _min_center_y: float
var _max_center_y: float


func _ready() -> void:
	anchor_mode = ANCHOR_MODE_DRAG_CENTER
	zoom = Vector2(zoom_level, zoom_level)
	var half_view_h := get_viewport_rect().size.y / zoom_level / 2.0
	_min_center_y = half_view_h
	_max_center_y = floor_y - half_view_h


func _process(_delta: float) -> void:
	if _player == null:
		return
	var view := get_viewport_rect().size / zoom_level
	global_position.x = _player.global_position.x + view.x * (0.5 - follow_margin)
	global_position.y = clampf(_player.global_position.y, _min_center_y, _max_center_y)
