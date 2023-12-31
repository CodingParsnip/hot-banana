extends Control

signal startPressed

func _start_button():
	emit_signal("startPressed")

func _on_button_pressed():
	emit_signal("startPressed")
	print("BOOP")
