extends Node


# Called when the node enters the scene tree for the first time.
# Player and mobs start disabled
func _ready():
	$deathScreen.visible = false
	$startScreen.visible = true
	$CharacterBody2D.connect("hit", _on_player_hit)
	$CharacterBody2D.visible = false
	$obstacle.visible = false
	
	$startScreen.connect("startPressed", _on_start_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Make scene ready for gameplay (render player, mobs, lives, points, etc)
func start_game():
	$CharacterBody2D.freeze = false
	$CharacterBody2D.visible = true
	print("ASS")
	$obstacle.visible = false
	pass

func _on_player_hit(): 
	$deathScreen.visible = true

func _on_start_pressed():
	$startScreen.visible = false
	$startTimer.start()


func _on_start_timer_timeout():
	start_game() 
