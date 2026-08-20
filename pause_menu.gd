extends CanvasLayer
## ESC pause overlay. Runs while the tree is paused (process_mode = Always).
## Resume plays a 3-2-1 countdown before handing control back; Restart and
## Main menu emit signals that Main acts on.

signal restart_run
signal to_main_menu

@onready var _menu: CenterContainer = $Menu
@onready var _countdown: Label = $CountdownLabel
@onready var _timer: Timer = $ResumeTimer

var _count := 0


func _ready() -> void:
	visible = false
	_countdown.visible = false


func open() -> void:
	visible = true
	_menu.visible = true
	_countdown.visible = false
	get_tree().paused = true


func _on_resume_button_pressed() -> void:
	# Keep the game paused through a 3-2-1 countdown, then release it.
	_menu.visible = false
	_count = 3
	_countdown.text = str(_count)
	_countdown.visible = true
	_timer.start()


func _on_resume_timer_timeout() -> void:
	_count -= 1
	if _count > 0:
		_countdown.text = str(_count)
	elif _count == 0:
		_countdown.text = "GO!"
	else:
		_timer.stop()
		_countdown.visible = false
		visible = false
		get_tree().paused = false


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	restart_run.emit()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	to_main_menu.emit()
