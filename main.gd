extends Node

const HIGH_SCORE_PATH := "user://highscore.save"

const COOL_BAR_COLOR := Color(0.25, 0.8, 0.3)
const HOT_BAR_COLOR := Color(0.9, 0.15, 0.1)

var score := 0
var high_score := 0
var _countdown := 3
var _heat_fill: StyleBoxFlat


func _ready() -> void:
	high_score = _load_high_score()

	_style_heat_bar()

	$deathScreen.visible = false
	$startScreen.visible = true
	$Player.visible = false
	$StartingLine.visible = false
	$HUD/ScoreLabel.hide()
	$HUD/countdownTimer.hide()
	$HUD/HeatBar.hide()
	$HUD/HeatLabel.hide()

	$Player.hit.connect(_on_player_hit)
	$Player.heat_changed.connect(_on_heat_changed)
	$startScreen.startPressed.connect(_on_start_pressed)
	$ObstacleSpawner.scored.connect(_on_scored)


func _style_heat_bar() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0, 0, 0, 0.4)
	bg.set_corner_radius_all(4)
	$HUD/HeatBar.add_theme_stylebox_override("background", bg)

	_heat_fill = StyleBoxFlat.new()
	_heat_fill.bg_color = COOL_BAR_COLOR
	_heat_fill.set_corner_radius_all(4)
	$HUD/HeatBar.add_theme_stylebox_override("fill", _heat_fill)


func _on_heat_changed(ratio: float) -> void:
	$HUD/HeatBar.value = ratio * 100.0
	_heat_fill.bg_color = COOL_BAR_COLOR.lerp(HOT_BAR_COLOR, ratio)


func _on_start_pressed() -> void:
	$startScreen.visible = false
	$Player.visible = true
	$StartingLine.visible = true

	_countdown = 3
	$HUD/countdownTimer.text = str(_countdown)
	$HUD/countdownTimer.show()
	$startTimer.start()


func _on_start_timer_timeout() -> void:
	_countdown -= 1
	if _countdown > 0:
		$HUD/countdownTimer.text = str(_countdown)
	elif _countdown == 0:
		$HUD/countdownTimer.text = "GO!"
	else:
		$startTimer.stop()
		$HUD/countdownTimer.hide()
		_start_game()


# Hand control to the player and start showing the score.
func _start_game() -> void:
	$Player.freeze = false
	score = 0
	$HUD/ScoreLabel.text = "0"
	$HUD/ScoreLabel.show()
	$HUD/HeatBar.show()
	$HUD/HeatLabel.show()


func _on_scored() -> void:
	score += 1
	$HUD/ScoreLabel.text = str(score)


func _on_player_hit(cause: String) -> void:
	if score > high_score:
		high_score = score
		_save_high_score(high_score)
	$HUD/ScoreLabel.hide()
	$deathScreen.set_scores(score, high_score, cause)
	$deathScreen.visible = true


func _load_high_score() -> int:
	if not FileAccess.file_exists(HIGH_SCORE_PATH):
		return 0
	var f := FileAccess.open(HIGH_SCORE_PATH, FileAccess.READ)
	if f == null:
		return 0
	var value := int(f.get_line())
	f.close()
	return value


func _save_high_score(value: int) -> void:
	var f := FileAccess.open(HIGH_SCORE_PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_line(str(value))
	f.close()
