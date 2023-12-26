extends Control

signal startPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/countdown.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MarginContainer/HBoxContainer/VBoxContainer/countdown.visible = true

func _start_button():
	emit_signal("startPressed")


func _on_button_pressed():
	emit_signal("startPressed")
	print("BOOP")
