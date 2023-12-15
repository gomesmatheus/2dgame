extends RigidBody2D

func _ready():
	var mob_types = ["walk", "fly", "swim"]
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	linear_velocity = Vector2(0, 0)
	$AnimatedSprite2D.set_deferred("scale", Vector2(0.5, 0.5))
	$CollisionShape2D.set_deferred("disabled", "true")
	$AnimatedSprite2D.play("explode")
	await get_tree().create_timer(2.0).timeout
	hide()
	queue_free()
