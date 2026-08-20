extends Control

signal startPressed


func _on_button_pressed() -> void:
	startPressed.emit()
