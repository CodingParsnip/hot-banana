extends Node

var countdown = 3

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
	if (countdown > 0 && !$startScreen.visible):
		countdown -= delta
	

# Make scene ready for gameplay (render player, mobs, lives, points, etc)
func start_game():
	$CharacterBody2D.freeze = false
	$CharacterBody2D.visible = true
	print("ASS")
	

func _on_player_hit(): 
	$deathScreen.visible = true

func _on_start_pressed():
	$startScreen.visible = false
	$startTimer.start()
	$CharacterBody2D.visible = true
	get_node("countdownTimer").show()
	get_node("countdownTimer").text = str(int(countdown))


func _on_start_timer_timeout():
	start_game()
	get_node("countdownTimer").hide() 


