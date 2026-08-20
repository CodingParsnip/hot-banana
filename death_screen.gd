extends Control
## Game-over overlay. Main calls set_scores() before showing it; the two
## buttons emit signals Main acts on (start a fresh run, or go to the menu).

signal play_again
signal main_menu

@onready var _cause: Label = $CenterContainer/VBoxContainer/CauseLabel
@onready var _score_label: Label = $CenterContainer/VBoxContainer/ScoreLabel
@onready var _high_label: Label = $CenterContainer/VBoxContainer/HighLabel


func set_scores(score: int, high_score: int, cause: String = "crash") -> void:
	_cause.text = "You overheated!" if cause == "overheat" else "Splat!"
	_score_label.text = "Score: %d" % score
	_high_label.text = "Best: %d" % high_score


func _on_play_again_pressed() -> void:
	play_again.emit()


func _on_main_menu_pressed() -> void:
	main_menu.emit()
