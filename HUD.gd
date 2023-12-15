extends CanvasLayer

# Notifies main when button is pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_score(score):
	$ScoreLabel.text = str(score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Perdeu bobo")
	
	await $MessageTimer.timeout
	
	$Message.text = "Fuja dos bicho!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
