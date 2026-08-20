extends Control
## Game-over overlay. Main calls set_scores() before showing it; the retry
## button reloads the scene for a fresh run.

@onready var _title_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var _score_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel
@onready var _high_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/HighLabel


func set_scores(score: int, high_score: int, cause: String = "crash") -> void:
	_title_label.text = "OVERHEATED!" if cause == "overheat" else "YOU DIED"
	_score_label.text = "Score: %d" % score
	_high_label.text = "Best: %d" % high_score


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
