extends Node

const HIGH_SCORE_PATH := "user://highscore.save"

var score := 0
var high_score := 0
var _countdown := 3


func _ready() -> void:
	high_score = _load_high_score()

	$deathScreen.visible = false
	$startScreen.visible = true
	$Player.visible = false
	$StartingLine.visible = false
	$HUD/ScoreLabel.hide()
	$HUD/countdownTimer.hide()

	$Player.hit.connect(_on_player_hit)
	$startScreen.startPressed.connect(_on_start_pressed)
	$ObstacleSpawner.scored.connect(_on_scored)


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


func _on_scored() -> void:
	score += 1
	$HUD/ScoreLabel.text = str(score)


func _on_player_hit() -> void:
	if score > high_score:
		high_score = score
		_save_high_score(high_score)
	$HUD/ScoreLabel.hide()
	$deathScreen.set_scores(score, high_score)
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
