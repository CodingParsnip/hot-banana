extends Node

var countdown = 3

# Called when the node enters the scene tree for the first time.
# Player and mobs start disabled
func _ready():
	$deathScreen.visible = false
	$startScreen.visible = true
	$Player.connect("hit", _on_player_hit)
	$Player.visible = false
	$StartingLine.visible = false
	
	$startScreen.connect("startPressed", _on_start_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		get_node("countdownTimer").text = str(int(countdown + 1))

# Make scene ready for gameplay (render player, mobs, lives, points, etc)
func start_game():
	$Player.freeze = false
	$Player.visible = true
	$StartingLine.visible = true
	print("ASS")
	

func _on_player_hit(): 
	$deathScreen.visible = true

func _on_start_pressed():
	$startScreen.visible = false
	
	get_node("countdownTimer").text = str(int(countdown))
	get_node("countdownTimer").show()
	
	
	$Player.visible = true
	$StartingLine.visible = true
	
	$startTimer.start()

func _on_start_timer_timeout():
	start_game()
	get_node("countdownTimer").hide() 


